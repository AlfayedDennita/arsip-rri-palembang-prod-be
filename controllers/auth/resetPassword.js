const bcrypt = require('bcrypt');
const { param, body } = require('express-validator');

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
  body('newPassword')
    .exists()
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters length.'),
];

async function resetPassword(req, res) {
  const user = await req.resetPasswordRequest.getUser({ include: db.scopes });
  const hashedPassword = await bcrypt.hash(req.matchedData.newPassword, 10);
  await user.update({ password: hashedPassword });
  await req.resetPasswordRequest.destroy();

  return res.status(200).json({
    status: 'success',
    message: 'Password successfully changed.',
    data: {
      user,
    },
  });
}

module.exports = [validate(validations), resetPassword];
