import { httpConfig } from './config/httpConfig.mjs';
import express from 'express';
import registerRoute from './routes/register.mjs';
import bodyParser from 'body-parser';
import path from 'path';
import { fileURLToPath } from 'url';

const app = express();

// Middleware para parsear application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));

// Middleware para parsear application/json
app.use(bodyParser.json());
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
app.use(express.static(path.join(__dirname, 'public')));

// Ruta para el formulario de registro
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '/views/register.html'));
});

// Ruta para el registro de usuarios
app.use('/register', registerRoute);

app.listen(httpConfig.port, httpConfig.hostname, () => {
    console.log(`Server running at http://${httpConfig.hostname}:${httpConfig.port}/`);
});
