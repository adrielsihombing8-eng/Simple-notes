const todoModel = require('../model/todo.model');

class TodoService {
    static async createTodo(userId, {title, pref, description, date, time}) {
        try{
            const todo = new todoModel({userId,title,pref,description,date,time});
            return await todo.save();
        }
        catch (error) {
            throw new Error('Error save todo!!!');
        }
    }

    static async FindByKategori(filter){
        try{
            const notes = await todoModel.find(filter).sort({ createdAt: -1 });
            console.log("data di temukan");
            return notes;
        }
        catch(err){
            console.log(err)
            throw new Error('error pencarian data');
        }
    }
    
    static async FindByName(filter){
        try{
            const notes = await todoModel.find(filter).sort({ createdAt : -1});
            console.log("data di temukan");
            return notes;
        }
        catch(err){
            console.log("error pencarian");
            throw new Error('error pencarian');
        }
    }
}

module.exports = TodoService;