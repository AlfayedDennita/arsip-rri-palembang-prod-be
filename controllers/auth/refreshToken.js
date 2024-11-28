const jwt = require('jsonwebtoken');
const { body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');

const validations = [
  body('refreshToken')
    .exists()
    .withMessage('Refresh token is required.')
    .isJWT()
    .withMessage('Refresh token must be JWT.')
    .custom(async (refreshT, { req }) => {
      const token = await db.refreshTokens.findOne({
        where: { token: refreshT },
        include: db.users,
      });

      if (!token) {
        throw new Error('Refresh token not found.');
      } else {
        const expiredDaysInSeconds = 90 * 24 * 60 * 60; // 90 days;
        const lastAccessedSeconds = Math.round(
          new Date(token.lastAccessedAt).getTime() / 1000
        );
        const currentSeconds = Math.round(new Date().getTime() / 1000);
        const diffSeconds = currentSeconds - lastAccessedSeconds;

        if (diffSeconds > expiredDaysInSeconds) {
          await token.destroy();

          throw new Error('Refresh token expired.');
        } else {
          req.refreshToken = token;
          return true;
        }
      }
    }),
];

async function refreshToken(req, res) {
  try {
    const decodedRefreshToken = jwt.verify(
      req.matchedData.refreshToken,
      process.env.REFRESH_TOKEN_SECRET_KEY
    );

    const newAccessToken = jwt.sign(
      { userId: decodedRefreshToken.userId },
      process.env.ACCESS_TOKEN_SECRET_KEY,
      {
        issuer: 'Arsip Digital RRI Palembang',
        expiresIn: '1h',
      }
    );

    await req.refreshToken.update({ lastAccessedAt: new Date() });

    const user = await db.users.findByPk(decodedRefreshToken.userId, {
      include: db.scopes,
    });

    return res.status(201).json({
      status: 'success',
      message: 'Access token updated.',
      data: {
        user,
        accessToken: newAccessToken,
        refreshToken: req.matchedData.refreshToken,
      },
    });
  } catch (error) {
    return res.status(400).json({
      status: 'fail',
      message: "Couldn't create access token.",
    });
  }
}

module.exports = [validate(validations), refreshToken];
