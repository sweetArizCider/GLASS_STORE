const {Model, DataTypes} = require('sequelize');
const MySQL = require('../utils/database.js');
const Roles = require('./roles.js');
const Usuarios = require('./usuarios.js');

class Rol_Usuario extends Model {}

Rol_Usuario.init({
    id_rol_usuario: {
        type: DataTypes.INTEGER,
        primaryKey: true, 
        autoIncrement: true,
        allowNull: false
    },
    rol: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Roles,
            key: 'id_rol'
        }
    },
    usuario: {
        type: DataTypes.INTEGER, 
        allowNull: false,
        references: {
            model: Usuarios, 
            key: 'id_usuario'
        }
    },
    estatus: {
        type: DataTypes.ENUM('activo', 'inactivo'),
        defaultValue: 'activo',
        allowNull: false
    }
},
{
    sequelize: MySQL.getSequelize,
    tableName: 'rol_usuario',
    timestamps: false
});

Rol_Usuario.belongsTo(Roles);
Rol_Usuario.belongsTo(Usuarios);

module.exports = Rol_Usuario;

