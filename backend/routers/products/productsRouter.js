const express = require('express');
const router = express.Router();
const Products = require('../../controllers/products/products.js');
const path = require('node:path');

router.get('/home/productos', async (req, res) => {
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'views', 'products', 'products.html' );
    res.sendFile(pathFile);
});

router.get('/home/productos/:producto', async (req, res) => {
    const pathFile = await path.join(__dirname, '..', '..', '..', 'frontend', 'views', 'products', 'productProfile.html' );
    res.sendFile(pathFile);
});

// get a json with all the products
router.get('/productos', async(req, res) => {
    const products = new Products();
    const allProducts = await products.getProducts();
    return res.json(allProducts);
})

// get a json with the product by id
router.get('/productos/:id', async(req, res) => {
    const products = new Products();
    const product = await products.getProductById(req.params.id);
    return res.json(product);
})

module.exports = router;
