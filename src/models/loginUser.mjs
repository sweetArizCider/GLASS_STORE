import { pool } from "../config/mysqlConfig.mjs";

export const logearUsuario = async (correo, contraseña) => {
  const connection = await pool.getConnection();

  try {
    const [rows] = await connection.query(`CALL AuthenticateUser1(?, ?)`, [correo, contraseña]);

    if (rows[0].length > 0 && rows[0][0].mensaje === 'Autenticación exitosa') {
      return rows[0][0];
    } else {
      return null;
    }
  } catch (error) {
    console.error('Error en el inicio de sesión', error);
    return null;
  } finally {
    connection.release();
  }
}
