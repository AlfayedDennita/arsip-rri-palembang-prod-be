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
      req.userToDelete = user;
      req.scopesToCheck.push(user.ScopeId);
      return true;
    }
  }),
];

async function deleteOneUser(req, res) {
  const avatarsPath = './public/images/avatars';
  const userAvatarFileName = `${req.userToDelete.id}.jpg`;
  const userAvatarPath = `${avatarsPath}/${userAvatarFileName}`;

  if (fs.existsSync(userAvatarPath)) {
    fs.unlinkSync(userAvatarPath);
  }

  await req.userToDelete.destroy();

  return res.status(200).json({
    status: 'success',
    message: 'User successfully deleted.',
    data: {
      user: {
        id: req.matchedData.id,
      },
    },
  });
}

module.exports = [validate(validations), checkScopes, deleteOneUser];
