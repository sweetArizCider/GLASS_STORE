const { Sequelize, DataTypes } = require('sequelize');
const MySQL = require('../utils/database.js');

const sequelize = MySQL.getSequelize;

const Persona = sequelize.define('Persona', {
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
            model: 'usuarios',
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
    sequelize: sequelize,
    tableName: 'persona',
    timestamps: false
});

module.exports = Persona;