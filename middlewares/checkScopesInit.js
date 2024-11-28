function checkScopesInit(req, res, next) {
  req.scopesToCheck = [];

  return next();
}

module.exports = checkScopesInit;
