import express from 'express';
import { mostrarRecibos, buscarRecibosPorNombre, buscarRecibosPorFecha } from '../controllers/validateRecibos.mjs';

const router = express.Router();

// Ruta para mostrar todos los recibos
router.get('/recibos', mostrarRecibos);

// Ruta para buscar recibos por nombre
router.post('/recibos/nombre', buscarRecibosPorNombre);

// Ruta para buscar recibos por fecha
router.post('/recibos/fecha', buscarRecibosPorFecha);

export default router;
