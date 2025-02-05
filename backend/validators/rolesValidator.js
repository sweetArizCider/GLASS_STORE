const Joi = require('joi');

class RolesValidator {
    validateNewRol(rolData) {
        const schema = Joi.object({
            nombre_rol: Joi.string().max(50).pattern(/^[a-zA-ZÀ-ÿ\s]+$/).required()
        });
        const {error, value} = schema.validate(rolData);
        if (error){
            return error;
        }
        return value;
    }
}

module.exports = RolesValidator;