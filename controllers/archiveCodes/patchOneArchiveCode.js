const { param, body } = require('express-validator');

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
  body('code')
    .optional()
    .custom(async (code, { req }) => {
      const archiveCode = await db.archiveCodes.findOne({ where: { code } });

      if (archiveCode && code !== req.archiveCode.code) {
        throw new Error('Archive code already exists.');
      } else {
        return true;
      }
    }),
  body('description').optional(),
  body('scopeId')
    .optional()
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

async function patchOneArchiveCode(req, res) {
  const { id, scopeId, ...archiveCodeData } = req.matchedData;

  const patchOptions = { ...archiveCodeData };

  if (scopeId) {
    patchOptions.ScopeId = scopeId;
  }

  await req.archiveCode.update(patchOptions);

  return res.status(201).json({
    status: 'success',
    message: 'Archive code successfully patched.',
    data: {
      archiveCode: req.archiveCode,
    },
  });
}

module.exports = [validate(validations), checkScopes, patchOneArchiveCode];
