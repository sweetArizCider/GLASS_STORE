const Joi = require('joi');

class DisenosValidator {
    validateNewDiseno(disenoData) {
        const schema = Joi.object({
            muestrario: Joi.number().integer().optional(),
            codigo: Joi.string().max(50).required(),
            file_path: Joi.string().max(255).optional(),
            file_name: Joi.string().max(255).optional(),
            upload_date: Joi.date().optional(),
            descripcion: Joi.string().max(255).optional(),
            estatus: Joi.string().valid('activo', 'inactivo').default('activo').optional()
        });
        return schema.validate(disenoData);
    }
}

module.exports = DisenosValidator;