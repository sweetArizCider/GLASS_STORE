const Joi = require('joi');

class ClienteValidator {
    validateNewCliente(clienteData) {
        const schema = Joi.object({
            persona: Joi.number().integer().required()
        });
        return schema.validate(clienteData);
    }
}

module.exports = ClienteValidator;