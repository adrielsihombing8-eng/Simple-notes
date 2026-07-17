const todoModel = require("../model/todo.model");

class TodoService {
    static async createTodo(userId, { title, pref, description, date, time }) {
        try {
            const todo = new todoModel({
                userId,
                title,
                pref,
                description,
                date,
                time,
            });
            return await todo.save();
        } catch (error) {
            throw new Error("Error save todo!!!");
        }
    }

    static async FindByKategori(filter) {
        try {
            const notes = await todoModel.find(filter).sort({ createdAt: -1 });
            console.log("data di temukan");
            return notes;
        } catch (err) {
            console.log(err);
            throw new Error("error pencarian data");
        }
    }

    static async FindByName(filter) {
        try {
            const notes = await todoModel.find(filter).sort({ createdAt: -1 });
            console.log("data di temukan");
            return notes;
        } catch (err) {
            console.log("error pencarian");
            throw new Error("error pencarian");
        }
    }

    static async delateNote(id) {
        try {
            const data = await todoModel.deleteMany({_id : {$in : id}});
            return data;
        } catch (err) {
            console.log("error pencarian");
            throw new Error("error pencarian");
        }
    }

    static async findNote(id) {
        try {
            const note = await todoModel.findById(id);
            return note;
        } catch (err) {
            console.log("error pencarian");
            throw new Error("error pencarian");
        }
    }

    static async findNotes(id) {
        try {
            const note = await todoModel.find({_id : {$in : id}});
            return note;
        } catch (err) {
            console.log("error pencarian");
            throw new Error("error pencarian");
        }
    }

    static async updateNote(id, body) {
        try {
            const note = await todoModel.findByIdAndUpdate(id, body, {
                new: true,
                runValidators: true,
            });
            return note;
        } catch (err) {
            console.log("error pencarian");
            throw new Error("error pencarian");
        }
    }
}

module.exports = TodoService;
