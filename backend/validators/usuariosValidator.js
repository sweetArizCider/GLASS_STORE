const Joi = require('joi');

class UsuariosValidator {
    validateNewUsuario(usuarioData) {
        const schema = Joi.object({
            nom_usuario: Joi.string().pattern(/^[a-zA-Z0-9]+$/).max(70).required(),
            contrasena: Joi.string().min(6).pattern(/^(?=.*[!@#$%^&*(),.?":{}|<>]).+$/).max(64).required(),
            estatus: Joi.string().valid('activo', 'inactivo').default('activo').required()
        });
        return schema.validate(usuarioData);
    }
}

module.exports = UsuariosValidator;