const fs = require('fs');

const db = require('../../models');

async function getMe(req, res) {
  const me = await db.users.findByPk(req.user.id, {
    include: db.scopes,
  });

  const avatarsPath = './public/images/avatars';
  const userAvatarFileName = `${me.id}.jpg`;
  const userAvatarPath = `${avatarsPath}/${userAvatarFileName}`;

  let avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/default.jpg`;

  if (fs.existsSync(userAvatarPath)) {
    avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/${me.id}.jpg`;
  }

  return res.status(200).json({
    status: 'success',
    message: 'User successfully retrieved.',
    data: {
      user: {
        ...me.toJSON(),
        avatarUrl,
      },
    },
  });
}

module.exports = [getMe];
