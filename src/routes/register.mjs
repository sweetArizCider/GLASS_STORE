import express from 'express';
import { register } from '../controllers/validateCreateUser.mjs';

const router = express.Router();

// se ejecutará la función 'register' importada cuando reciba una peticion post de la direccion "/".
router.post('/', register);

// Exporta el router para que pueda ser utilizado por otros módulos
export default router;
