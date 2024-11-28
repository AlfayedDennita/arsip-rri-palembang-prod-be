const { param } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');

const validations = [
  param('id')
    .exists()
    .withMessage('Reset password request id is required.')
    .custom(async (id, { req }) => {
      const resetPasswordRequest = await db.resetPasswordRequests.findByPk(id, {
        include: db.users,
      });

      if (!resetPasswordRequest) {
        throw new Error('Reset password request not found.');
      } else {
        const expiredMinutesInSeconds = 10 * 60; // 10 minutes;
        const invalidSeconds = Math.round(
          new Date(resetPasswordRequest.expiredAt).getTime() / 1000
        );
        const currentSeconds = Math.round(new Date().getTime() / 1000);
        const diffSeconds = currentSeconds - invalidSeconds;

        if (diffSeconds > expiredMinutesInSeconds) {
          await resetPasswordRequest.destroy();

          throw new Error('Reset password request expired.');
        } else {
          req.resetPasswordRequest = resetPasswordRequest;
          return true;
        }
      }
    }),
];

async function getOneResetPasswordRequest(req, res) {
  return res.status(200).json({
    status: 'success',
    message: 'Reset password request successfully retrieved.',
    data: {
      resetPasswordRequest: req.resetPasswordRequest,
    },
  });
}

module.exports = [validate(validations), getOneResetPasswordRequest];
