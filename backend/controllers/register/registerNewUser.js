const MySQL = require('../../utils/database');
const sequelize = MySQL.getSequelize;
const Usuarios = require('../../models/usuarios'); 
const Persona = require('../../models/persona');
const Cliente = require('../../models/cliente');
const UsuariosValidator = require('../../validators/usuariosValidator'); 
const PersonaValidator = require('../../validators/personaValidator');
const Rol_Usuario = require('../../models/rol_usuario');
const bcrypt = require('bcrypt');

class Register {
    async registerNewUser(userData) {
        // store the data from the userData
        const nomUsuario = userData.nom_usuario;
        const contrasena = userData.contrasena;
        const nombres = userData.nombres;
        const apellidoP = userData.apellido_p;
        const apellidoM = userData.apellido_m;
        const correo = userData.correo;
        const telefono = userData.telefono;


        const transaction = await sequelize.transaction();

        // verify the data
        const usuarioValidator = new UsuariosValidator();
        const usuarioResult = usuarioValidator.validateNewUsuario({ nom_usuario: nomUsuario,contrasena: contrasena });
        
        if (usuarioResult.error) {
            await transaction.rollback();
            return { error: usuarioResult.error };
        }

        // verify if the user already exists
        const usuarioExists = await Usuarios.findOne({ where: { nom_usuario: nomUsuario } });
        if (usuarioExists) {
            await transaction.rollback();
            return { error: 'El usuario ya existe' };
        }

        // hash the password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(contrasena, salt);

        // create a new usuario
        const newUsuario = await Usuarios.create({ nom_usuario: nomUsuario, contrasena: hashedPassword }, { transaction });
        
        // create a default rol for the new usuario
        const newRolUsuario = await Rol_Usuario.create({ usuario: newUsuario.id_usuario, rol: 1 }, { transaction });
        // get the id of the new usuario
        const usuarioId = newUsuario.id_usuario;

        // verify the data for Persona and create a new persona
        const personaValidator = new PersonaValidator();
        const personaResult = personaValidator.validateNewPersona({usuario: usuarioId, nombres: nombres, apellido_p: apellidoP, apellido_m: apellidoM,correo: correo, telefono: telefono });
        if (personaResult.error) {
            await transaction.rollback();
            return { error: personaResult.error };
        }

        // create a new persona
        const newPersona = await Persona.create({ usuario: usuarioId,nombres: nombres,apellido_p: apellidoP, apellido_m: apellidoM,correo: correo,telefono: telefono }, { transaction });

        // get the id of the new persona
        const personaId = newPersona.id_persona;

        // create a new cliente
        const newCliente = await Cliente.create({ persona: personaId }, { transaction });

        await transaction.commit();
        return {newCliente};
    }
}

module.exports = Register;
