const express = require('express');
const router = express.Router();
const path = require('node:path');
const Login = require('../../controllers/login/loginUser');

router.get('/login', async (req, res) => {
    // send the login page
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'views', 'login', 'login.html' );
    res.sendFile(pathFile);
});

router.post('/login', async (req, res) =>{
    // get the data from the user
    const userData = req.body;
    const login = new Login(userData);
    // login the user and save its data

        const user = await login.loginUser();
        if(user.error){
            return res.status(400).json({error: 'Authentication Error'});
        }
        // send the user data
        return res.status(200).json({userAuthenticated: user});
})



module.exports = router;