const Joi = require('joi');

class RolUsuarioValidator {
    validateNewRolUsuario(rolUsuarioData) {
        const schema = Joi.object({
            rol: Joi.number().integer().required(),
            usuario: Joi.number().integer().required(),
            estatus: Joi.string().valid('activo', 'inactivo').default('activo').required()
        });
        return schema.validate(rolUsuarioData);
    }
}

module.exports = RolUsuarioValidator;