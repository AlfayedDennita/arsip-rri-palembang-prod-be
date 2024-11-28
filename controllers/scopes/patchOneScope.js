const { param, body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  param('id').custom(async (id, { req }) => {
    const scope = await db.scopes.findByPk(id, {
      include: {
        model: db.scopes,
        as: 'descendants',
        include: {
          model: db.scopes,
          as: 'descendants',
          include: {
            model: db.scopes,
            as: 'descendants',
            include: {
              model: db.scopes,
              as: 'descendants',
            },
          },
        },
      },
    });

    if (!scope) {
      throw new Error('Scope not found.');
    } else {
      req.scope = scope;
      req.scopesToCheck.push(scope.id);
      return true;
    }
  }),
  body('name').optional(),
];

async function patchOneScope(req, res) {
  const { id, ...newScopeData } = req.matchedData;

  await req.scope.update(newScopeData);

  return res.status(200).json({
    status: 'success',
    message: 'Scope successfully patched.',
    scope: req.scope,
  });
}

module.exports = [validate(validations), checkScopes, patchOneScope];
