const express = require('express');
const { server } = require('./backend/utils/config.json');
const app = express();

//home
const homeRouter = require('./backend/routers/home/getHome.js');
// appointments
const getAppointmentsHomeRouter = require('./backend/routers/appointments/getAppointmentsHome.js');
const getUserAppointmentsPageRouter = require('./backend/routers/user/getUserAppointmentsPage.js');
// login
const getLoginRouter = require('./backend/routers/login/loginRouter.js');
// products
const productsRouter = require('./backend/routers/products/productsRouter.js');
const favoritesRouter = require('./backend/routers/clients/favoritesRouter.js');
// retgitser
const registerRouter = require('./backend/routers/register/registerRouter.js');
// user
const getUserProfilePageRouter = require('./backend/routers/user/getUserProfilePage.js');

app.use(express.static('frontend'));

app.use(express.json());

// home
app.use('/', homeRouter);

// products
app.use('/', productsRouter);
app.use('/', favoritesRouter);

// login
app.use('/', getLoginRouter);

// register
app.use('/', registerRouter);

// appointments
app.use('/', getAppointmentsHomeRouter);

// user
app.use('/', getUserProfilePageRouter);
app.use('/perfil', getUserAppointmentsPageRouter);


app.listen(server.port , () => {
    console.log('server started');
});