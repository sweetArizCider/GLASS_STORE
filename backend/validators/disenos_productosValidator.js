const Joi = require('joi');

class DisenosProductosValidator {
    validateNewDisenoProducto(disenoProductoData) {
        const schema = Joi.object({
            diseno: Joi.number().integer().required(),
            producto: Joi.number().integer().required(),
            estatus: Joi.string().valid('activo', 'inactivo').default('activo').required()
        });
        const {error, value} = schema.validate(disenoProductoData);
        if (error){
            return error;
        }
        return value;
    }
}

module.exports = DisenosProductosValidator;