const fs = require('fs');
const { param } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  param('id').custom(async (id, { req }) => {
    const report = await db.reports.findByPk(id, {
      include: [{ model: db.users }, { model: db.scopes }],
    });

    if (!report) {
      throw new Error('Report not found.');
    } else if (['leader', 'staff'].includes(req.user.role)) {
      if (report.createdBy !== req.user.id) {
        throw new Error('Out of access.');
      }
    } else {
      req.report = report;
      req.scopesToCheck.push(report.ScopeId);
      return true;
    }
  }),
];

async function deleteOneReport(req, res) {
  const reportsPath = './public/reports';
  const fileName = `${req.report.id}.pdf`;
  const filePath = `${reportsPath}/${fileName}`;

  fs.unlinkSync(filePath);

  await req.report.destroy();

  return res.status(200).json({
    status: 'success',
    message: 'Report successfully deleted.',
    data: {
      report: {
        id: req.matchedData.id,
      },
    },
  });
}

module.exports = [validate(validations), checkScopes, deleteOneReport];
