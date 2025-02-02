const {Model, DataTypes } = require('sequelize');
const MySQL = require('../utils/database.js');
const Categorias = require('./categorias.js');

class Productos extends Model{}

Productos.init({
    id_producto: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    categoria: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Categorias,
            key: 'id_categoria'
        }
    },
    nombre:{
        type: DataTypes.STRING(200),
        allowNull: false,
    },
    descripcion: {
        type: DataTypes.TEXT,
        allowNull: false
    },
    precio:{
        type: DataTypes.DECIMAL(10,2),
        allowNull: false
    },
    estatus: {
        type: DataTypes.ENUM('activo', 'inactivo'),
        defaultValue: 'activo',
        allowNull: false
    }
},
{
    sequelize: MySQL.getSequelize,
    tableName: 'producto',
    timestamps: false
});

Productos.belongsTo(Categorias);

module.exports = Productos;