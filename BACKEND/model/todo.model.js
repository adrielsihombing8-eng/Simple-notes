const mongoose = require('mongoose');
const db = require('../config/db');
const Usermodel = require('./user.model');

const {Schema} = mongoose;

const todoSchema = new Schema({
    userId:{
        type: Schema.Types.ObjectId,
        ref: Usermodel.modelName,
        required: true
    },
    title:{
        type: String,
        lowercase: true,
        required: true,
        unique: true
    },
    pref:{
        type: String,
    },
    date:{
        type: String,
        required: true
    },
    time:{
        type: String,
        required: true
    },
    description:{
        type: String,
    }
},{timestamps: true});

module.exports = mongoose.model('todo', todoSchema);