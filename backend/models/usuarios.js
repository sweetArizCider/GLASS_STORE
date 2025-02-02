const { DataTypes, Model } = require('sequelize');
const MySQL = require('../utils/database.js');

class Usuarios extends Model {}

Usuarios.init({
    id_usuario:{
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    nom_usuario:{
        type: DataTypes.STRING(70),
        allowNull: false,
        unique: true
    },
    contrasena:{
        type: DataTypes.STRING(64),
        allowNull: false
    },
    estatus:{
        type: DataTypes.ENUM('activo', 'inactivo'),
        allowNull: false,
        defaultValue: 'activo'
    }
},
{
    sequelize: MySQL.getSequelize,
    modelName: 'usuarios',
    timestamps: false
});

module.exports = Usuarios;
