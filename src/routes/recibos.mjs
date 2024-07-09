import express from 'express';
import { getRecibos, getRecibosPorNombre, getRecibosPorFecha } from '../controllers/validateRecibos.mjs';

const router = express.Router();

router.get('/', getRecibos);
router.post('/nombre', getRecibosPorNombre);
router.post('/fecha', getRecibosPorFecha);

export default router;





