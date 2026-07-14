const todoController = require('../controller/todo.controller');
const express = require('express').Router();

express.post('/store-note', todoController.auth, todoController.todoStore);
express.get('/get-note', todoController.auth, todoController.getNote);
express.get('/get-noteByKategori', todoController.auth, todoController.getNoteByData);
express.get('/get-noteByName', todoController.auth, todoController.getNoteBYTitle);
express.get('get-noteByNameAndKategory', todoController.auth, todoController.getNoteByKatAndTitle);

module.exports = express;