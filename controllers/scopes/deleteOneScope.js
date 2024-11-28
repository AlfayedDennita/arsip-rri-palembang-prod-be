const { param } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  param('id').custom(async (id, { req }) => {
    const scope = await db.scopes.findByPk(id, {
      include: [
        {
          model: db.scopes,
          as: 'descendants',
        },
        db.users,
        db.archiveCodes,
        db.reports,
      ],
    });

    if (!scope) {
      throw new Error('Scope not found.');
    } else {
      req.scope = scope;
      req.scopesToCheck.push(scope.id);
      return true;
    }
  }),
];

async function deleteOneScope(req, res) {
  if (
    req.scope.descendants.length > 0 ||
    req.scope.Users.length > 0 ||
    req.scope.ArchiveCodes.length > 0 ||
    req.scope.Reports.length > 0
  ) {
    return res.status(400).json({
      status: 'fail',
      message: 'Scope still has references.',
    });
  }

  await req.scope.destroy();

  return res.status(200).json({
    status: 'success',
    message: 'Scope successfully deleted.',
    data: {
      scope: {
        id: req.matchedData.id,
      },
    },
  });
}

module.exports = [validate(validations), checkScopes, deleteOneScope];
