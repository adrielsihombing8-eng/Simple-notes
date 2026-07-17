const jwt = require("jsonwebtoken");
const userdatasModel = require('../model/userdatas.model.js');

class UserDatasServices{
    static async createDatas(userId, {username}){
        try{
            const datas = new userdatasModel({userId,username});
            return await datas.save();
        }
        catch(err){
            throw new Error('data gagal di simpan');
        }
    }

    static async findData(userId){
        try{
            const datas = await userdatasModel.findById(userId);
            return datas;
        }
        catch(err){
            throw new Error('error find datas');
        }
    }
}

module.exports = UserDatasServices;