const Joi = require('joi');

class RolesValidator {
    validateNewRol(rolData) {
        const schema = Joi.object({
            nombre_rol: Joi.string().max(50).pattern(/^[a-zA-ZÀ-ÿ\s]+$/).required()
        });
        return schema.validate(rolData);
    }
}

module.exports = RolesValidator;