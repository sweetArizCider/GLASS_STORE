const express = require('express');
const router = express.Router();
const path = require('node:path');

router.get('/productos', async (req, res) => {
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'views', 'products', 'products.html' );
    res.sendFile(pathFile);
});

module.exports = router;