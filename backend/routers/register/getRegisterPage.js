const express = require('express');
const router = express.Router();
const path = require('node:path');

router.get('/registrarse', async (req, res) => {
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'views', 'register', 'register.html' );
    res.sendFile(pathFile);
});

module.exports = router;