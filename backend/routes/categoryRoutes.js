const express = require('express');
const router = express.Router();
const { validateProduct } = require('../middleware/validationMiddleware');
const categoryCtrl = require('../controllers/categoryController');

router.get('/category', categoryCtrl.getCategory);
router.get('/category/:id', categoryCtrl.getCategoryById);
router.post('/category', validateProduct, categoryCtrl.createCategory);
router.put('/category/:id', validateProduct, categoryCtrl.updateCategory);
router.delete('/category/:id', categoryCtrl.deleteCategory);

module.exports = router;