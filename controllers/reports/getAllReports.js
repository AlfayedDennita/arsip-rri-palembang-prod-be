const { Op } = require('sequelize');
const { query } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');

const validations = [
  query('sortMethod').optional().isIn(['ASC', 'DESC']).default('ASC'),
  query('sortKey')
    .optional()
    .isIn(['title', 'scope', 'createdBy', 'createdAt', 'description'])
    .default('createdAt'),
  query('offset').optional().isInt().default(0).toInt(),
  query('limit').optional().isInt().default(10).toInt(),
  query('title').optional().isString(),
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
  query('description').optional().isString(),
];

async function getAllReports(req, res) {
  const sortKeys = {
    title: ['title'],
    scope: [db.scopes, 'name'],
    createdBy: [db.users, 'name'],
    createdAt: ['createdAt'],
    description: ['description'],
  };

  const retrieveOptions = {
    where: {
      ScopeId: {
        [Op.in]: req.visibleScopeIds,
      },
    },
    include: [
      {
        model: db.users,
        where: {},
      },
      {
        model: db.scopes,
        where: {},
      },
    ],
    order: [
      [
        ...sortKeys[req.matchedData?.sortKey || 'createdAt'],
        req.matchedData?.sortMethod || 'ASC',
      ],
    ],
  };

  if (req.user.role === 'staff') {
    retrieveOptions.where.createdBy = req.user.id;
  }

  if (req.matchedData?.title) {
    (retrieveOptions.where.title ??= {})[
      Op.iLike
    ] = `%${req.matchedData.title}%`;
  }
  if (req.matchedData?.scopeId) {
    retrieveOptions.include[1].where.id = req.matchedData.scopeId;
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
  if (req.matchedData?.description) {
    (retrieveOptions.where.description ??= {})[
      Op.iLike
    ] = `%${req.matchedData.description}%`;
  }

  const initialInScopeReports = await db.reports.findAll(retrieveOptions);

  retrieveOptions.offset = req.matchedData?.offset || 0;
  if (req.matchedData.limit !== 0) {
    retrieveOptions.limit = req.matchedData?.limit || 10;
  }

  const inScopeReports = await db.reports.findAll(retrieveOptions);

  return res.status(200).json({
    status: 'success',
    message: 'All reports successfully retrieved.',
    data: {
      totalRecords: initialInScopeReports.length,
      reports: inScopeReports,
    },
  });
}

module.exports = [validate(validations), checkScopes, getAllReports];
