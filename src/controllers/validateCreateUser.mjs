// src/controllers/validateCreateUser.mjs

import { crearUsuario } from '../models/createUser.mjs';

export const register = async (req, res) => {
    const { nombres, apellido_p, apellido_m, correo, telefono, contraseña } = req.body;

    // Validación de campos requeridos
    if (!nombres || !apellido_p || !apellido_m || !contraseña || !correo) {
        return res.status(400).send('Ingresa todos los datos correspondientes');
    }

    try {
        await crearUsuario(nombres, apellido_p, apellido_m, correo, telefono, contraseña);
        res.status(201).send('Usuario registrado correctamente');
    } catch (error) {
        console.error('Error en register:', error);
        res.status(500).send('Error al crear nuevo usuario');
    }
}
