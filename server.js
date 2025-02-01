const express = require('express');
const { server } = require('./backend/utils/config.json');
const app = express();
const homeRouter = require('./backend/routers/home/getHome.js');
const getAppointmentsHomeRouter = require('./backend/routers/appointments/getAppointmentsHome.js');
const getLoginRouter = require('./backend/routers/login/getLoginPage.js');
const getProductsPageRouter = require('./backend/routers/products/getProductsPage.js');
const getProductsProfilePageRouter = require('./backend/routers/products/getProductProfilePage.js');
const getRegisterRouter = require('./backend/routers/register/getRegisterPage.js');
const getUserAppointmentsPageRouter = require('./backend/routers/user/getUserAppointmentsPage.js');
const getUserProfilePageRouter = require('./backend/routers/user/getUserProfilePage.js');

app.use(express.static('frontend'));

// home
app.use('/', homeRouter);
// products
app.use('/', getProductsPageRouter);
app.use('/productos', getProductsProfilePageRouter);

// login
app.use('/', getLoginRouter);

// register
app.use('/', getRegisterRouter);

// appointments
app.use('/', getAppointmentsHomeRouter);

// user
app.use('/', getUserProfilePageRouter);
app.use('/perfil', getUserAppointmentsPageRouter);


app.listen(server.port , () => {
    console.log('server started');
});