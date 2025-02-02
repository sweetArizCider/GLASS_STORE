const {DataTypes, Model} = require('sequelize');
const MySQL = require('../utils/database.js');

class Categorias extends Model {}

Categorias.init({
    id_categoria:{
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    nombre:{
        type: DataTypes.STRING(100),
        allowNull: false
    }
},
{
    sequelize: MySQL.getSequelize,
    modelName: 'categorias',
    timestamps: false
});

module.exports = Categorias;