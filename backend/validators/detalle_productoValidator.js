const Joi = require('joi');

class DetalleProductoValidator {
    validateNewDetalleProducto(detalleProductoData) {
        const schema = Joi.object({
            producto: Joi.number().integer().required(),
            cliente: Joi.number().integer().optional(),
            estatus: Joi.string().valid('aceptada', 'rechazada', 'en espera', 'en carrito', 'desactivada').default('en espera').optional(),
            alto: Joi.number().precision(2).required(),
            largo: Joi.number().precision(2).required(),
            cantidad: Joi.number().integer().required(),
            monto: Joi.number().precision(2).optional(),
            grosor: Joi.string().valid('6', '10', '12').optional(),
            tipo_tela: Joi.string().max(50).optional(),
            marco: Joi.string().max(50).optional(),
            tipo_cadena: Joi.string().max(50).optional(),
            color: Joi.string().max(10).optional(),
            diseno: Joi.number().integer().optional(),
            invitado_id: Joi.string().max(255).optional()
        });
        const {error, value} =  schema.validate(detalleProductoData);
        if (error){
            return error;
        }
        return value;

    }
}

module.exports = DetalleProductoValidator;