const { body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  body('code')
    .exists()
    .withMessage('Code is required.')
    .custom(async (code) => {
      const archiveCode = await db.archiveCodes.findOne({ where: { code } });

      if (archiveCode) {
        throw new Error('Archive code already exists.');
      } else {
        return true;
      }
    }),
  body('description').optional(),
  body('scopeId')
    .exists()
    .withMessage('Scope id is required.')
    .custom(async (scopeId, { req }) => {
      const scope = await db.scopes.findByPk(scopeId);

      if (!scope) {
        throw new Error('Scope not found.');
      } else {
        req.scope = scope;
        req.scopesToCheck.push(scope.id);
        return true;
      }
    }),
];

async function postOneArchiveCode(req, res) {
  const { scopeId, ...archiveCodeData } = req.matchedData;

  let archiveCode = await req.scope.createArchiveCode(archiveCodeData);

  archiveCode = await db.archiveCodes.findByPk(archiveCode.id, {
    include: db.scopes,
  });

  return res.status(201).json({
    status: 'success',
    message: 'Archive code successfully created.',
    data: {
      archiveCode,
    },
  });
}

module.exports = [validate(validations), checkScopes, postOneArchiveCode];
