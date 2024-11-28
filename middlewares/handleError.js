function handleError(err, req, res, next) {
  if (res.headerSent) {
    return next(err);
  }

  if (process.argv.includes('--listen')) {
    console.error(err);
  }

  return res.status(500).json({
    status: 'error',
    message: 'Internal server error.',
  });
}

module.exports = handleError;
