const { Op } = require('sequelize');

const db = require('../../models');
const getScopeDescendants = require('../../middlewares/getScopeDescendants');

async function getBasicStats(req, res) {
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

  const archivesRetrieveOptions = {
    where: {
      ArchiveCodeId: {
        [Op.in]: inScopeArchiveCodeIds,
      },
    },
    include: [
      {
        model: db.users,
        required: true,
        duplicating: false,
      },
      {
        model: db.archiveCodes,
        required: true,
        duplicating: false,
        include: [
          {
            model: db.scopes,

            required: true,
            duplicating: false,
          },
        ],
      },
      {
        model: db.archiveFiles,
        required: true,
        duplicating: false,
      },
    ],
  };

  const reportsRetrieveOptions = {
    where: {
      ScopeId: {
        [Op.in]: req.visibleScopeIds,
      },
    },
    include: [db.users, db.scopes],
  };

  const basicStats = {
    inScopeArchivesLength: null,
    myArchivesLength: null,
    inScopeReportsLength: null,
    myReportsLength: null,
  };

  basicStats.inScopeArchivesLength = (
    await db.archives.findAll(archivesRetrieveOptions)
  ).length;
  basicStats.inScopeReportsLength = (
    await db.reports.findAll(reportsRetrieveOptions)
  ).length;

  archivesRetrieveOptions.where.createdBy = req.user.id;
  reportsRetrieveOptions.where.createdBy = req.user.id;

  basicStats.myArchivesLength = (
    await db.archives.findAll(archivesRetrieveOptions)
  ).length;
  basicStats.myReportsLength = (
    await db.reports.findAll(reportsRetrieveOptions)
  ).length;

  return res.status(200).json({
    status: 'success',
    message: 'Basic stats successfully retrieved.',
    data: {
      basicStats,
    },
  });
}

module.exports = [getScopeDescendants, getBasicStats];
