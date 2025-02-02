const { Model, DataTypes } = require('sequelize');
const MySQL = require('../utils/database.js');
const Cliente = require('./cliente.js');
const Productos = require('./productos.js');

class Favoritos extends Model {}

Favoritos.init({
    id_favorito: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    cliente: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Cliente,
            key: 'id_cliente'
        },
    },
    producto: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Productos,
            key: 'id_producto'
        }
    }
},
{
    sequelize: MySQL.getSequelize,
    tableName: 'favoritos',
    timestamps: false
})

Favoritos.belongsTo(Cliente);
Favoritos.belongsTo(Productos)

module.exports = Favoritos;