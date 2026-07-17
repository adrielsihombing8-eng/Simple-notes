const UserDatasController = require('../controller/userdatas.controller');
const userdatasModel = require('../model/userdatas.model');
const express = require ('express').Router();

express.post('/userBio', UserDatasController.auth, UserDatasController.saveUser);
express.get('/getUserBio', UserDatasController.auth,)

module.exports = express;