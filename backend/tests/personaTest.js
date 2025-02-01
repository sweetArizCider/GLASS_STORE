const Persona = require('../models/persona.js');

async function createPerson(){
    const newPerson = await Persona.create({
        usuario: 1,
        nombres: 'Juan',
        apellido_p: 'Perez',
        apellido_m: 'Lopez',
        correo: 'juan@gmailcom',
        telefono: '1234567890'});
        
        console.log(newPerson);
}

createPerson();