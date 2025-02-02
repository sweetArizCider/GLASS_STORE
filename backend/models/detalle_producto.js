const {Model, DataTypes} = require('sequelize');
const MySQL = require('../utils/database.js');
const Productos = require('./productos.js');
const Disenos = require('./disenos.js');
const Cliente = require('./cliente.js');

class DetalleProducto extends Model{}

DetalleProducto.init({
    id_detalle_producto: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    producto: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: Productos,
            key: 'id_producto'
        }
    },
    cliente: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Cliente,
            key: 'id_cliente'
        }
    },
    estatus: {
        type: DataTypes.ENUM('acentada', 'rechazada', 'en espera', 'en carrito', 'desactivada'),
        defaultValue: 'en espera',
        allowNull: true
    },
    alto: {
        type: DataTypes.DECIMAL(10,2),
        allowNull: false
    },
    largo: {
        type: DataTypes.DECIMAL(10,2),
        allowNull: false
    },
    cantidad: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    monto: {
        type: DataTypes.DECIMAL(10,2),
        allowNull: true
    },
    grosor: {
        type: DataTypes.ENUM('6', '10', '12'),
        allowNull: true,
    },
    tipo_tela:{
        type: DataTypes.STRING(50),
        allowNull: true
    },
    marco: {
        type: DataTypes.STRING(50),
        allowNull: true
    },
    tipo_cadena:{
        type: DataTypes.STRING(50),
        allowNull: true
    },
    color: {
        type: DataTypes.STRING(50),
        allowNull: true
    },
    diseno: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: Disenos,
            key: 'id_diseno'
        }
    },
    invitado_id:{
        type: DataTypes.STRING(255),
        allowNull: true
    }
},
{
    sequelize: MySQL.getSequelize,
    tableName: 'detalle_producto',
    timestamps: false
});

DetalleProducto.belongsTo(Productos);
DetalleProducto.belongsTo(Cliente);
DetalleProducto.belongsTo(Disenos);

module.exports = DetalleProducto;
