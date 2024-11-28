const { param } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  param('id').custom(async (id, { req }) => {
    const archive = await db.archives.findByPk(id, {
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

    if (!archive) {
      throw new Error('Archive not found.');
    } else if (['staff'].includes(req.user.role)) {
      if (archive.createdBy !== req.user.id) {
        throw new Error('Out of access.');
      } else {
        return true;
      }
    } else {
      req.archive = archive;
      req.scopesToCheck.push(archive.ArchiveCode.Scope.id);
      return true;
    }
  }),
];

async function getOneArchive(req, res) {
  const archiveType =
    req.archive.ArchiveFiles[0].extension === 'pdf' ? 'pdf' : 'images';

  let url;

  if (archiveType === 'pdf') {
    url = `${process.env.BACK_END_BASE_URL}/static/archives/${req.archive.ArchiveFiles[0].id}.pdf`;
  } else {
    url = `${process.env.BACK_END_BASE_URL}/static/archives/${req.archive.id}.zip`;
  }

  return res.status(200).json({
    status: 'success',
    message: 'Archive successfully retrieved.',
    data: {
      archive: {
        ...req.archive.toJSON(),
        type: archiveType,
        url,
      },
    },
  });
}

module.exports = [validate(validations), checkScopes, getOneArchive];
