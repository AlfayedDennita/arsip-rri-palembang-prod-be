const fs = require('fs');
const bcrypt = require('bcrypt');
const multer = require('multer');
const sharp = require('sharp');
const { body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  body('username')
    .exists()
    .withMessage('Username is required.')
    .isLength({ min: 4 })
    .withMessage('Username must be at least 4 characters length.')
    .toLowerCase()
    .customSanitizer((username) => username.replace(/\s+/g, '-'))
    .custom(async (username) => {
      const existedUser = await db.users.findOne({ where: { username } });

      if (existedUser) {
        throw new Error('Username already exists.');
      } else {
        return true;
      }
    }),
  body('email')
    .exists()
    .withMessage('Email is required.')
    .isEmail({ require_tld: false })
    .withMessage('Email must be valid.')
    .custom(async (email) => {
      const existedUser = await db.users.findOne({ where: { email } });

      if (existedUser) {
        throw new Error('Email already exists.');
      } else {
        return true;
      }
    }),
  body('password')
    .exists()
    .withMessage('Password is required.')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters length.'),
  body('role')
    .exists()
    .withMessage('Role is required.')
    .custom(async (role, { req }) => {
      const adminRoles = ['admin', 'leader', 'staff'];
      const rootRoles = ['root', ...adminRoles];

      if (req.user.role === 'root' && !rootRoles.includes(role)) {
        throw new Error(`Role must be ${rootRoles}.`);
      } else if (req.user.role === 'admin' && !adminRoles.includes(role)) {
        throw new Error(`Role must be ${adminRoles}.`);
      } else {
        return true;
      }
    }),
  body('scopeId')
    .exists()
    .withMessage('Scope id is required.')
    .custom(async (scopeId, { req }) => {
      const scope = await db.scopes.findByPk(scopeId);

      if (!scope) {
        throw new Error('Scope not found.');
      } else {
        req.scope = scope;
        req.scopesToCheck.push(scope.id);
        return true;
      }
    }),
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

async function postOneUser(req, res) {
  const { password, scopeId, ...userData } = req.matchedData;

  const hashedPassword = await bcrypt.hash(password, 10);

  let user = await db.users.create({
    ...userData,
    password: hashedPassword,
    ScopeId: scopeId,
  });

  const avatarsPath = './public/images/avatars';
  const userAvatarFileName = `${user.id}.jpg`;
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

  let avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/default.jpg`;

  if (fs.existsSync(userAvatarPath)) {
    avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/${user.id}.jpg`;
  }

  user = await db.users.findByPk(user.id, {
    include: db.scopes,
  });

  return res.status(201).json({
    status: 'success',
    message: 'User successfully created.',
    data: {
      user: {
        ...user.toJSON(),
        avatarUrl,
      },
    },
  });
}

module.exports = [uploader, validate(validations), checkScopes, postOneUser];
