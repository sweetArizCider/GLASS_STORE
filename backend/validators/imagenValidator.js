const Joi = require('joi');

class ImagenValidator {
    validateNewImagen(imagenData) {
        const schema = Joi.object({
            imagen: Joi.string().max(255).required(),
            producto: Joi.number().integer().required()
        });
        return schema.validate(imagenData);
    }
}

module.exports = ImagenValidator;