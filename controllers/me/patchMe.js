const fs = require('fs');
const bcrypt = require('bcrypt');
const multer = require('multer');
const sharp = require('sharp');
const { body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');

const validations = [
  body('username')
    .optional()
    .isLength({ min: 4 })
    .withMessage('Username must be at least 4 characters length.')
    .custom(async (username, { req }) => {
      const existedUser = await db.users.findOne({ where: { username } });

      if (existedUser && existedUser.id !== req.user.id) {
        throw new Error('Username already exists.');
      } else {
        return true;
      }
    }),
  body('email')
    .optional()
    .isEmail({ require_tld: false })
    .withMessage('Email must be valid.')
    .custom(async (email, { req }) => {
      const existedUser = await db.users.findOne({ where: { email } });

      if (existedUser && existedUser.id !== req.user.id) {
        throw new Error('Email already exists.');
      } else {
        return true;
      }
    }),
  body('password')
    .optional()
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters length.'),
  body('currentPassword')
    .optional()
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters length.'),
  body('name').optional(),
];

const multerStorage = multer.memoryStorage();

const multerFileFilter = (req, file, cb) => {
  const acceptedMimeType = ['image/jpeg', 'image/png'];

  if (!acceptedMimeType.includes(file.mimetype)) {
    throw new Error('File MIME type must be [image/jpeg, image/png].');
  }

  cb(null, true);
};

const multerLimits = {
  fileSize: 2 * 1000 * 1000, // 2 MB
};

const upload = multer({
  storage: multerStorage,
  fileFilter: multerFileFilter,
  limits: multerLimits,
});

const uploader = upload.single('avatar');

async function patchMe(req, res) {
  const {
    password: newPassword,
    currentPassword,
    ...newUserData
  } = req.matchedData;

  const patchOptions = { ...newUserData };

  if (newPassword) {
    try {
      if (!currentPassword) {
        throw new Error('Need current password to change password.');
      }

      const isPasswordMatched = await bcrypt.compare(
        currentPassword,
        req.user.password
      );

      if (!isPasswordMatched) {
        throw new Error('Current password is incorrect.');
      }

      const hashedPassword = await bcrypt.hash(newPassword, 10);
      patchOptions.password = hashedPassword;
    } catch (error) {
      return res.status(400).json({
        status: 'fail',
        message: error.message,
      });
    }
  }

  const avatarsPath = './public/images/avatars';
  const userAvatarFileName = `${req.user.id}.jpg`;
  const userAvatarPath = `${avatarsPath}/${userAvatarFileName}`;

  if (req.file) {
    await sharp(req.file.buffer)
      .resize(256, 256)
      .jpeg({
        quality: 75,
        mozjpeg: true,
      })
      .toFile(userAvatarPath);
  }

  let patchedUser = await req.user.update(patchOptions);

  let avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/default.jpg`;

  if (fs.existsSync(userAvatarPath)) {
    avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/${patchedUser.id}.jpg`;
  }

  patchedUser = await db.users.findByPk(patchedUser.id, {
    include: db.scopes,
  });

  return res.status(200).json({
    status: 'success',
    message: 'User successfully patched.',
    data: {
      user: {
        ...patchedUser.toJSON(),
        avatarUrl,
      },
    },
  });
}

module.exports = [uploader, validate(validations), patchMe];
