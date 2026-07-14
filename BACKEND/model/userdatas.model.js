const mongoose = require ('mongoose');
const db = require('../config/db');
const userModel = require('./user.model');

const {Schema} = mongoose;

const userDatas = new Schema({
    userId:{
        type: Schema.Types.ObjectId,
        ref: userModel.modelName,
        require: true
    },
    username:{
        type: String,
        required: true,
    }
});

module.exports = mongoose.model('userDatas', userDatas);