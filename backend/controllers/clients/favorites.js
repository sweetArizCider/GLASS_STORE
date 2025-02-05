const Favoritos = require('../../models/favoritos');
const Productos = require('../../models/productos');
const Usuarios = require('../../models/usuarios');
const Cliente = require('../../models/cliente');
const Persona = require('../../models/persona')
const FavoritosValidator = require('../../validators/favoritosValidator');
const MySQL = require('../../utils/database');
const sequelize = MySQL.getSequelize;

class Favorites {
    // get all the favorites of a client
    async getFavorites(clientId){
        // get all the favorites of a client
        const favorites = await Favoritos.findAll({where: {cliente: clientId}});
        if(!favorites){
            return {error: 'No se encontraron favoritos'};
        }
        // get the products of the favorites
        for (let i = 0; i < favorites.length; i++){
            const product = await Productos.findOne({where: {id_producto: favorites[i].producto}});
            if (!product){
                return {error: 'Producto no encontrado'};
            }
            favorites[i].producto = {
                productName: product.nombre,
                productId: product.id_producto
            }
        }

        // get the person of the client
        const client = await Cliente.findOne({where: {id_cliente: clientId}});
        if (!client){
            return {error: 'Cliente no encontrado'};
        }
        const person = await Persona.findOne({where: {id_persona: client.persona}});
        if (!person){
            return {error: 'Persona no encontrada'};
        }
        for(let i = 0; i < favorites.length ; i++){
            favorites[i].cliente = person.nombres + ' ' + person.apellido_p;
        }
        return favorites;
    }

    // add a new favorite to a client by product id
    async addFavorite(clientId, productId){
        let transaction;
        try{
            transaction = await sequelize.transaction();
    
            // validate the data
            const favoriteValidator = new FavoritosValidator();
            const favoriteResult = favoriteValidator.validateNewFavorito({cliente: clientId, producto: productId});
            if (favoriteResult.error){
                await transaction.rollback();
                return {error: "Invalid data"};
            }
            // create a new favorite
            const newFavorite = await Favoritos.create({cliente: clientId, producto: productId});
            if (!newFavorite){
                await transaction.rollback();
                return {error: 'Failed to add favorite'};
            }
    
            // find the product that has been added to the favorites
            const product = await Productos.findOne({where: {id_producto: productId}});
            // if the product does not exist, rollback the transaction
            if (!product){
                await transaction.rollback();
                return {error: 'Product not found'};
            }
            // get the client
            const client = await Cliente.findOne({where: {id_cliente: clientId}});
            // if the client does not exist, rollback the transaction
            if (!client){
                await transaction.rollback();
                return {error: 'Client not found'};
            }
    
            // get the person of the client
            const person = await Persona.findOne({where: {id_persona: client.persona}})
            if (!person){
                await transaction.rollback();
                return {error: 'Person not found'};
            }
        
            await transaction.commit();
            return {
                favorite: newFavorite,
                product: product.nombre,
                client: { 
                    name: person.nombres,
                    lastName: person.apellido_p
                }
            }
        }catch(error){
            return {error: error};
        }
    }

    // delete a favorite from a client by product id
    async deleteFavorite(clientId, productId){
        let transaction;
        try{
            transaction = await sequelize.transaction();
            // find the favorite to delete
            const favorite = await Favoritos.findOne({where: {cliente: clientId, producto: productId}});
            // if the favorite does not exist, rollback the transaction
            if (!favorite){
                await transaction.rollback();
                return {error: 'Favorite not found'};
            }
            // delete the favorite
            const deletedFavorite = await Favoritos.destroy({where: {cliente: clientId, producto: productId}});
            // if the favorite was not deleted, rollback the transaction
            if (!deletedFavorite){
                await transaction.rollback();
                return {error: 'Failed to delete favorite'};
            }
            await transaction.commit();
            return {message: 'Favorite deleted'};
        }catch(error){
            return {error: error};
        }
    }
}

module.exports = Favorites;