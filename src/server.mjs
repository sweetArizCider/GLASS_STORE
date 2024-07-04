import express from 'express';
import bodyParser from 'body-parser';
import path from 'path';
import { fileURLToPath } from 'url';
import { httpConfig } from './config/httpConfig.mjs';
import registerRoute from './routes/register.mjs';
import loginRoute from './routes/login.mjs';
import indexRoute from './routes/index.mjs';
import productRoute from './routes/productos.mjs';
import appointmentRoute from './routes/citas.mjs';
import homeRoute from './routes/inicio.mjs';

const app = express();

// Middleware to parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));
// Middleware to parse application/json
app.use(bodyParser.json());

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Static routes
app.use(express.static(path.join(__dirname, '../public')));

// Routes
app.use('/', indexRoute);
app.use('/inicio', homeRoute);
app.use('/citas', appointmentRoute);
app.use('/productos', productRoute);
app.use('/register', registerRoute);
app.use('/login', loginRoute);

// Start server
app.listen(httpConfig.port, httpConfig.hostname, () => {
    console.log(`Server running at http://${httpConfig.hostname}:${httpConfig.port}/`);
});

