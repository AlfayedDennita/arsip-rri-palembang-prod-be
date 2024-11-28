const { Op } = require('sequelize');
const { query } = require('express-validator');

const db = require('../../models');
const validate = require('../../middlewares/validate');
const getScopeDescendants = require('../../middlewares/getScopeDescendants');
const convertMonthToString = require('../../helpers/convertMonthToString');

const validations = [
  query('table')
    .exists()
    .withMessage('Table is required.')
    .isIn(['archives', 'reports']),
  query('type')
    .exists()
    .withMessage('Type is required.')
    .isIn(['inScope', 'personal']),
  query('period')
    .exists()
    .withMessage('Period is required.')
    .isIn(['daily', 'monthly']),
];

const createLastSecondOfDate = (date) => {
  const newDate = new Date(date);

  newDate.setHours(23);
  newDate.setMinutes(59);
  newDate.setSeconds(59);

  return newDate;
};

const createLastSecondOfMonth = (date) => {
  const newDate = new Date(date);

  const lastDateOfMonth = new Date(
    newDate.getFullYear(),
    newDate.getMonth() + 1,
    0
  );

  lastDateOfMonth.setHours(23);
  lastDateOfMonth.setMinutes(59);
  lastDateOfMonth.setSeconds(59);

  return lastDateOfMonth;
};

async function getHistoryStats(req, res) {
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

  let retrieveOptions;

  if (req.matchedData.table === 'archives') {
    retrieveOptions = {
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
  } else {
    retrieveOptions = {
      where: {
        ScopeId: {
          [Op.in]: req.visibleScopeIds,
        },
      },
      include: [db.users, db.scopes],
    };
  }

  const limits = {};

  const date = new Date();

  if (req.matchedData.period === 'daily') {
    const todayLastSecondOfDate = createLastSecondOfDate(date);

    const dates = [todayLastSecondOfDate];

    for (let i = 1; i < 7; i++) {
      const newDate = new Date(todayLastSecondOfDate);
      newDate.setDate(newDate.getDate() - i);
      const lastSecondOfDate = createLastSecondOfDate(newDate);

      dates.push(lastSecondOfDate);
    }

    dates.forEach((d) => {
      limits[`${d.getDate()} ${convertMonthToString(d.getMonth(), true)}`] = d;
    });
  } else {
    const todayLastSecondOfMonth = createLastSecondOfMonth(date);

    const months = [todayLastSecondOfMonth];

    for (let i = 1; i < 5; i++) {
      const newDate = new Date(todayLastSecondOfMonth);
      newDate.setDate(1);
      newDate.setMonth(newDate.getMonth() - i);
      const lastSecondOfMonth = createLastSecondOfMonth(newDate);

      months.push(lastSecondOfMonth);
    }

    months.forEach((month) => {
      limits[`${convertMonthToString(month.getMonth(), true)}`] = month;
    });
  }

  const history = {};

  for (const limit in limits) {
    const newRetrieveOptions = retrieveOptions;

    (newRetrieveOptions.where.createdAt ??= {})[Op.lte] = limits[limit];

    if (req.matchedData.type === 'personal') {
      newRetrieveOptions.where.createdBy = req.user.id;
    }

    const tableRecords = await db[
      req.matchedData.table === 'archives' ? 'archives' : 'reports'
    ].findAll(newRetrieveOptions);

    history[limit] = tableRecords.length;
  }

  return res.status(200).json({
    status: 'success',
    message: 'History successfully retrieved.',
    data: {
      history,
    },
  });
}

module.exports = [validate(validations), getScopeDescendants, getHistoryStats];
