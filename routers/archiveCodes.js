const express = require('express');

const router = express.Router();

const getAllArchiveCodes = require('../controllers/archiveCodes/getAllArchiveCodes');
const getOneArchiveCode = require('../controllers/archiveCodes/getOneArchiveCode');
const postOneArchiveCode = require('../controllers/archiveCodes/postOneArchiveCode');
const patchOneArchiveCode = require('../controllers/archiveCodes/patchOneArchiveCode');
const deleteOneArchiveCode = require('../controllers/archiveCodes/deleteOneArchiveCode');

router.get('/', getAllArchiveCodes);
router.get('/:id', getOneArchiveCode);

router.use(require('../middlewares/onlyAdmin'));

router.post('/', postOneArchiveCode);
router.patch('/:id', patchOneArchiveCode);
router.delete('/:id', deleteOneArchiveCode);

module.exports = router;
