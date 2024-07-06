import { obtenerRecibos, obtenerRecibosPorNombre, obtenerRecibosPorFecha } from '../models/mostrarRecibo.mjs';

export const getRecibos = async (req, res) => {
    try {
        const recibos = await obtenerRecibos();
        res.json(recibos);
    } catch (error) {
        console.error('Error al obtener los recibos:', error);
        res.status(500).send('Error al obtener los recibos');
    }
};

export const getRecibosPorNombre = async (req, res) => {
    const { nombre_completo } = req.body;
    try {
        const recibos = await obtenerRecibosPorNombre(nombre_completo);
        res.json(recibos);
    } catch (error) {
        console.error('Error al obtener los recibos por nombre:', error);
        res.status(500).send('Error al obtener los recibos por nombre');
    }
};

export const getRecibosPorFecha = async (req, res) => {
    const { fecha_inicio, fecha_fin } = req.body;
    try {
        const recibos = await obtenerRecibosPorFecha(fecha_inicio, fecha_fin);
        res.json(recibos);
    } catch (error) {
        console.error('Error al obtener los recibos por fecha:', error);
        res.status(500).send('Error al obtener los recibos por fecha');
    }
};




