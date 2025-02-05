const Joi = require('joi');

class FavoritosValidator {
    validateNewFavorito(favoritoData) {
        const schema = Joi.object({
            cliente: Joi.number().integer().required(),
            producto: Joi.number().integer().required()
        });
        const {error , value } =  schema.validate(favoritoData);
        if (error){
            return error;
        }
        return value;
    }
}

module.exports = FavoritosValidator;