const TodoService = require("../services/todo.services");
const TodoModels = require("../model/todo.model");
const jwt = require("jsonwebtoken");

exports.getNote = async (req, res, next) => {
    try {
        const userId = req.userId;
        const note = await TodoModels.find({ userId }).sort({ createdAt: -1 });
        res.status(200).json({ status: true, data: note });
    } catch (error) {
        next(error);
    }
};

exports.todoStore = async (req, res, next) => {
    try {
        const { title, pref, description, date, time } = req.body;
        const userId = req.userId;
        const todo = await TodoService.createTodo(userId, {
            title,
            pref,
            description,
            date,
            time,
        });
        console.log("data berhasil di kirim");
        res.status(200).json({ message: "data todo disimpan" });
    } catch (error) {
        next(error);
    }
};

exports.auth = async (req, res, next) => {
    console.log("memulai auth");
    const authHeader = req.headers["authorization"];

    if (!authHeader) {
        console.log("Authorization header missing");
        return res.status(401).json({ message: "Authorization header missing" });
    }

    const token = authHeader.split(" ")[1];

    if (!token) {
        console.log("Token missing");
        return res.status(401).json({ message: "Token missing" });
    }

    try {
        console.log("token berhasil");
        const decode = jwt.verify(token, "secret_key");
        req.userId = decode._id;
        next();
    } catch (err) {
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

exports.getNoteByData = async (req, res, next) => {
    try {
        console.log("memulai pemanggilan data");
        const { keyword } = req.query;
        console.log(keyword);

        let filter = { userId: req.userId };
        console.log("req.userId:", req.userId);
        console.log("typeof:", typeof req.userId);

        console.log("fiter berhasil");
        if (keyword) {
            filter.pref = { $regex: keyword, $options: "i" };
        }

        console.log("memulai find data");
        const notes = await TodoService.FindByKategori(filter);
        console.log("berhasil");
        console.log(notes);
        res.status(200).json({
            success: true,
            data: notes,
        });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};
