const express = require('express');
const router = express.Router();
const { validateProduct } = require('../middleware/validationMiddleware');
const productCtrl = require('../controllers/productController');

router.get('/products', productCtrl.getProducts);
router.get('/products/:id', productCtrl.getProductsById);
router.post('/products', validateProduct, productCtrl.createProduct);
router.put('/products/:id', validateProduct, productCtrl.updateProduct);
router.delete('/products/:id', productCtrl.deleteProduct);

module.exports = router;