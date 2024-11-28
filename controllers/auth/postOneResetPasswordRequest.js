const ejs = require('ejs');
const { body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const emailTransporter = require('../../helpers/emailTransporter');

const validations = [
  body('email')
    .exists()
    .withMessage('Email is required.')
    .isEmail({ require_tld: false })
    .withMessage('Email should be a valid email.')
    .custom(async (email, { req }) => {
      const user = await db.users.findOne({
        where: { email },
        include: db.scopes,
      });

      if (!user) {
        throw new Error('Email not found.');
      } else {
        req.user = user;
        return true;
      }
    }),
];

async function sendEmail(resetPasswordRequest, user) {
  await emailTransporter.sendMail({
    from: `"Arsip Digital RRI Palembang" <${process.env.EMAIL_TRANSPORTER_USERNAME}>`,
    to: user.email,
    subject: 'Reset Kata Sandi: Arsip Digital RRI Palembang',
    html: await ejs.renderFile('views/emails/resetPassword.ejs', {
      locals: {
        userName: user.name,
        frontEndBaseURL: process.env.FRONT_END_BASE_URL,
        resetPasswordRequestId: resetPasswordRequest.id,
      },
    }),
  });
}

async function postOneResetPasswordRequest(req, res) {
  const expiredMinutesInSeconds = 10 * 60; // 10 minutes
  const expiredDate = new Date(
    new Date().getTime() + expiredMinutesInSeconds * 1000
  );

  const existedResetPasswordRequest = await req.user.getResetPasswordRequest();
  let resetPasswordRequest;

  if (existedResetPasswordRequest) {
    const isExpired =
      new Date(existedResetPasswordRequest.expiredAt).getTime() <
      new Date().getTime();

    if (isExpired) {
      await existedResetPasswordRequest.destroy();

      resetPasswordRequest = await req.user.createResetPasswordRequest({
        expiredAt: expiredDate,
      });
    } else {
      resetPasswordRequest = existedResetPasswordRequest;
    }
  } else {
    resetPasswordRequest = await req.user.createResetPasswordRequest({
      expiredAt: expiredDate,
    });
  }

  await sendEmail(resetPasswordRequest, req.user);

  resetPasswordRequest = await db.resetPasswordRequests.findByPk(
    resetPasswordRequest.id,
    {
      include: db.users,
    }
  );

  return res.status(201).json({
    status: 'success',
    message:
      'Reset password request successfully created. Email has been sent.',
    data: {
      resetPasswordRequest,
    },
  });
}

module.exports = [validate(validations), postOneResetPasswordRequest];
