import { pool } from "../config/mysqlConfig.mjs";

export const mostrar_recibos = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        connection.query('SELECT * FROM vista_recibos', (err, results) => {
            if (err) {
                console.error('Error en la consulta de recibos:', err);
                res.status(500).json({ error: 'Error interno del servidor' });
                return;
            }
            res.json(results);
        });
    } catch (error) {
        console.error('Error en mostrar_recibos:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    } finally {
        connection.release();
    }
};

export const by_name = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        const { nombre_completo } = req.body;
        connection.query('CALL consultar_recibos_por_usuario(?)', [nombre_completo], (err, results) => {
            if (err) {
                console.error('Error en la consulta de recibos por nombre:', err);
                res.status(500).json({ error: 'Error interno del servidor' });
                return;
            }
            res.json(results[0]);
        });
    } catch (error) {
        console.error('Error en by_name:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    } finally {
        connection.release();
    }
};

export const by_date = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        const { fecha_inicio, fecha_fin } = req.body;
        connection.query('CALL consultar_recibos_por_fecha(?, ?)', [fecha_inicio, fecha_fin], (err, results) => {
            if (err) {
                console.error('Error en la consulta de recibos por fecha:', err);
                res.status(500).json({ error: 'Error interno del servidor' });
                return;
            }
            res.json(results[0]);
        });
    } catch (error) {
        console.error('Error en by_date:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    } finally {
        connection.release();
    }
};
