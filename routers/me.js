const express = require('express');

const router = express.Router();

const getMe = require('../controllers/me/getMe');
const patchMe = require('../controllers/me/patchMe');

router.get('/', getMe);
router.patch('/', patchMe);

module.exports = router;
