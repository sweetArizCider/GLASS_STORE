import { connect } from "./config/mysqlConfig.mjs";
import { httpConfig } from './config/httpConfig.mjs';
import express from 'express';

const app = express();

app.get('/', (req, res) => {
    res.send('Hello World!');
});

app.listen(httpConfig.port, httpConfig.hostname, () => {
    console.log(`Server running at http://${httpConfig.hostname}:${httpConfig.port}/`);
});

connect();