const {Model, DataTypes} = require('sequelize');
const MySQL = require('../utils/database.js');
const Disenos = require('./disenos.js');
const Productos = require('./productos.js');

class DisenosProductos extends Model{}

DisenosProductos.init({
    id_diseno_producto: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    diseno:{
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Disenos,
            key: 'id_diseno'
        }
    },
    producto: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Productos,
            key: 'id_producto'
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
    tableName: 'disenos_productos',
    timestamps: false
})

DisenosProductos.belongsTo(Disenos);
DisenosProductos.belongsTo(Productos);

module.exports = DisenosProductos;