const mongoose = require("mongoose");

  const connectDB = async () => {
  try {
    await mongoose.connect(
      "mongodb://adrielsihombing8_db_user:admin123@ac-6npzbnm-shard-00-00.eqxbsqa.mongodb.net:27017,ac-6npzbnm-shard-00-01.eqxbsqa.mongodb.net:27017,ac-6npzbnm-shard-00-02.eqxbsqa.mongodb.net:27017/DataOfUser?ssl=true&replicaSet=atlas-7lxbqk-shard-0&authSource=admin&appName=Cluster1",
    );
    console.log("MongoDB connected...");
  } catch (err) {
    console.log("MongoDB connection error:", err);
    process.exit(1);
  }
};
module.exports = connectDB;
