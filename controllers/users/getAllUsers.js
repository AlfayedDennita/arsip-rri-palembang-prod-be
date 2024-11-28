const fs = require('fs');
const { Op } = require('sequelize');
const { query } = require('express-validator');
const { jsPDF: JsPDF } = require('jspdf');
require('jspdf-autotable');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');
const convertMonthToString = require('../../helpers/convertMonthToString');

const validations = [
  query('download').optional().isBoolean(),
  query('sortMethod').optional().isIn(['ASC', 'DESC']).default('ASC'),
  query('sortKey')
    .optional()
    .isIn(['name', 'email', 'role', 'createdAt', 'scope'])
    .default('createdAt'),
  query('offset').optional().isInt().default(0).toInt(),
  query('limit').optional().isInt().default(10).toInt(),
  query('name').optional().isString(),
  query('email').optional().isString(),
  query('username').optional().isString(),
  query('role').optional().isString(),
  query('createdAtStart').optional().isISO8601().toDate(),
  query('createdAtEnd').optional().isISO8601().toDate(),
  query('scopeId')
    .optional()
    .isString()
    .custom(async (scopeId, { req }) => {
      const scope = await db.scopes.findByPk(scopeId);

      if (!scope) {
        throw new Error('Scope not found.');
      } else {
        req.scope = scope;
        req.scopesToCheck.push(scope.id);
        return true;
      }
    }),
];

const createTableDoc = ({ head, docBody, createdAt, createdBy }) => {
  const doc = new JsPDF();

  doc.autoTable({
    head,
    body: docBody,
    styles: {
      cellPadding: 2,
      textColor: '#334155',
      lineColor: '#cbd5e1',
      lineWidth: 0.5,
    },
    headStyles: {
      halign: 'center',
      valign: 'middle',
      fontStyle: 'bold',
      fillColor: '#e2e8f0',
    },
    startY: 50,
    didDrawPage: (data) => {
      doc.setFontSize(16);
      doc.setTextColor('#334155');
      doc.setFont('helvetica', 'bold');
      doc.text(
        'Laporan Pengguna - Arsip Digital RRI Palembang',
        data.settings.margin.left,
        22
      );

      const currentPage = doc.internal.getCurrentPageInfo().pageNumber;

      const formattedCreatedAt = `${createdAt.getDate()} ${convertMonthToString(
        createdAt.getMonth()
      )} ${createdAt.getFullYear()}`;

      if (currentPage === 1) {
        doc.setFontSize(12);

        doc.text('Dibuat Tanggal', data.settings.margin.left, 36);
        doc.text('Dibuat Oleh', data.settings.margin.left, 42);

        doc.setFont('helvetica', 'normal');

        doc.text(`: ${formattedCreatedAt}`, data.settings.margin.left + 48, 36);
        doc.text(`: ${createdBy}`, data.settings.margin.left + 48, 42);
      }
    },
  });

  return doc;
};

async function getAllUsers(req, res) {
  const sortKeys = {
    name: ['name'],
    email: ['email'],
    role: ['role'],
    createdAt: ['createdAt'],
    scope: [db.scopes, 'name'],
  };

  const retrieveOptions = {
    where: {
      ScopeId: {
        [Op.in]: req.visibleScopeIds,
      },
    },
    include: [
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

  if (req.matchedData?.name) {
    (retrieveOptions.where.name ??= {})[Op.iLike] = `%${req.matchedData.name}%`;
  }
  if (req.matchedData?.email) {
    (retrieveOptions.where.email ??= {})[
      Op.iLike
    ] = `%${req.matchedData.email}%`;
  }
  if (req.matchedData?.username) {
    (retrieveOptions.where.username ??= {})[
      Op.iLike
    ] = `%${req.matchedData.username}%`;
  }
  if (req.matchedData?.role) {
    retrieveOptions.where.role = req.matchedData.role;
  }
  if (req.matchedData?.createdAtStart) {
    (retrieveOptions.where.createdAt ??= {})[Op.gte] =
      req.matchedData.createdAtStart;
  }
  if (req.matchedData?.createdAtEnd) {
    (retrieveOptions.where.createdAt ??= {})[Op.lte] =
      req.matchedData.createdAtEnd;
  }
  if (req.matchedData?.scopeId) {
    retrieveOptions.include[0].where.id = req.matchedData.scopeId;
  }

  const initialInScopeUsers = await db.users.findAll(retrieveOptions);

  retrieveOptions.offset = req.matchedData?.offset || 0;
  if (req.matchedData.limit !== 0) {
    retrieveOptions.limit = req.matchedData?.limit || 10;
  }

  let inScopeUsers = await db.users.findAll(retrieveOptions);

  if (req.matchedData.download) {
    const headInBahasaId = {
      name: 'Nama',
      username: 'Username',
      email: 'Alamat Surel',
      role: 'Role',
      scope: 'Cakupan',
      createdAt: 'Tanggal Dibuat',
    };

    const formatDate = (date) =>
      `${date.getDate()}-${date.getMonth() + 1}-${date.getFullYear()}`;

    const roles = {
      root: 'Administrator Utama',
      admin: 'Administrator Cakupan',
      leader: 'Pimpinan',
      staff: 'Staf',
    };

    const getValue = {
      name: (user) => user.name,
      username: (user) => user.username,
      email: (user) => user.email,
      role: (user) => roles[user.role],
      scope: (user) => user.Scope.name,
      createdAt: (user) =>
        user.createdAt ? formatDate(new Date(user.createdAt)) : '',
    };

    const head = [[]];

    const columns = ['name', 'username', 'email', 'role', 'scope', 'createdAt'];

    for (const column of columns) {
      head[0].push(headInBahasaId[column]);
    }

    const docBody = inScopeUsers.map((user) => {
      const row = [];

      for (const column of columns) {
        row.push(getValue[column](user));
      }

      return row;
    });

    const doc = createTableDoc({
      head,
      docBody,
      createdAt: new Date(),
      createdBy: req.user.name,
    });

    const reportsPath = './public/reports/users';
    const fileName = `${req.user.id}.pdf`;
    const filePath = `${reportsPath}/${fileName}`;

    doc.save(filePath);

    return res.status(201).json({
      status: 'success',
      message: 'Users report successfully created.',
      data: {
        url: `${process.env.BACK_END_BASE_URL}/static/reports/users/${req.user.id}.pdf`,
      },
    });
  }

  inScopeUsers = inScopeUsers.map((user) => {
    const avatarsPath = './public/images/avatars';
    const userAvatarFileName = `${user.id}.jpg`;
    const userAvatarPath = `${avatarsPath}/${userAvatarFileName}`;

    let avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/default.jpg`;

    if (fs.existsSync(userAvatarPath)) {
      avatarUrl = `${process.env.BACK_END_BASE_URL}/static/images/avatars/${user.id}.jpg`;
    }

    return {
      ...user.toJSON(),
      avatarUrl,
    };
  });

  return res.status(200).json({
    status: 'success',
    message: 'All users successfully retrieved.',
    data: {
      totalRecords: initialInScopeUsers.length,
      users: inScopeUsers,
    },
  });
}

module.exports = [validate(validations), checkScopes, getAllUsers];
