const app = require('./app');
const connectDB = require('./config/db');

const port = 3000
connectDB();
app.get('/', (req, res) => res.send(200))
app.listen(port, () => console.log(`Example app listening on  http://localhost:${port}!`))