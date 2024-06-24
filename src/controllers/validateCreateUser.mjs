import { crearUsuario } from '../models/createUser.mjs';


// funcion para crear un usuario
export const register = async (req, res) => {

    // traer datos del form
    const { nombres, apellido_p, apellido_m, correo, telefono, contraseña } = req.body;

    // Validación de campos requeridos
    if (!nombres || !apellido_p || !apellido_m || !contraseña || !correo) {
        return res.status(400).send('Ingresa todos los datos correspondientes');
    }


    // correr la funcion que contiene el query para insersion a la base de datos
    try {
        await crearUsuario(nombres, apellido_p, apellido_m, correo, telefono, contraseña);
        res.status(201).send('Usuario registrado correctamente');
    } catch (error) {
        console.error('Error en register:', error);
        res.status(500).send('Error al crear nuevo usuario');
    }
}
