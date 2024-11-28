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
    .isIn(['archiveCode', 'createdAt', 'scope', 'description'])
    .default('createdAt'),
  query('offset').optional().isInt().default(0).toInt(),
  query('limit').optional().isInt().default(10).toInt(),
  // Filters
  query('archiveCodeId')
    .optional()
    .isString()
    .custom(async (archiveCodeId, { req }) => {
      const archiveCode = await db.archiveCodes.findByPk(archiveCodeId);

      if (!archiveCode) {
        throw new Error('Archive code not found.');
      } else {
        req.archiveCode = archiveCode;
        req.scopesToCheck.push((await archiveCode.getScope()).id);
        return true;
      }
    }),
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
  query('description').optional().isString(),
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
        'Laporan Kode Arsip - Arsip Digital RRI Palembang',
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

async function getAllArchiveCodes(req, res) {
  const sortKeys = {
    archiveCode: ['code'],
    createdAt: ['createdAt'],
    scope: [db.scopes, 'name'],
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
        model: db.scopes,
        where: {},
      },
      {
        model: db.archives,
        required: false,
      },
    ],
    order: [
      [
        ...sortKeys[req.matchedData?.sortKey || 'createdAt'],
        req.matchedData?.sortMethod || 'ASC',
      ],
    ],
  };

  if (req.matchedData?.archiveCodeId) {
    retrieveOptions.where.id = req.matchedData.archiveCodeId;
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
  if (req.matchedData?.description) {
    (retrieveOptions.where.description ??= {})[
      Op.iLike
    ] = `%${req.matchedData.description}%`;
  }

  const initialInScopeArchiveCodes = await db.archiveCodes.findAll(
    retrieveOptions
  );

  retrieveOptions.offset = req.matchedData?.offset || 0;
  if (req.matchedData.limit !== 0) {
    retrieveOptions.limit = req.matchedData?.limit || 10;
  }

  const inScopeArchiveCodes = await db.archiveCodes.findAll(retrieveOptions);

  if (req.matchedData.download) {
    const headInBahasaId = {
      archiveCode: 'Kode Arsip',
      scope: 'Cakupan',
      createdAt: 'Tanggal Dibuat',
      description: 'Keterangan',
    };

    const formatDate = (date) =>
      `${date.getDate()}-${date.getMonth() + 1}-${date.getFullYear()}`;

    const getValue = {
      archiveCode: (archiveCode) => archiveCode.code,
      scope: (archiveCode) => archiveCode.Scope.name,
      createdAt: (archiveCode) =>
        archiveCode.createdAt
          ? formatDate(new Date(archiveCode.createdAt))
          : '',
      description: (archiveCode) => archiveCode.description,
    };

    const head = [[]];

    const columns = ['archiveCode', 'scope', 'createdAt', 'description'];

    for (const column of columns) {
      head[0].push(headInBahasaId[column]);
    }

    const docBody = inScopeArchiveCodes.map((archiveCode) => {
      const row = [];

      for (const column of columns) {
        row.push(getValue[column](archiveCode));
      }

      return row;
    });

    const doc = createTableDoc({
      head,
      docBody,
      createdAt: new Date(),
      createdBy: req.user.name,
    });

    const reportsPath = './public/reports/archive-codes';
    const fileName = `${req.user.id}.pdf`;
    const filePath = `${reportsPath}/${fileName}`;

    doc.save(filePath);

    return res.status(201).json({
      status: 'success',
      message: 'Archive codes report successfully created.',
      data: {
        url: `${process.env.BACK_END_BASE_URL}/static/reports/archive-codes/${req.user.id}.pdf`,
      },
    });
  }

  return res.status(200).json({
    status: 'success',
    message: 'All archive codes successfully retrieved.',
    data: {
      totalRecords: initialInScopeArchiveCodes.length,
      archiveCodes: inScopeArchiveCodes,
    },
  });
}

module.exports = [validate(validations), checkScopes, getAllArchiveCodes];
