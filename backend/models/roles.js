const {Model, DataTypes} = require('sequelize');
const MySQL = require('../utils/database.js');

class Roles extends Model {}

Roles.init({
    id_rol: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    nombre_rol: {
        type: DataTypes.STRING(50),
        allowNull: false,
        unique: true
    }
}, {
    sequelize: MySQL.getSequelize,
    tableName: 'roles',
    timestamps: false
})

module.exports = Roles;