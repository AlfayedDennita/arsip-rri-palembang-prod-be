const express = require('express');

const router = express.Router();

const login = require('../controllers/auth/login');
const logout = require('../controllers/auth/logout');
const refreshToken = require('../controllers/auth/refreshToken');
const postOneResetPasswordRequest = require('../controllers/auth/postOneResetPasswordRequest');
const getOneResetPasswordRequest = require('../controllers/auth/getOneResetPasswordRequest');
const resetPassword = require('../controllers/auth/resetPassword');

router.post('/login', login);
router.post('/logout', logout);
router.post('/refresh-token', refreshToken);
router.post('/reset-password/request', postOneResetPasswordRequest);
router.get('/reset-password/request/:id', getOneResetPasswordRequest);
router.post('/reset-password/reset/:id', resetPassword);

module.exports = router;
