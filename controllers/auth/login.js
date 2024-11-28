const fs = require('fs');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Op } = require('sequelize');
const { body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');

const validations = [
  body('identifier')
    .exists()
    .withMessage('Identifier is required.')
    .custom(async (identifier, { req }) => {
      const user = await db.users.findOne({
        where: {
          [Op.or]: [{ username: identifier }, { email: identifier }],
        },
        include: db.scopes,
      });

      if (!user) {
        throw new Error('Username or email not found.');
      } else {
        req.user = user;
        return true;
      }
    }),
  body('password').exists().withMessage('Password is required.'),
];

async function login(req, res) {
  const isPasswordMatched = await bcrypt.compare(
    req.matchedData.password,
    req.user.password
  );

  if (!isPasswordMatched) {
    return res.status(400).json({
      status: 'fail',
      message: 'Password is incorrect.',
    });
  }

  const accessToken = jwt.sign(
    { userId: req.user.id },
    process.env.ACCESS_TOKEN_SECRET_KEY,
    {
      issuer: 'Arsip Digital RRI Palembang',
      expiresIn: '1h',
    }
  );

  const existedRefreshToken = await req.user.getRefreshToken();

  let refreshToken;

  if (existedRefreshToken) {
    refreshToken = existedRefreshToken.token;
    await existedRefreshToken.update({ lastAccessedAt: new Date() });
  } else {
    refreshToken = jwt.sign(
      { userId: req.user.id },
      process.env.REFRESH_TOKEN_SECRET_KEY,
      {
        issuer: 'Arsip Digital RRI Palembang',
      }
    );
    await req.user.createRefreshToken({ token: refreshToken });
  }

  const avatarsPath = './public/images/avatars';
  const userAvatarFileName = `${req.user.id}.jpg`;
  const userAvatarPath = `${avatarsPath}/${userAvatarFileName}`;

  let avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/default.jpg`;

  if (fs.existsSync(userAvatarPath)) {
    avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/${req.user.id}.jpg`;
  }

  return res.status(200).json({
    status: 'success',
    message:
      'User successfully logged in. Access token and refresh token created.',
    data: {
      user: {
        ...req.user.toJSON(),
        avatarUrl,
      },
      accessToken,
      refreshToken,
    },
  });
}

module.exports = [validate(validations), login];
