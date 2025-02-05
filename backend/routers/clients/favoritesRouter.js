const Favorites = require('../../controllers/clients/favorites.js');
const express = require('express');
const router = express.Router();

router.get('/favoritos/:cliente', async (req, res) => {
    const idClient = req.params.cliente;
    const favorites = new Favorites();
    const allFavorites = await favorites.getFavorites(idClient);
    if (allFavorites.error){
        return res.status(400).json({error: allFavorites.error});
    }
    return res.status(200).json(allFavorites);
})

router.post('/favoritos/:cliente/:producto', async (req, res) => {
    const idClient = req.params.cliente;
    const idProduct = req.params.producto;
    const favorites = new Favorites();
    const favorite = await favorites.addFavorite(idClient, idProduct);
    if (favorite.error){
        return res.status(400).json({error: favorite.error});
    }
    return res.status(200).json(favorite);
});

router.delete('/favoritos/:cliente/:producto', async (req, res) => {
    const idClient = req.params.cliente;
    const idProduct = req.params.producto;
    const favorites = new Favorites();
    const favorite = await favorites.deleteFavorite(idClient, idProduct);
    if (favorite.error){
        return res.status(400).json({error: favorite.error});
    }
    return res.status(200).json(favorite);
});

module.exports = router;
