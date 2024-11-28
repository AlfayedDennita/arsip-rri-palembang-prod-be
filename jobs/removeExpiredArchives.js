const fs = require('fs');
const { Op } = require('sequelize');

const db = require('../models');
const axios = require('../helpers/axios');

async function removeExpiredArchives() {
  console.log('Removing expired archives started.');

  const expiredArchives = await db.archives.findAll({
    where: {
      removedAt: {
        [Op.lte]: new Date(),
      },
    },
    include: db.archiveFiles,
  });

  for (const archive of expiredArchives) {
    try {
      const archiveId = archive.id;
      const archiveFiles = archive.ArchiveFiles;

      for (const archiveFile of archiveFiles) {
        const filePath = `./public/archives/${archiveFile.id}.${archiveFile.extension}`;
        fs.unlinkSync(filePath);
      }

      const archiveType =
        archiveFiles[0].extension === 'pdf' ? 'pdf' : 'images';

      if (archiveType === 'images') {
        const filePath = `./public/archives/${archive.id}.zip`;
        fs.unlinkSync(filePath);
      }

      await archive.destroy();

      if (process.env.ENABLE_RAG === 'true') {
        await axios.delete(`/embeddings/${archiveId}`);
      }
    } catch (error) {
      console.error(error);
    }
  }

  console.log(
    `Removing expired archives finished. ${expiredArchives.length} archives removed.`
  );
}

module.exports = removeExpiredArchives;
