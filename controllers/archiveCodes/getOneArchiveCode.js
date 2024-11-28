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
        include: db.scopes,
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

async function getOneArchiveCodes(req, res) {
  return res.status(200).json({
    status: 'success',
    message: 'Archive code successfully retrieved.',
    data: {
      archiveCode: req.archiveCode,
    },
  });
}

module.exports = [validate(validations), checkScopes, getOneArchiveCodes];
