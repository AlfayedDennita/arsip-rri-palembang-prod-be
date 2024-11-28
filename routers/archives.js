const express = require('express');

const router = express.Router();

const semanticSearch = require('../controllers/archives/semanticSearch');
const getAllArchives = require('../controllers/archives/getAllArchives');
const getOneArchive = require('../controllers/archives/getOneArchive');
const postOneArchive = require('../controllers/archives/postOneArchive');
const patchOneArchive = require('../controllers/archives/patchOneArchive');
const deleteOneArchive = require('../controllers/archives/deleteOneArchive');

router.get('/semantic-search', semanticSearch);
router.get('/', getAllArchives);
router.get('/:id', getOneArchive);
router.post('/', postOneArchive);
router.patch('/:id', patchOneArchive);
router.delete('/:id', deleteOneArchive);

module.exports = router;
