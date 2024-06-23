// src/routes/register.mjs

import express from 'express';
import { register } from '../controllers/validateCreateUser.mjs';

const router = express.Router();

router.post('/', register); // Maneja las solicitudes POST a '/register'

export default router;
