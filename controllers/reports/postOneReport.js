const crypto = require('crypto');
const { Op } = require('sequelize');
const { query, body } = require('express-validator');
const { jsPDF: JsPDF } = require('jspdf');
require('jspdf-autotable');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const checkScopes = require('../../middlewares/checkScopes');
const convertMonthToString = require('../../helpers/convertMonthToString');

const validations = [
  query('preview').optional().isBoolean().default(false),
  body('sortMethod').optional().isIn(['ASC', 'DESC']).default('ASC'),
  body('sortKey')
    .optional()
    .isString()
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
  body('columns')
    .optional()
    .isArray()
    .custom((columns) => {
      const validColumns = [
        'archiveCode',
        'title',
        'publishedAt',
        'scope',
        'createdBy',
        'createdAt',
        'retentionCategory',
        'removedAt',
        'description',
      ];

      const areAllColumnsValid = columns.every((column) =>
        validColumns.includes(column)
      );

      if (!areAllColumnsValid) {
        throw new Error('Some columns are not valid.');
      } else {
        return true;
      }
    }),
  body('reportTitle').exists().isString(),
  body('reportDescription').optional().isString(),
  body('createdAtStart').optional().isISO8601().toDate(),
  body('createdAtEnd').optional().isISO8601().toDate(),
  body('publishedAtStart').optional().isISO8601().toDate(),
  body('publishedAtEnd').optional().isISO8601().toDate(),
  body('scopeId')
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
  body('archiveCodeId')
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
  body('createdById')
    .optional()
    .isString()
    .custom(async (createdById, { req }) => {
      const createdBy = await db.users.findByPk(createdById);

      if (!createdBy) {
        throw new Error('Created by not found.');
      } else if (req.user.role === 'staff' && createdBy.id !== req.user.id) {
        throw new Error('Out of access.');
      } else {
        req.createdBy = createdBy;
        return true;
      }
    }),
  body('description').optional().isString(),
];

const createTableDoc = ({ head, docBody, title, createdAt, createdBy }) => {
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
        'Laporan Arsip - Arsip Digital RRI Palembang',
        data.settings.margin.left,
        22
      );

      const currentPage = doc.internal.getCurrentPageInfo().pageNumber;

      const formattedCreatedAt = `${createdAt.getDate()} ${convertMonthToString(
        createdAt.getMonth()
      )} ${createdAt.getFullYear()}`;

      if (currentPage === 1) {
        doc.setFontSize(12);

        doc.text('Judul Laporan', data.settings.margin.left, 30);
        doc.text('Dibuat Tanggal', data.settings.margin.left, 36);
        doc.text('Dibuat Oleh', data.settings.margin.left, 42);

        doc.setFont('helvetica', 'normal');

        doc.text(`: ${title}`, data.settings.margin.left + 48, 30);
        doc.text(`: ${formattedCreatedAt}`, data.settings.margin.left + 48, 36);
        doc.text(`: ${createdBy}`, data.settings.margin.left + 48, 42);
      }
    },
  });

  return doc;
};

async function postOneReport(req, res) {
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

  const sortKey = {
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
        ...sortKey[req.matchedData?.sortKey || 'createdAt'],
        req.matchedData?.sortMethod || 'ASC',
      ],
    ],
  };

  if (req.user.role === 'staff') {
    retrieveOptions.where.createdBy = req.user.id;
  }

  if (req.matchedData?.createdAtStart) {
    (retrieveOptions.where.createdAt ??= {})[Op.gte] =
      req.matchedData.createdAtStart;
  }
  if (req.matchedData?.createdAtEnd) {
    (retrieveOptions.where.createdAt ??= {})[Op.lte] =
      req.matchedData.createdAtEnd;
  }
  if (req.matchedData?.publishedAtStart) {
    (retrieveOptions.where.publishedAt ??= {})[Op.gte] =
      req.matchedData.publishedAtStart;
  }
  if (req.matchedData?.publishedAtEnd) {
    (retrieveOptions.where.publishedAt ??= {})[Op.lte] =
      req.matchedData.publishedAtEnd;
  }
  if (req.matchedData?.scopeId) {
    retrieveOptions.include[1].include[0].where.id = req.matchedData.scopeId;
  }
  if (req.matchedData?.archiveCodeId) {
    retrieveOptions.include[1].where.id = req.matchedData.archiveCodeId;
  }
  if (req.matchedData?.createdById) {
    if (req.user.role !== 'staff') {
      retrieveOptions.where.createdBy = req.matchedData.createdById;
    }
  }
  if (req.matchedData?.description) {
    (retrieveOptions.where.description ??= {})[
      Op.iLike
    ] = `%${req.matchedData.description}%`;
  }

  const initialInScopeArchives = await db.archives.findAll(retrieveOptions);

  if (req.matchedData?.preview) {
    retrieveOptions.limit = 10;
  }

  const inScopeArchives = await db.archives.findAll(retrieveOptions);

  if (req.matchedData.preview) {
    return res.status(200).json({
      status: 'success',
      message: 'Preview successfully retrieved.',
      data: {
        totalRecords: initialInScopeArchives.length,
        archives: inScopeArchives,
      },
    });
  }

  const headInBahasaId = {
    archiveCode: 'Kode Arsip',
    title: 'Judul',
    publishedAt: 'Tanggal Terbit',
    scope: 'Cakupan',
    createdBy: 'Nama Pengunggah',
    createdAt: 'Tanggal Unggah',
    retentionCategory: 'Kategori Retensi',
    removedAt: 'Tanggal Retensi',
    description: 'Keterangan',
  };

  const formatDate = (date) =>
    `${date.getDate()}-${date.getMonth() + 1}-${date.getFullYear()}`;

  const retentionCategories = {
    vital: 'Vital',
    important: 'Penting',
    useful: 'Berguna',
    temporary: 'Sementara',
  };

  const getValue = {
    archiveCode: (archive) => archive.ArchiveCode.code,
    title: (archive) => archive.title,
    publishedAt: (archive) =>
      archive.publishedAt ? formatDate(new Date(archive.publishedAt)) : '',
    scope: (archive) => archive.ArchiveCode.Scope.name,
    createdBy: (archive) => archive.User.name,
    createdAt: (archive) =>
      archive.createdAt ? formatDate(new Date(archive.createdAt)) : '',
    retentionCategory: (archive) =>
      retentionCategories[archive.retentionCategory],
    removedAt: (archive) =>
      archive.removedAt ? formatDate(new Date(archive.removedAt)) : '',
    description: (archive) => archive.description,
  };

  const head = [[]];

  const columns = req.matchedData?.columns || [
    'archiveCode',
    'title',
    'publishedAt',
    'scope',
    'createdBy',
    'createdAt',
    'retentionCategory',
    'removedAt',
  ];

  for (const column of columns) {
    head[0].push(headInBahasaId[column]);
  }

  const docBody = inScopeArchives.map((archive) => {
    const row = [];

    for (const column of columns) {
      row.push(getValue[column](archive));
    }

    return row;
  });

  const doc = createTableDoc({
    head,
    docBody,
    title: req.matchedData.reportTitle,
    createdAt: new Date(),
    createdBy: req.user.name,
  });

  const uuid = crypto.randomUUID();
  const reportsPath = './public/reports';
  const fileName = `${uuid}.pdf`;
  const filePath = `${reportsPath}/${fileName}`;

  doc.save(filePath);

  const report = await req.user.createReport({
    id: uuid,
    title: req.matchedData.reportTitle,
    description: req.matchedData.reportDescription,
    ScopeId: req.user.ScopeId,
  });

  return res.status(201).json({
    status: 'success',
    message: 'Report successfully created.',
    data: {
      report,
    },
  });
}

module.exports = [validate(validations), checkScopes, postOneReport];
