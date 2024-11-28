const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: process.env.EMAIL_TRANSPORTER_HOST,
  port: process.env.EMAIL_TRANSPORTER_PORT,
  secure: process.env.EMAIL_TRANSPORTER_PORT === 465,
  auth: {
    user: process.env.EMAIL_TRANSPORTER_USERNAME,
    pass: process.env.EMAIL_TRANSPORTER_PASSWORD,
  },
});

module.exports = transporter;
