const express = require('express');
const router = express.Router();
const path = require('node:path');

router.get('/login', async (req, res) => {
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'views', 'login', 'login.html' );
    res.sendFile(pathFile);
});

module.exports = router;