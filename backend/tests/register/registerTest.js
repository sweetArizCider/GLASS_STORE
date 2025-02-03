const Register = require('../../controllers/register/registerNewUser.js');

const register = new Register();

async function testRegisterNewUser() {
    const userData = {
        "nom_usuario": "exampleUser4",
        "contrasena": "example!123",
        "nombres": "Juan",
        "apellido_p": "Perez",
        "apellido_m": "Lopez",
        "correo": "juan.p3erez@example.com",
        "telefono": "4321756836"
    };

    try {
        const newUser = await register.registerNewUser(userData);
        console.log('result:', newUser);
    } catch (error) {
        console.log("Test failed");
        console.log(error);
    }
}

testRegisterNewUser();
