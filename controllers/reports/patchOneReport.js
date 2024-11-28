const { param, body } = require('express-validator');

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
    } else if (
      ['leader', 'staff'].includes(req.user.role) &&
      report.createdBy !== req.user.id
    ) {
      throw new Error('Out of access.');
    } else {
      req.report = report;
      req.scopesToCheck.push(report.ScopeId);
      return true;
    }
  }),
  body('title').optional().isString(),
  body('description').optional().isString(),
];

async function patchOneReport(req, res) {
  const { id, ...reportData } = req.matchedData;

  await req.report.update(reportData);

  return res.status(200).json({
    status: 'success',
    message: 'Report successfully patched.',
    data: {
      report: req.report,
    },
  });
}

module.exports = [validate(validations), checkScopes, patchOneReport];
