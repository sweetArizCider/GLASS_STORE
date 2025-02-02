const {DataTypes, Model} = require('sequelize');
const MySQL = require('../utils/database.js');
const Productos = require('./productos.js');

class Imagen extends Model {}

Imagen.init({
    id_imagen: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    imagen:{
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    producto:{
        type: DataTypes.INTEGER,
        allowNull: false,
        references:{
            model: Productos,
            key: 'id_producto'
        }
    }
},
{
    sequelize: MySQL.getSequelize,
    modelName: 'imagen',
    timestamps: false
})

Imagen.belongsTo(Productos);

module.exports = Imagen;