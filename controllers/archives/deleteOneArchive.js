const fs = require('fs');
const { param } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');
const axios = require('../../helpers/axios');

const validations = [
  param('id').custom(async (id, { req }) => {
    const archive = await db.archives.findByPk(id, {
      include: db.archiveCodes,
    });

    if (!archive) {
      throw new Error('Archive not found.');
    } else if (
      ['leader', 'staff'].includes(req.user.role) &&
      archive.createdBy !== req.user.id
    ) {
      throw new Error('Out of access.');
    } else {
      req.archive = archive;
      req.scopesToCheck.push(archive.ArchiveCode.ScopeId);
      return true;
    }
  }),
];

async function deleteOneArchive(req, res) {
  const archiveFiles = await req.archive.getArchiveFiles();

  for (const archiveFile of archiveFiles) {
    const filePath = `./public/archives/${archiveFile.id}.${archiveFile.extension}`;
    fs.unlinkSync(filePath);
  }

  const archiveType = archiveFiles[0].extension === 'pdf' ? 'pdf' : 'images';

  if (archiveType === 'images') {
    const filePath = `./public/archives/${req.archive.id}.zip`;
    fs.unlinkSync(filePath);
  }

  await req.archive.destroy();

  if (process.env.ENABLE_RAG === 'true') {
    if (process.argv.includes('--listen')) {
      res.on('finish', async () => {
        try {
          await axios.delete(`/embeddings/${req.matchedData.id}/`);
        } catch (error) {
          console.error(error);
        }
      });
    } else {
      await axios.delete(`/embeddings/${req.matchedData.id}`);
    }
  }

  return res.status(200).json({
    status: 'success',
    message: 'Archive successfully deleted.',
    data: {
      archive: {
        id: req.matchedData.id,
      },
    },
  });
}

module.exports = [validate(validations), checkScopes, deleteOneArchive];
