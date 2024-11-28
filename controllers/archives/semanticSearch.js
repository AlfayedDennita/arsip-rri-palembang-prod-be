const { Op } = require('sequelize');
const { query } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const getScopeDescendants = require('../../middlewares/getScopeDescendants');
const axios = require('../../helpers/axios');

const validations = [query('query').exists().withMessage('Query is required.')];

async function semanticSearch(req, res) {
  const inScopeArchiveCodes = await db.archiveCodes.findAll({
    where: {
      ScopeId: {
        [Op.in]: req.visibleScopeIds,
      },
    },
  });
  const inScopeArchiveCodeIds = inScopeArchiveCodes.map(
    (archiveCode) => archiveCode.id
  );

  const visibleArchives = await db.archives.findAll({
    where: {
      ArchiveCodeId: {
        [Op.in]: inScopeArchiveCodeIds,
      },
    },
  });

  if (visibleArchives.length < 1) {
    return res.status(400).json({
      status: 'fail',
      message: 'No archives to retrieve.',
    });
  }

  let response;

  try {
    response = await axios.post('/search/', {
      query: req.matchedData.query,
      scope_ids: req.visibleScopeIds,
    });
  } catch (error) {
    return res.status(400).json({
      status: 'fail',
      message: 'No archives to retrieve.',
    });
  }

  const {
    data: { archives: archiveIds, response: aiResponse },
  } = response.data;

  const orderIds = `'${archiveIds.join("','")}'`;

  const archives = await db.archives.findAll({
    where: {
      id: {
        [Op.in]: archiveIds,
      },
    },
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
    order: [
      db.sequelize.literal(
        `ARRAY_POSITION(ARRAY[${orderIds}]::uuid[], "Archive"."id")`
      ),
    ],
  });

  const newArchives = archives.map((archive) => {
    const archiveType =
      archive.ArchiveFiles[0].extension === 'pdf' ? 'pdf' : 'images';

    let url;

    if (archiveType === 'pdf') {
      url = `${process.env.BACK_END_BASE_URL}/static/archives/${archive.ArchiveFiles[0].id}.pdf`;
    } else {
      url = `${process.env.BACK_END_BASE_URL}/static/archives/${archive.id}.zip`;
    }

    return { ...archive.toJSON(), type: archiveType, url };
  });

  return res.status(200).json({
    status: 'success',
    message:
      'Archives successfully retrieved. Response successfully generated.',
    data: {
      archives: newArchives,
      response: aiResponse,
    },
  });
}

module.exports = [validate(validations), getScopeDescendants, semanticSearch];
