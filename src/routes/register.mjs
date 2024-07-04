import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import { register } from '../controllers/validateCreateUser.mjs';

const router = express.Router();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Handle GET request to /register
router.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../../public/html/register.html'));
});

// Handle POST request to /register
router.post('/', register);

export default router;
