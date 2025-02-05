const { Model, DataTypes } = require('sequelize');
const MySQL = require('../utils/database.js');
const Persona = require('./persona.js');

class Cliente extends Model {}

Cliente.init({
    id_cliente: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    persona: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Persona,
            key: 'id_persona'
        }
    }
},{
    sequelize: MySQL.getSequelize,
    tableName: 'cliente',
    timestamps: false
});

Cliente.belongsTo(Persona , { foreignKey: 'persona', as: 'personaDetails' });

module.exports = Cliente;