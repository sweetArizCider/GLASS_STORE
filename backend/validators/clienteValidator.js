const Joi = require('joi');

class ClienteValidator {
    validateNewCliente(clienteData) {
        const schema = Joi.object({
            persona: Joi.number().integer().required()
        });
        const {error, value} = schema.validate(clienteData);
        if (error){
            return error;
        }
        return value;
    }
}

module.exports = ClienteValidator;