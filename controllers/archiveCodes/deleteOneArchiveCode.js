const { param } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  param('id')
    .exists()
    .withMessage('Archive code id is required.')
    .custom(async (id, { req }) => {
      const archiveCode = await db.archiveCodes.findByPk(id, {
        include: db.archives,
      });

      if (!archiveCode) {
        throw new Error('Archive code not found.');
      } else {
        req.archiveCode = archiveCode;
        req.scopesToCheck.push(archiveCode.ScopeId);
        return true;
      }
    }),
];

async function getAllArchiveCodes(req, res) {
  if (req.archiveCode.Archives.length > 0) {
    return res.status(400).json({
      status: 'fail',
      message: 'Archive code still has references.',
    });
  }

  await req.archiveCode.destroy();

  return res.status(200).json({
    status: 'success',
    message: 'Archive code successfully deleted.',
    data: {
      archiveCode: {
        id: req.matchedData.id,
      },
    },
  });
}

module.exports = [validate(validations), checkScopes, getAllArchiveCodes];
