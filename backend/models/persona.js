const { Model, DataTypes } = require('sequelize');
const MySQL = require('../utils/database.js');
const Usuarios = require('./usuarios.js');

class Persona extends Model {}


Persona.init({
    id_persona: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    usuario: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Usuarios,
            key: 'id_usuario'
        }
    },
    nombres: {
        type: DataTypes.STRING(25),
        allowNull: false
    },
    apellido_p: {
        type: DataTypes.STRING(30),
        allowNull: false
    },
    apellido_m: {
        type: DataTypes.STRING(30),
        allowNull: true
    },
    correo: {
        type: DataTypes.STRING(70),
        allowNull: false,
        unique: true
    },
    telefono: {
        type: DataTypes.CHAR(10),
        allowNull: false,
        unique: true
    }
}, {
    sequelize: MySQL.getSequelize,
    tableName: 'persona',
    timestamps: false
});

Persona.belongsTo(Usuarios , { foreignKey: 'usuario', as: 'usuarioDetails' });

module.exports = Persona;