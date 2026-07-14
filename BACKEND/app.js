const express = require('express');
const userRoutes = require('./routes/user.routes');
const todoRoutes = require('./routes/todo.routes');
const userDatas = require('./routes/userdatas.routes');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json())
app.use(express.urlencoded({extended : true}))
app.use('/', userRoutes);
app.use('/', todoRoutes);
app.use('/', userDatas);
app.use((err, req, res, next) => {
    res.status(500).json({ error: err.message });
});

module.exports = app;