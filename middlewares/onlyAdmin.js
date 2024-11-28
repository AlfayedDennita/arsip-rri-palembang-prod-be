function onlyAdmin(req, res, next) {
  if (['root', 'admin'].includes(req.user.role)) {
    return next();
  }

  return res.status(403).json({
    status: 'fail',
    message: 'Forbidden.',
  });
}

module.exports = onlyAdmin;
