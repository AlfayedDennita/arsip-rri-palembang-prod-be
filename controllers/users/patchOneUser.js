const fs = require('fs');
const bcrypt = require('bcrypt');
const multer = require('multer');
const sharp = require('sharp');
const { param, body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  param('id').custom(async (id, { req }) => {
    const user = await db.users.findByPk(id, {
      include: db.scopes,
    });

    if (!user) {
      throw new Error('User not found');
    } else {
      req.userToPatch = user;
      return true;
    }
  }),
  body('username')
    .optional()
    .isLength({ min: 4 })
    .withMessage('Username must be at least 4 characters length.')
    .toLowerCase()
    .customSanitizer((username) => username.replace(/\s+/g, '-'))
    .custom(async (username, { req }) => {
      const existedUser = await db.users.findOne({ where: { username } });

      if (existedUser && existedUser.id !== req.userToPatch.id) {
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

      if (existedUser && existedUser.id !== req.userToPatch.id) {
        throw new Error('Email already exists.');
      } else {
        return true;
      }
    }),
  body('password')
    .optional()
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters length.'),
  body('role')
    .optional()
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
    .optional()
    .custom(async (scopeId, { req }) => {
      const scope = await db.scopes.findByPk(scopeId);

      if (!scope) {
        throw new Error('Scope not found.');
      } else {
        req.scope = scope;
        if (req.user.role !== 'root') {
          req.scopesToCheck.push(scope.id);
        }
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

async function patchOneUser(req, res) {
  const { id, password, scopeId, ...userData } = req.matchedData;

  const patchOptions = { ...userData };

  if (password && password !== req.userToPatch.password) {
    const hashedPassword = await bcrypt.hash(password, 10);
    patchOptions.password = hashedPassword;
  }

  if (scopeId) {
    patchOptions.ScopeId = scopeId;
  }

  const avatarsPath = './public/images/avatars';
  const userAvatarFileName = `${req.userToPatch.id}.jpg`;
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

  let patchedUser = await req.userToPatch.update(patchOptions);

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

module.exports = [uploader, validate(validations), checkScopes, patchOneUser];
