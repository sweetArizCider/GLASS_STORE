import express from 'express';
import { login } from '../controllers/validateLoginUser.mjs';

const router = express.Router();

router.post('/', login);

export default router;
