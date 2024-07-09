// uso de la pool de la bd

import { pool } from "../config/mysqlConfig.mjs";

// Creando una funcion para exportar, la cuan tiene el query necesario para logear al usuario

export const logearUsuario = async (correo, contraseña) => {
  // importando la pool de bd
  const connection = await pool.getConnection();

  // declaro un vector llamado rows, el cual se llenara de usuarios que cumplan con ese correo y contraseña
  try {
    const [rows] = await connection.query(`SELECT * FROM USUARIOS u WHERE u.usuario = ? AND u.contrasena = ?`,[correo, contraseña]);

    // si la longitud del vector es mayor a 0, devuelve el primer usuario del vector
    if(rows.length > 0) {
      return rows[0];

    } else {return null}; // devuelve nulo si es < a 0
  }catch(error){
    console.error('Error en el inicio de sesion', error); // en caso de error lanzar error en consola
  }finally {
    connection.release(); // termina la coneccion de bd
  }
}