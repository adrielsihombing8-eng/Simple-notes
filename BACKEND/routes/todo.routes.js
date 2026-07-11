const todoController = require('../controller/todo.controller');
const express = require('express').Router();

express.post('/store-note', todoController.auth, todoController.todoStore);
express.get('/get-note', todoController.auth, todoController.getNote);
express.get('/get-noteByKategori', todoController.auth, todoController.getNoteByData)

module.exports = express;