const express = require('express');

const router = express.Router();

const getBasicStats = require('../controllers/stats/getBasicStats');
const getHistoryStats = require('../controllers/stats/getHistoryStats');

router.get('/basic', getBasicStats);
router.get('/history', getHistoryStats);

module.exports = router;
