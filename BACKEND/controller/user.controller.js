const UserService = require("../services/user.services.js");
const userServices = require("../services/user.services.js");
const jwt = require("jsonwebtoken");

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const user = await userServices.createUser(email, password);
        res.status(200).json({ message: "User registered successfully", user });
        console.log("data berhasil di kirim");
    } catch (error) {
        next(error);
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await userServices.CekEmail(email);
        console.log(typeof user.comparePw);

        if (!user) {
            return res.status(404).json({ message: "account not found" });
        }

        const isMatch = await user.comparePw(password);
        if (!isMatch) {
            return res.status(401).json({ message: "Password salah" });
        }

        let tokenData = { _id: user._id, email: user.email };
        const token = await userServices.generateToken(
            tokenData,
            "secret_key",
            "1h",
        );

        res.status(200).json({
            message: "token telah di buat!!!",
            token: token,
            status: true,
            user,
        });
    } catch (error) {
        next(error);
    }
};

exports.auth = async (req, res, next) => {
    const authHeader = req.headers["authorization"];

    if (!authHeader) {
        return res.status(401).json({ message: "Authorization header missing" });
    }

    const token = authHeader.split(" ")[1];

    if (!token) {
        return res.status(401).json({ message: "Token missing" });
    }

    try {
        const decoded = jwt.verify(token, "secret_key");
        req.user = decoded;
        return res.status(200).json({
            status: true,
            message: "Token valid",
            user: decoded,
        });
        console.log("data berhasil di deteksi");
    } catch (err) {
        if (err.name === "TokenExpiredError") {
            return res.status(401).json({
                status: false,
                message: "Token sudah expired, silakan login ulang",
            });
        }

        if (err.name === "JsonWebTokenError") {
            return res.status(401).json({
                status: false,
                message: "Token tidak valid",
            });
        }

        return res.status(500).json({
            status: false,
            message: "Server error",
        });
    }
};
