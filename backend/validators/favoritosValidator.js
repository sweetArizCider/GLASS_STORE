const Joi = require('joi');

class FavoritosValidator {
    validateNewFavorito(favoritoData) {
        const schema = Joi.object({
            cliente: Joi.number().integer().required(),
            producto: Joi.number().integer().required()
        });
        return schema.validate(favoritoData);
    }
}

module.exports = FavoritosValidator;