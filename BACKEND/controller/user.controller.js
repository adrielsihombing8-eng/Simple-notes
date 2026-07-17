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

        if (!user) {
            return res.status(404).json({ message: "account not found" });
        }

        console.log(typeof user.comparePw);

        const isMatch = await user.comparePw(password);
        if (!isMatch) {
            return res.status(401).json({ message: "Password salah" });
        }

        let tokenData = { _id: user._id, email: user.email };
        const token = await userServices.generateToken(
            tokenData,
            "secret_key",
            "15m",
        );

        const refreshToken = await userServices.generateToken(
            { _id: user._id },
            "refresh_secret_token",
            "7d",
        );

        console.log("data di buat");

        user.refreshToken = refreshToken;
        await user.save();

        console.log("data di save");

        res.status(200).json({
            message: "token telah di buat!!!",
            status: true,
            token: token,
            refreshToken: refreshToken,
        });
    } catch (error) {
        console.log("data error : " + error);
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
        console.log("data berhasil di deteksi");
        return res.status(200).json({
            status: true,
            message: "Token valid",
            user: decoded,
        });
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

exports.refreshToken = async (req, res, next) => {
    try {
        const { refreshToken } = req.body;

        if (!refreshToken) {
            return res.status(401).json({ message: "referes token missing" });
        }

        const decoded = jwt.verify(refreshToken, "refresh_secret_token");

        const user = await userServices.CariById(decoded._id);

        if (!user || user.refreshToken !== refreshToken) {
            return res.status(403).json({ message: "refresh token tidak valid" });
        }

        const newToken = await userServices.generateToken(
            { _id: user._id, email: user.email },
            "secret_key",
            "15m",
        );

        res.status(200).json({
            status: true,
            message: "token baru dibuat",
            token: newToken,
        });
    } catch (err) {
        if (err.name === "TokenExpiredError") {
            return res
                .status(403)
                .json({
                    status: false,
                    message: "Refresh token sudah expired, silakan login ulang",
                });
        }
        if (err.name === "JsonWebTokenError") {
            return res
                .status(403)
                .json({ status: false, message: "Refresh token tidak valid" });
        }
        console.log("data error refreshToken:", err);
        return res.status(500).json({ status: false, message: "Server error" });
    }
};
