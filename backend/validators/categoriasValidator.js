const Joi = require('joi');

class CategoriasValidator {
    validateNewCategoria(categoriaData) {
        const schema = Joi.object({
            nombre: Joi.string().max(100).pattern(/^[a-zA-ZÀ-ÿ\s]+$/).required()
        });
        const { error, value } = schema.validate(categoriaData);
        if (error) {
            return error;
        }
        return value;
    }
}

module.exports = CategoriasValidator;