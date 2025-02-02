const Joi = require('joi');

class CategoriasValidator {
    validateNewCategoria(categoriaData) {
        const schema = Joi.object({
            nombre: Joi.string().max(100).pattern(/^[a-zA-ZÀ-ÿ\s]+$/).required()
        });
        return schema.validate(categoriaData);
    }
}

module.exports = CategoriasValidator;