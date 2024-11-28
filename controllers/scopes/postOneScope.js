const { body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');

const validations = [
  body('name').exists().isString().withMessage('Name is required.'),
  body('ancestorId')
    .exists()
    .isString()
    .withMessage('Ancestor id is required.')
    .custom(async (ancestorId, { req }) => {
      const ancestor = await db.scopes.findByPk(ancestorId);

      if (!ancestor) {
        throw new Error('Ancestor not found.');
      } else {
        req.ancestor = ancestor;
        return true;
      }
    }),
];

async function postOneScope(req, res) {
  const maxLevel = 4;
  const newLevel = req.ancestor.level + 1;

  if (newLevel > maxLevel) {
    return res.status(400).json({
      status: 'fail',
      message: 'Scope level reaches max limit.',
    });
  }

  let scope = await req.ancestor.createDescendant({
    name: req.matchedData.name,
    level: newLevel,
  });

  scope = await db.scopes.findByPk(scope.id, {
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

  return res.status(201).json({
    status: 'success',
    message: 'Scope successfully created.',
    data: {
      scope,
    },
  });
}

module.exports = [validate(validations), postOneScope];
