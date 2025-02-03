const express = require('express');
const { server } = require('./backend/utils/config.json');
const app = express();
//home
const homeRouter = require('./backend/routers/home/getHome.js');
// appointments
const getAppointmentsHomeRouter = require('./backend/routers/appointments/getAppointmentsHome.js');
const getUserAppointmentsPageRouter = require('./backend/routers/user/getUserAppointmentsPage.js');
// login
const getLoginRouter = require('./backend/routers/login/getLoginPage.js');
// products
const getProductsPageRouter = require('./backend/routers/products/getProductsPage.js');
const getProductsProfilePageRouter = require('./backend/routers/products/getProductProfilePage.js');
// retgitser
const getRegisterRouter = require('./backend/routers/register/getRegisterPage.js');
const RegisterNewUserRouter = require('./backend/routers/register/registerNewUser.js');
// user
const getUserProfilePageRouter = require('./backend/routers/user/getUserProfilePage.js');

app.use(express.static('frontend'));

app.use(express.json());

// home
app.use('/', homeRouter);
// products
app.use('/', getProductsPageRouter);
app.use('/productos', getProductsProfilePageRouter);

// login
app.use('/', getLoginRouter);

// register
app.use('/', getRegisterRouter);
app.use('/', RegisterNewUserRouter);

// appointments
app.use('/', getAppointmentsHomeRouter);

// user
app.use('/', getUserProfilePageRouter);
app.use('/perfil', getUserAppointmentsPageRouter);


app.listen(server.port , () => {
    console.log('server started');
});