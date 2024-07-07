import { pool } from '../config/mysqlConfig.mjs';

export const obtenerRecibos = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.query('SELECT * FROM vista_recibos');
        return rows;
    } catch (error) {
        console.error('Error al obtener los recibos:', error);
        throw error;
    } finally {
        connection.release();
    }
};

export const obtenerRecibosPorNombre = async (nombre_completo) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.query('CALL consultar_recibos_por_usuario(?)', [nombre_completo]);
        return rows;
    } catch (error) {
        console.error('Error al obtener los recibos por nombre:', error);
        throw error;
    } finally {
        connection.release();
    }
};

export const obtenerRecibosPorFecha = async (fecha_inicio, fecha_fin) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.query('CALL consultar_recibos_por_fecha(?, ?)', [fecha_inicio, fecha_fin]);
        return rows;
    } catch (error) {
        console.error('Error al obtener los recibos por fecha:', error);
        throw error;
    } finally {
        connection.release();
    }
};


