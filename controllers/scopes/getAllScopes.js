const { query } = require('express-validator');

const db = require('../../models');

const validate = require('../../middlewares/validate');
const getScopeDescendants = require('../../middlewares/getScopeDescendants');

const validations = [
  query('flatten').optional().isBoolean(),
  query('root')
    .optional()
    .isBoolean()
    .custom((root, { req }) => {
      if (root && req.user.role !== 'root') {
        throw new Error('Out of access');
      } else {
        return true;
      }
    }),
];

async function getAllScopes(req, res) {
  let scopes = [];

  if (req.matchedData.root) {
    scopes = await db.scopes.findAll();
  } else if (req.matchedData.flatten) {
    scopes = req.visibleScopes;
  } else {
    scopes = req.scopeWithDescendants;
  }

  return res.status(200).json({
    status: 'success',
    message: 'All scopes successfully retrieved.',
    data: {
      scopes,
    },
  });
}

module.exports = [validate(validations), getScopeDescendants, getAllScopes];
