const UserDatasServices = require ('../services/userdatas.services');
const jwt = require('jsonwebtoken');

exports.auth = async (req, res, next) => {
    const authHeader = req.headers['authorization'];

    if(!authHeader){
        return res.status(401).json({messanges: "authorization tidak ada"});
    }

    const token = authHeaders.split(" ")[1];

    if(!token){
        console.log("Token missing");
        return res.status(401).json({ message: "Token missing" });
    }

    try{
    const decode = jwt.verify(token,"secret_key");
    req.userId = decode._id;
    }
    catch(err){
if (err.name === "TokenExpiredError") {
            console.log("Token sudah expired, silakan login ulang");
            return res.status(401).json({
                status: false,
                message: "Token sudah expired, silakan login ulang",
            });
        }

        if (err.name === "JsonWebTokenError") {
            console.log("Token tidak valid");
            return res.status(401).json({
                status: false,
                message: "Token tidak valid",
            });
        }

        console.log("Server error");
        return res.status(500).json({
            status: false,
            message: "Server error",
        });
    }
};

exports.saveUser = async (req, res, next) =>{
    try{
        const {username} = req.body;
        let user = {userId: req.userId};
        const Users = await UserDatasServices.createDatas(user, username);
    }
    catch(err){
        next(err);
    }
};

exports.getDatas = async (req, res, next) => {
    let users = {userId: req.userId};

    try{
        console.log("memulai pencarian data");
        const Datas = await UserDatasServices.findData(users);
        console.log("data ditemukan");
        res.status(200).json({
            succes: true,
            data: Datas
        })
    }
    catch(err){
        res.status(500).json({ success: false, message: err.message });
    }
};