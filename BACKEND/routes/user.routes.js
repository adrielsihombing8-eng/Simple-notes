const userController = require('../controller/user.controller');
const express = require('express').Router();

express.post('/register', userController.register);
express.post('/login',userController.login)
express.get('/auth', userController.auth);
express.post('/refresh', userController.refreshToken);

module.exports = express;