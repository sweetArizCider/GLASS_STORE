const Usuarios = require('../../models/usuarios');
const bcrypt = require('bcrypt');
const UsuariosValidator = require('../../validators/usuariosValidator');
const Persona = require('../../models/persona');
const Rol_Usuario = require('../../models/rol_usuario')


class Login{
    constructor(userData){
        this.nomUsuario = userData.nom_usuario;
        this.contrasena = userData.contrasena;
    }
    async loginUser(){
        try{
            // check if the data is empty
            if(!this.nomUsuario || !this.contrasena){
                return {error: 'Datos incompletos'};
            }
            // validate the data 
            const userValidator = new UsuariosValidator();
            const userResult = userValidator.validateNewUsuario({nom_usuario: this.nomUsuario, contrasena: this.contrasena});
            if(userResult.error){
                return {error: userResult.error};
            }
            // check if the user exists
            const userExists = await Usuarios.findOne({where: {nom_usuario: this.nomUsuario}});
            if(!userExists){
                return {error: 'El usuario no existe'};
            }
            // check user type
            const userRol = await Rol_Usuario.findOne({where: {usuario: userExists.id_usuario}});
            if(!userRol){
                return {error: 'El usuario no tiene un rol asignado'};
            }
            // check if the password is correct
            const passMatch = await bcrypt.compare(this.contrasena, userExists.contrasena);
            if(!passMatch){
                return {error: 'La contraseña es incorrecta'};
            }
            // check if the user is active
            if(userExists.estatus === 'inactivo'){
                return {error: 'El usuario esta inactivo'};
            }
            // Find the user personal data
            const personalData = await Persona.findOne({where: {usuario: userExists.id_usuario}});
            if(!personalData){
                return {error: 'No se encontro la informacion personal del usuario'};
            }
            // return the user, the rol and the personal data
            return {user: userExists.nom_usuario, rol: userRol, personalData: personalData};
        }catch(error){
            return {error: error.message};
        }
        
    }
}

module.exports = Login;

