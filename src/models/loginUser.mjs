// uso de la pool de la bd

import { pool } from "../config/mysqlConfig.mjs";

// Creando una funcion para exportar, la cuan tiene el query necesario para logear al usuario

export const logearUsuario = async (correo, contraseña) => {
  const connection = await pool.getConnection();

  try {
    const query = `SELECT * FROM USUARIOS u WHERE u.usuario = ? AND u.contrasena = ?`
  }catch(error){
    console.error('Error en el inicio de sesion', error);
  }finally {
    connection.release();
  }
}