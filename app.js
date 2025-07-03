const express = require('express');
const app = express();
const engine = require('ejs-mate'); 
const path = require('path');


app.engine('ejs', engine);
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));


app.use('/bootstrap', express.static(path.join(__dirname, 'node_modules/bootstrap/dist')));


const reporteRoutes = require('./routes/reporteRoutes');
app.use('/reporte', reporteRoutes);


app.get('/', (req, res) => {
    res.render('index'); 
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`El servidor está corriendo en http://localhost:${PORT}`);
});

