const getScopeDescendants = require('./getScopeDescendants');

async function checkScopes(req, res, next) {
  const isAllowed = req.scopesToCheck.every((scopeId) =>
    req.visibleScopeIds.includes(scopeId)
  );

  if (isAllowed) {
    return next();
  }

  return res.status(403).json({
    status: 'fail',
    message: 'Out of scope.',
  });
}

module.exports = [getScopeDescendants, checkScopes];
