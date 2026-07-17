const TodoService = require("../services/todo.services");
const TodoModels = require("../model/todo.model");
const jwt = require("jsonwebtoken");

exports.getNote = async (req, res, next) => {
    try {
        const userId = req.userId;
        const note = await TodoModels.find({ userId }).sort({ createdAt: -1 });
        console.log(note);
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

exports.getNoteBYTitle = async (req, res, next) => {
    try {
        console.log("memulai pencarian");

        const { keyword } = req.query;
        let filter = { userId: req.userId };

        if (keyword) {
            const keywords = keyword.trim().split(/\s+/).filter(Boolean);
            filter.$and = keywords.map(kw => ({
                title: { $regex: kw, $options: "i" }
            }));

            console.log(filter);
        }

        console.log("memulai penfilteran data");
        const notes = await TodoService.FindByName(filter);
        console.log("berhasil data didapatkan");
        console.log(notes);
        res.status(200).json({
            success: true,
            data: notes,
        });
    }
    catch (err) {
        console.log(err);
        next();
    }
};

exports.getNoteByKatAndTitle = async (req, res, next) => {
    const { title, kategori } = req.query;
    const filter = { userId: req.userId };
    const andConditon = [];

    if (title) {
        title.trim().split(/\s+/).filter(Boolean).forEach(word => {
            andConditon.push({ $regex: word, $options: "i" })
        });
    }

    if (kategori) {
        kategori.trim().split(/\s+/).filter(Boolean).forEach(word => {
            andConditon.push({ $regex: word, $options: "i" })
        })
    }

    if (andConditon > 0) {
        filter.$and = andConditon;
    }

    console.log("cari data");
    const notes = await TodoService.FindByName(filter);
    console.log("data ditemukan");

    res.status(200).json({
        success: true,
        data: notes
    })
};

exports.delateData = async (req, res, next) => {
    try {
        const { ids } = req.body;
        const userId = req.userId;

        const note = await TodoService.findNote()
        if (notes.length === 0) {
            return res.status(404).json({ message: "Data tidak ditemukan" });
        }

        const unauthorized = notes.some(note => note.userId.toString() !== userId.toString());
        if (unauthorized) {
            return res.status(403).json({ message: "Tidak punya akses ke beberapa data" });
        }

        const result = await TodoService.delateNote(ids);

        if (result.deletedCount === 0) {
            return res.status(404).json({ message: "Data gagal di hapus" });
        }

        console.log("data di hapus");
        return res.status(200).json({ message: "Data di hapus" });
    }
    catch (err) {
        next(err);
    }
};

exports.updateData = async (req, res, next) => {
    try {
        const { id } = req.params;
        const note = await TodoService.findNote(id);
        const userId = req.userId;

        if (note) {
            if (userId.toString() === note.userId.toString()) {
                const updateNote = await TodoService.updateNote(id, req.body);
                return res.status(200).json({ message: "Data diupdate", data: updateNote });
            }
            else {
                return res.status(403).json({ message: "tidak memiliki akses ke data ini" });
            }
        }
        else {
            return res.status(404).json({ message: "Data tidak ditemukan" });
        }
    }
    catch (err) {
        next(err);
    }
};