const { Op } = require('sequelize');
const { query } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  query('sortMethod').optional().isIn(['ASC', 'DESC']).default('ASC'),
  query('sortKey')
    .optional()
    .isIn([
      'archiveCode',
      'title',
      'publishedAt',
      'scope',
      'createdBy',
      'createdAt',
      'retentionCategory',
      'removedAt',
      'description',
    ])
    .default('createdAt'),
  query('offset').optional().isInt().default(0).toInt(),
  query('limit').optional().isInt().default(10).toInt(),
  query('archiveCodeId')
    .optional()
    .isString()
    .custom(async (archiveCodeId, { req }) => {
      const archiveCode = await db.archiveCodes.findByPk(archiveCodeId);

      if (!archiveCode) {
        throw new Error('Archive code not found.');
      } else {
        req.scopesToCheck.push((await archiveCode.getScope()).id);
        return true;
      }
    }),
  query('title').optional().isString(),
  query('publishedAtStart').optional().isISO8601().toDate(),
  query('publishedAtEnd').optional().isISO8601().toDate(),
  query('publishedAtNull').optional().isBoolean(),
  query('scopeId')
    .optional()
    .isString()
    .custom(async (scopeId, { req }) => {
      const scope = await db.scopes.findByPk(scopeId);

      if (!scope) {
        throw new Error('Scope not found.');
      } else {
        req.scopesToCheck.push(scope.id);
        return true;
      }
    }),
  query('createdById')
    .optional()
    .isString()
    .custom(async (createdById, { req }) => {
      const createdBy = await db.users.findByPk(createdById);

      if (!createdBy) {
        throw new Error('Created by not found.');
      } else if (req.user.role === 'staff' && createdBy.id !== req.user.id) {
        throw new Error('Out of access.');
      } else {
        return true;
      }
    }),
  query('createdAtStart').optional().isISO8601().toDate(),
  query('createdAtEnd').optional().isISO8601().toDate(),
  query('retentionCategory').optional().isString(),
  query('removedAtStart').optional().isISO8601().toDate(),
  query('removedAtEnd').optional().isISO8601().toDate(),
  query('removedAtNull').optional().isBoolean(),
  query('description').optional().isString(),
];

async function getAllArchives(req, res) {
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

  const sortKeys = {
    archiveCode: [db.archiveCodes, 'code'],
    title: ['title'],
    publishedAt: ['publishedAt'],
    scope: [db.archiveCodes, db.scopes, 'name'],
    createdBy: [db.users, 'name'],
    createdAt: ['createdAt'],
    retentionCategory: ['retentionCategory'],
    removedAt: ['removedAt'],
    description: ['description'],
  };

  const retrieveOptions = {
    where: {
      ArchiveCodeId: {
        [Op.in]: inScopeArchiveCodeIds,
      },
    },
    include: [
      {
        model: db.users,
        where: {},
        required: true,
        duplicating: false,
      },
      {
        model: db.archiveCodes,
        where: {},
        required: true,
        duplicating: false,
        include: [
          {
            model: db.scopes,
            where: {},
            required: true,
            duplicating: false,
          },
        ],
      },
      {
        model: db.archiveFiles,
        where: {},
        required: true,
        duplicating: false,
      },
    ],
    order: [
      [
        ...sortKeys[req.matchedData?.sortKey || 'createdAt'],
        req.matchedData?.sortMethod || 'ASC',
      ],
      [db.archiveFiles, 'page', 'ASC'],
    ],
  };

  if (req.user.role === 'staff') {
    retrieveOptions.where.createdBy = req.user.id;
  }

  if (req.matchedData?.archiveCodeId) {
    retrieveOptions.include[1].where.id = req.matchedData.archiveCodeId;
  }
  if (req.matchedData?.title) {
    (retrieveOptions.where.title ??= {})[
      Op.iLike
    ] = `%${req.matchedData.title}%`;
  }
  if (req.matchedData?.publishedAtStart) {
    (retrieveOptions.where.publishedAt ??= {})[Op.gte] =
      req.matchedData.publishedAtStart;
  }
  if (req.matchedData?.publishedAtEnd) {
    (retrieveOptions.where.publishedAt ??= {})[Op.lte] =
      req.matchedData.publishedAtEnd;
  }
  if (req.matchedData?.publishedAtNull) {
    (retrieveOptions.where.publishedAt ??= {})[Op.is] = null;
  }
  if (req.matchedData?.scopeId) {
    retrieveOptions.include[1].include[0].where.id = req.matchedData.scopeId;
  }
  if (req.matchedData?.createdById) {
    retrieveOptions.where.createdBy = req.matchedData.createdById;
  }
  if (req.matchedData?.createdAtStart) {
    (retrieveOptions.where.createdAt ??= {})[Op.gte] =
      req.matchedData.createdAtStart;
  }
  if (req.matchedData?.createdAtEnd) {
    (retrieveOptions.where.createdAt ??= {})[Op.lte] =
      req.matchedData.createdAtEnd;
  }
  if (req.matchedData?.retentionCategory) {
    retrieveOptions.where.retentionCategory = req.matchedData.retentionCategory;
  }
  if (req.matchedData?.removedAtStart) {
    (retrieveOptions.where.removedAt ??= {})[Op.gte] =
      req.matchedData.removedAtStart;
  }
  if (req.matchedData?.removedAtEnd) {
    (retrieveOptions.where.removedAt ??= {})[Op.lte] =
      req.matchedData.removedAtEnd;
  }
  if (req.matchedData?.removedAtNull) {
    (retrieveOptions.where.removedAt ??= {})[Op.is] = null;
  }
  if (req.matchedData?.description) {
    (retrieveOptions.where.description ??= {})[
      Op.iLike
    ] = `%${req.matchedData.description}%`;
  }

  const initialInScopeArchives = await db.archives.findAll(retrieveOptions);

  retrieveOptions.offset = req.matchedData?.offset || 0;
  if (req.matchedData.limit !== 0) {
    retrieveOptions.limit = req.matchedData?.limit || 10;
  }

  let inScopeArchives = await db.archives.findAll(retrieveOptions);

  inScopeArchives = inScopeArchives.map((archive) => {
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
    message: 'All archives successfully retrieved.',
    data: {
      totalRecords: initialInScopeArchives.length,
      archives: inScopeArchives,
    },
  });
}

module.exports = [validate(validations), checkScopes, getAllArchives];
