const userModel = require('../model/user.model.js');
const jwt = require("jsonwebtoken");

class UserService {
    static async createUser(email, password){
        try{
            const user = new userModel({ email, password });
            return await user.save();
        }
        catch (error) {
            throw new Error('Error creating user: ' + error.message);
        }
    }

    static async CekEmail(email){
        try {
            return userModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData, secretKey, jwt_expire){
        return jwt.sign(tokenData,secretKey,{expiresIn:jwt_expire});
    }

    static async CariById(id){
        try{
            return userModel.findById(id);
        }
        catch(err){
            throw err;
        }
    }
}

module.exports = UserService;