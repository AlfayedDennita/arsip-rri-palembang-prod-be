const fs = require('fs').promises;
const crypto = require('crypto');
const multer = require('multer');
const AdmZip = require('adm-zip');
// eslint-disable-next-line import/no-unresolved
const { fileFromPathSync } = require('formdata-node/file-from-path');
const { body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');
const axios = require('../../helpers/axios');
const getRetentionDate = require('../../helpers/getRetentionDate');

const validations = [
  body('archiveCodeId')
    .exists()
    .withMessage('Archive code is required.')
    .custom(async (archiveCodeId, { req }) => {
      const archiveCode = await db.archiveCodes.findByPk(archiveCodeId);

      if (!archiveCode) {
        throw new Error('Archive code not found.');
      } else {
        req.archiveCode = archiveCode;
        req.scopesToCheck.push(archiveCode.ScopeId);
        return true;
      }
    }),
  body('title').exists().withMessage('Title is required.'),
  body('publishedAt').optional().isISO8601().toDate(),
  body('retentionCategory').exists().isString(),
  body('description')
    .optional()
    .isLength({ max: 512 })
    .withMessage('Description must be no longer than 512 characters.'),
];

const multerStorage = multer.memoryStorage();

const multerFileFilter = (req, file, cb) => {
  const pdfMimeType = ['application/pdf'];
  const imagesMimeType = ['image/jpeg', 'image/png'];

  if (file.fieldname === 'pdf' && !pdfMimeType.includes(file.mimetype)) {
    throw new Error('File MIME type must be [application/pdf].');
  } else if (
    file.fieldname === 'images' &&
    !imagesMimeType.includes(file.mimetype)
  ) {
    throw new Error('File MIME type must be [image/jpeg, image/png].');
  }
  cb(null, true);
};

const multerLimits = {
  fileSize: 5 * 1000 * 1000, // 5 MB
};

const upload = multer({
  storage: multerStorage,
  fileFilter: multerFileFilter,
  limits: multerLimits,
});

const uploader = upload.fields([
  { name: 'pdf', maxCount: 1 },
  { name: 'images', maxCount: 10 },
]);

async function postOneArchive(req, res) {
  const { archiveCodeId, ...archiveData } = req.matchedData;

  const archivesPath = './public/archives';
  const listOfFileObj = [];

  let archive;

  if (req?.files?.pdf) {
    archive = await req.user.createArchive({
      ...archiveData,
      removedAt: getRetentionDate(
        new Date(),
        req.matchedData.retentionCategory
      ),
      ArchiveCodeId: archiveCodeId,
    });

    const pdf = req.files.pdf[0];

    const uuid = crypto.randomUUID();
    const splittedOriginalName = pdf.originalname.split('.');
    const extension = splittedOriginalName[splittedOriginalName.length - 1];
    const filename = `${uuid}.${extension}`;
    const filePath = `${archivesPath}/${filename}`;

    await fs.writeFile(filePath, pdf.buffer);
    listOfFileObj.push(fileFromPathSync(filePath));

    await archive.createArchiveFile({
      id: uuid,
      page: 1,
      extension,
    });
  } else if (req?.files?.images) {
    archive = await req.user.createArchive({
      ...archiveData,
      ArchiveCodeId: archiveCodeId,
    });

    const zip = new AdmZip();

    for (const [i, image] of req.files.images.entries()) {
      const uuid = crypto.randomUUID();
      const splittedOriginalName = image.originalname.split('.');
      const extension = splittedOriginalName[splittedOriginalName.length - 1];
      const filename = `${uuid}.${extension}`;
      const filePath = `${archivesPath}/${filename}`;

      zip.addFile(`${i + 1}.${extension}`, image.buffer);
      await fs.writeFile(filePath, image.buffer);
      listOfFileObj.push(fileFromPathSync(filePath));

      await archive.createArchiveFile({
        id: uuid,
        page: i + 1,
        extension,
      });
    }

    zip.writeZip(`${archivesPath}/${archive.id}.zip`);
  } else {
    return res.status(400).json({
      status: 'fail',
      message: 'Archive file is needed.',
    });
  }

  const updatedArchive = await db.archives.findByPk(archive.id, {
    include: db.archiveFiles,
  });

  const archiveType =
    updatedArchive.ArchiveFiles[0].extension === 'pdf' ? 'pdf' : 'images';

  let url;

  if (archiveType === 'pdf') {
    url = `${process.env.BACK_END_BASE_URL}/static/archives/${updatedArchive.ArchiveFiles[0].id}.pdf`;
  } else {
    url = `${process.env.BACK_END_BASE_URL}/static/archives/${updatedArchive.id}.zip`;
  }

  if (process.env.ENABLE_RAG === 'true') {
    if (process.argv.includes('--listen')) {
      res.on('finish', async () => {
        try {
          const form = new FormData();

          form.append('archive_id', updatedArchive.id);
          form.append('scope_id', req.archiveCode.ScopeId);
          listOfFileObj.forEach((fileObj) => {
            form.append('files', fileObj);
          });

          await axios.post('/embeddings/', form);
        } catch (error) {
          console.error(error);
        }
      });
    } else {
      const form = new FormData();

      form.append('archive_id', updatedArchive.id);
      form.append('scope_id', req.archiveCode.ScopeId);
      listOfFileObj.forEach((fileObj) => {
        form.append('files', fileObj);
      });

      await axios.post('/embeddings/', form);
    }
  }

  return res.status(201).json({
    status: 'success',
    message: 'Archive successfully created.',
    data: {
      archive: {
        ...updatedArchive.toJSON(),
        type: archiveType,
        url,
      },
    },
  });
}

module.exports = [uploader, validate(validations), checkScopes, postOneArchive];
