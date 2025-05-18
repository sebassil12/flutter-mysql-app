const { body } = require('express-validator');

const validateProduct = [
    body('CodigoBarra')
        .trim()
        .isString()
        .withMessage('Username must be a string')
        .isLength({ min: 3 })
        .withMessage('Username must be at least 3 characters'),
    body('Nombre')
        .trim()
        .isString()
        .withMessage('Password must be a string')
        .isLength({ min: 3 }) // Changed from 8 to match Flutter
        .withMessage('Password must be at least 6 characters'),
    body('Categoria')
        .trim()
        .isInt()
        .withMessage('Password must be a string')
        .isLength({ min: 1 }) // Changed from 8 to match Flutter
        .withMessage('Password must be at least 6 characters'),
    body('Marca')
        .trim()
        .isString()
        .withMessage('Password must be a string')
        .isLength({ min: 3 }) // Changed from 8 to match Flutter
        .withMessage('Password must be at least 6 characters'),
    body('Precio')
        .trim()
        .isString()
        .withMessage('Password must be a string')
        .isLength({ min: 3 }) // Changed from 8 to match Flutter
        .withMessage('Password must be at least 6 characters'),
    ]

const validateCategory = [
    body('Nombre')
        .trim()
        .isString()
        .withMessage('Password must be a string')
        .isLength({ min: 3 }) // Changed from 8 to match Flutter
        .withMessage('Password must be at least 6 characters'),
    ]

module.exports = {
    validateProduct,
    validateCategory,
}