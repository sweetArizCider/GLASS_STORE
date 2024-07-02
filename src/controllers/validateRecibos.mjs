import { mostrar_recibos, by_name, by_date } from "../models/mostrarRecibo.mjs";

// Función para mostrar todos los recibos
export const mostrarRecibos = async (req, res) => {
    try {
        const recibos = await mostrar_recibos(req, res);
        res.json(recibos);
    } catch (error) {
        console.error('Error en mostrarRecibos:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
};

// Función para buscar recibos por nombre
export const buscarRecibosPorNombre = async (req, res) => {
    try {
        const recibos = await by_name(req, res);
        res.json(recibos);
    } catch (error) {
        console.error('Error en buscarRecibosPorNombre:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
};

// Función para buscar recibos por fecha
export const buscarRecibosPorFecha = async (req, res) => {
    try {
        const recibos = await by_date(req, res);
        res.json(recibos);
    } catch (error) {
        console.error('Error en buscarRecibosPorFecha:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
};


