const Joi = require('joi');

class ImagenValidator {
    validateNewImagen(imagenData) {
        const schema = Joi.object({
            imagen: Joi.string().max(255).required(),
            producto: Joi.number().integer().required()
        });
        const {error, value} = schema.validate(imagenData);
        if (error){
            return error;
        }
        return value;
        
    }
}

module.exports = ImagenValidator;