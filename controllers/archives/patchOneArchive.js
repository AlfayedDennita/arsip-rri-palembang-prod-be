const { param, body } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');
const axios = require('../../helpers/axios');
const getRetentionDate = require('../../helpers/getRetentionDate');

const validations = [
  param('id').custom(async (id, { req }) => {
    const archive = await db.archives.findByPk(id, {
      include: db.archiveCodes,
    });

    if (!archive) {
      throw new Error('Archive not found.');
    } else if (['leader', 'staff'].includes(req.user.role)) {
      if (archive.createdBy !== req.user.id) {
        throw new Error('Out of access.');
      } else {
        return true;
      }
    } else {
      req.archive = archive;
      req.scopesToCheck.push(archive.ArchiveCode.ScopeId);
      return true;
    }
  }),
  body('title'),
  body('publishedAt'),
  body('retentionCategory'),
  body('description'),
  body('archiveCodeId')
    .optional({ values: 'falsy' })
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
];

async function patchOneArchive(req, res) {
  const { id, retentionCategory, archiveCodeId, ...archiveData } =
    req.matchedData;

  const newArchiveData = archiveData;
  const oldArchiveId = req.archive.ArchiveCodeId;

  if (archiveCodeId) {
    newArchiveData.ArchiveCodeId = archiveCodeId;
  }

  if (retentionCategory) {
    newArchiveData.retentionCategory = retentionCategory;
    newArchiveData.removedAt = getRetentionDate(
      req.archive.createdAt,
      retentionCategory
    );
  }

  await req.archive.update(newArchiveData);

  const newArchive = await db.archives.findByPk(id, {
    include: [
      {
        model: db.users,
      },
      {
        model: db.archiveCodes,
        include: [
          {
            model: db.scopes,
          },
        ],
      },
      {
        model: db.archiveFiles,
      },
    ],
  });

  if (
    archiveCodeId &&
    oldArchiveId !== archiveCodeId &&
    process.env.ENABLE_RAG === 'true'
  ) {
    if (process.argv.includes('--listen')) {
      res.on('finish', async () => {
        try {
          await axios.put(`/embeddings/${newArchive.id}`, {
            scope_id: req.archiveCode.ScopeId,
          });
        } catch (error) {
          console.error(error);
        }
      });
    } else {
      await axios.put(`/embeddings/${newArchive.id}`, {
        scope_id: req.archiveCode.ScopeId,
      });
    }
  }

  const archiveType =
    newArchive.ArchiveFiles[0].extension === 'pdf' ? 'pdf' : 'images';

  let url;

  if (archiveType === 'pdf') {
    url = `${process.env.BACK_END_BASE_URL}/static/archives/${newArchive.ArchiveFiles[0].id}.pdf`;
  } else {
    url = `${process.env.BACK_END_BASE_URL}/static/archives/${newArchive.id}.zip`;
  }

  return res.status(200).json({
    status: 'success',
    message: 'Archive successfully patched.',
    data: {
      archive: {
        ...newArchive.toJSON(),
        type: archiveType,
        url,
      },
    },
  });
}

module.exports = [validate(validations), checkScopes, patchOneArchive];
