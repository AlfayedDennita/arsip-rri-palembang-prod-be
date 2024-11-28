const express = require('express');

const router = express.Router();

const getAllScopes = require('../controllers/scopes/getAllScopes');
const getOneScope = require('../controllers/scopes/getOneScope');
const postOneScope = require('../controllers/scopes/postOneScope');
const patchOneScope = require('../controllers/scopes/patchOneScope');
const deleteOneScope = require('../controllers/scopes/deleteOneScope');

router.get('/', getAllScopes);
router.get('/:id', getOneScope);

router.use(require('../middlewares/onlyAdmin'));

router.post('/', postOneScope);
router.patch('/:id', patchOneScope);
router.delete('/:id', deleteOneScope);

module.exports = router;
