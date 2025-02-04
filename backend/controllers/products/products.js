const Productos = require('../../models/productos.js');
const Categorias = require('../../models/categorias.js');
const ProductosValidator = require('../../validators/productosValidator.js');

class Products {

    async getProducts() {
        // get all the products and return them
        const products = await Productos.findAll();
        // return the products
        return products;
    }

    async getProductById(id){
        // get the products by id and return them
        const product = await Productos.findOne({where: {id_producto: id}});
        return product;
    }

    async getProductByCategory(category){
        // get the products by category and return them
        const products = await Productos.findAll({where: {categoria: category}});
        return products;
    }

    async getCategories(){
        // get all the categories and return them
        const categories = await Categorias.findAll();
        return categories;
    }

    async addProduct(productData){
        // validate the data
        const productValidator = new ProductosValidator();
        const productResult = productValidator.validateNewProducto(productData);
        if (productResult.error) {
            return { error: productResult.error };
        }
        // create a new product
        const newProduct = await Productos.create(productData);
        return newProduct;
    }

    async updateProduct(productData){
        // validate the data
        const productValidator = new ProductosValidator();
        const productResult = productValidator.validateUpdateProducto(productData);
        if (productResult.error) {
            return { error: productResult.error };
        }
        // update the product
        const updatedProduct = await Productos.update(productData, {where: {id_producto: productData.id_producto}});
        return updatedProduct;
    }

    async deleteProduct(id){
        // change its status to inactive
        const deletedProduct = await Productos.update({estado: 'inactivo'}, {where: {id_producto: id}});
        return deletedProduct;
    }
}

module.exports = Products;