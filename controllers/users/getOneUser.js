const fs = require('fs');
const { param } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  param('id').custom(async (id, { req }) => {
    const user = await db.users.findByPk(id, {
      include: db.scopes,
    });

    if (!user) {
      throw new Error('User not found');
    } else {
      req.userToRetrieve = user;
      req.scopesToCheck.push(user.ScopeId);
      return true;
    }
  }),
];

async function getOneUser(req, res) {
  const avatarsPath = './public/images/avatars';
  const userAvatarFileName = `${req.userToRetrieve.id}.jpg`;
  const userAvatarPath = `${avatarsPath}/${userAvatarFileName}`;

  let avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/default.jpg`;

  if (fs.existsSync(userAvatarPath)) {
    avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/${req.userToRetrieve.id}.jpg`;
  }

  return res.status(200).json({
    status: 'success',
    message: 'User successfully retrieved.',
    data: {
      user: {
        ...req.userToRetrieve.toJSON(),
        avatarUrl,
      },
    },
  });
}

module.exports = [validate(validations), checkScopes, getOneUser];
