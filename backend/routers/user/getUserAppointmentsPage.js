const express = require('express');
const router = express.Router();
const path = require('node:path');

router.get('/citas', async (req, res) => {
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'views', 'user', 'userAppointmentsPage.html' );
    res.sendFile(pathFile);
});

module.exports = router;