const Joi = require('joi');

class DisenosProductosValidator {
    validateNewDisenoProducto(disenoProductoData) {
        const schema = Joi.object({
            diseno: Joi.number().integer().required(),
            producto: Joi.number().integer().required(),
            estatus: Joi.string().valid('activo', 'inactivo').default('activo').required()
        });
        return schema.validate(disenoProductoData);
    }
}

module.exports = DisenosProductosValidator;