const express = require('express');
const router = express.Router();
const path = require('node:path');

router.get('/', async (req, res) => {
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'home.html' );
    res.sendFile(pathFile);
});

module.exports = router;