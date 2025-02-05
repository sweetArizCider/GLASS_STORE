const Joi = require('joi');

class RolUsuarioValidator {
    validateNewRolUsuario(rolUsuarioData) {
        const schema = Joi.object({
            rol: Joi.number().integer().required(),
            usuario: Joi.number().integer().required(),
            estatus: Joi.string().valid('activo', 'inactivo').default('activo').required()
        });
        const {error, value} = schema.validate(rolUsuarioData);
        if (error){
            return error;
        }
        return value;
    }
}

module.exports = RolUsuarioValidator;