const express = require('express');

const router = express.Router();

const getAllReports = require('../controllers/reports/getAllReports');
const getOneReport = require('../controllers/reports/getOneReport');
const postOneReport = require('../controllers/reports/postOneReport');
const patchOneReport = require('../controllers/reports/patchOneReport');
const deleteOneReport = require('../controllers/reports/deleteOneReport');

router.get('/', getAllReports);
router.get('/:id', getOneReport);
router.post('/', postOneReport);
router.patch('/:id', patchOneReport);
router.delete('/:id', deleteOneReport);

module.exports = router;
