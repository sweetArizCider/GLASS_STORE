const Joi = require('joi');

class ProductosValidator {
    validateNewProducto(productoData) {
        const schema = Joi.object({
            categoria: Joi.number().integer().required(),
            nombre: Joi.string().max(200).required(),
            descripcion: Joi.string().required(),
            precio: Joi.number().precision(2).required(),
            estatus: Joi.string().valid('activo', 'inactivo').default('activo').optional()
        });
        return schema.validate(productoData);
    }
}

module.exports = ProductosValidator;