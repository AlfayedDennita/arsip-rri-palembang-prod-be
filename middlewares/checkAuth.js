const jwt = require('jsonwebtoken');
const db = require('../models');

async function checkAuth(req, res, next) {
  if (!req.headers.authorization) {
    return res.status(401).json({
      status: 'fail',
      message: 'Unauthorized. Need access token.',
    });
  }

  const accessToken = req.headers.authorization.trim().split(' ')[1];

  try {
    const decodedAccessToken = jwt.verify(
      accessToken,
      process.env.ACCESS_TOKEN_SECRET_KEY
    );

    const user = await db.users.findByPk(decodedAccessToken.userId, {
      include: db.scopes,
    });

    if (!user) {
      throw new Error('User not found.');
    }

    req.user = user;

    return next();
  } catch (error) {
    let message = `Unathorized. ${error.message}`;

    if (error instanceof jwt.TokenExpiredError) {
      message = 'Access token expired.';
    }

    return res.status(401).json({
      status: 'fail',
      message,
    });
  }
}

module.exports = checkAuth;
