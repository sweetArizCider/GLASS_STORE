// uso de una pool de la base de datos
import { pool } from "../config/mysqlConfig.mjs";

// creando una funcion para exportar, la cual tiene el query necesario para ingresar el nuevo usuario a la base de datos

export const crearUsuario = async (nombres, apellido_p, apellido_m, correo, telefono, contraseña) => {
    const connection = await pool.getConnection();
    
    try {
        // Insertar en la tabla PERSONA
        const queryPersona = 'INSERT INTO PERSONA (nombres, apellido_p, apellido_m, correo, telefono) VALUES (?, ?, ?, ?, ?)';
        const [personaResult] = await connection.execute(queryPersona, [nombres, apellido_p, apellido_m, correo, telefono]);

        // Obtener el id_persona generado automaticamente
        const id_persona = personaResult.insertId;

        // Insertar en la tabla USUARIOS
        const queryUsuario = 'INSERT INTO USUARIOS (id_persona, usuario, contrasena, id_rol) VALUES (?, ?, ?, 5)';
        await connection.execute(queryUsuario, [id_persona, correo, contraseña]);

        console.log('Usuario y Persona registrados correctamente');
        
    } catch (error) {
        console.error('Error en crearUsuario:', error);
        throw error;
    } finally {
        connection.release(); 
    }
}


