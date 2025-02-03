const express = require('express');
const router = express.Router();
const Register = require('../../controllers/register/registerNewUser.js');

router.post('/registrarse', async (req, res) => {
    const userData = req.body;
    const register = new Register();
    try {
        const newUser = await register.registerNewUser(userData);
        res.status(200).json({ cliente: newUser }); 
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error', details: error.message });
    }
});

module.exports = router;