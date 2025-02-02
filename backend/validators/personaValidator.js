const Joi = require('joi');

class PersonaValidator {
    validateNewPersona(personaData) {
        const schema = Joi.object({
            usuario: Joi.number().integer().required(),
            nombres: Joi.string().pattern(/^[a-zA-ZÀ-ÿ\s]+$/).max(25).required(),
            apellido_p: Joi.string().pattern(/^[a-zA-ZÀ-ÿ\s]+$/).max(30).required(),
            apellido_m: Joi.string().pattern(/^[a-zA-ZÀ-ÿ\s]+$/).max(30).optional(),
            correo: Joi.string().email().max(70).required(),
            telefono: Joi.string().length(10).required()
        });
        return schema.validate(personaData);
    }
}

module.exports = PersonaValidator;