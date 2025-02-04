const express = require('express');
const router = express.Router();
const path = require('node:path');
const RegisterNewUser = require('../../controllers/register/registerNewUser.js');

router.get('/registrarse', async (req, res) => {
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'views', 'register', 'register.html' );
    res.sendFile(pathFile);
});

router.post('/registrarse', async (req, res) => {
    const userData = req.body;
    const register = new RegisterNewUser();
    try {
        const newUser = await register.registerNewUser(userData);
        res.status(200).json({ cliente: newUser }); 
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error', details: error.message });
    }
});

module.exports = router;