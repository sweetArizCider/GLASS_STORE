const PersonaValidator = require('../validators/personaValidator.js');
const personaValidator = new PersonaValidator();

// Test 1: validateNewPersona
const personaData = {
    usuario: 1,
    nombres: 'Juan',
    apellido_p: 'Perez',
    apellido_m: 'Lopez',
    correo: 'juan@fff.com',
    telefono: '2345678901'}

const validatorOutput = personaValidator.validateNewPersona(personaData);

console.log(validatorOutput);

