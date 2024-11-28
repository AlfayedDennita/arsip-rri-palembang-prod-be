const express = require('express');

const router = express.Router();

const getAllUsers = require('../controllers/users/getAllUsers');
const getOneUser = require('../controllers/users/getOneUser');
const postOneUser = require('../controllers/users/postOneUser');
const patchOneUser = require('../controllers/users/patchOneUser');
const deleteOneUser = require('../controllers/users/deleteOneUser');

router.get('/', getAllUsers);
router.get('/:id', getOneUser);

router.use(require('../middlewares/onlyAdmin'));

router.post('/', postOneUser);
router.patch('/:id', patchOneUser);
router.delete('/:id', deleteOneUser);

module.exports = router;
