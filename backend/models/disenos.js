const {Model, DataTypes} = require('sequelize');
const MySQL = require('../utils/database.js');
const Productos = require('./productos.js');

class Disenos extends Model{}

Disenos.init({
    id_diseno: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    muestrario: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: Productos,
            key: 'id_producto'
        }
    },
    codigo:{
        type: DataTypes.STRING(50),
        allowNull: false,
    },
    file_path: {
        type: DataTypes.STRING(255),
        allowNull: true
    },
    file_name: {
        type: DataTypes.STRING(255),
        allowNull: true
    },
    upload_date:{
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: DataTypes.NOW
    },
    descripcion: {
        type: DataTypes.STRING(255),
        allowNull: true
    },
    estatus: {
        type: DataTypes.ENUM('activo', 'inactivo'),
        defaultValue: 'activo',
        allowNull: true
    }

},
{
    sequelize: MySQL.getSequelize,
    tableName: 'disenos',
    timestamps: false
});

Disenos.belongsTo(Productos);

module.exports = Disenos;