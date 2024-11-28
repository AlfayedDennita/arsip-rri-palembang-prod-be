const checkAuth = require('../../middlewares/checkAuth');

async function logout(req, res) {
  const refreshToken = await req.user.getRefreshToken();

  if (refreshToken) {
    await refreshToken.destroy();
  }

  return res.status(200).json({
    status: 'success',
    message: 'User successfully logged out. Refresh token deleted.',
    data: {
      user: req.user,
    },
  });
}

module.exports = [checkAuth, logout];
