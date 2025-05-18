const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
require('dotenv').config();
const bodyParser = require('body-parser');
const { body, validationResult } = require('express-validator');

const app = express();
const PORT = process.env.PORT || 3000;
const DB_HOST = process.env.DB_HOST || 'localhost';
// Middleware
app.use(express.json());

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(cors({
  origin: process.env.CORS_ORIGIN || '*', // Allow all origins by default
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Create MySQL connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

const bodyApp = [
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
// Test DB
pool.query('SELECT 1 + 1', (err, results) => {
  if (err) throw err;
  console.log('Connected to MySQL database.');
});

// Routes

// Get all products
app.get('/api/products', (req, res) => {
  const sql = 'SELECT * FROM producto';
  pool.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// Get one product
app.get('/api/products/:id', (req, res) => {
  const sql = 'SELECT * FROM producto WHERE IdProducto = ?';
  pool.query(sql, [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Product not found' });
    res.json(results[0]);
  });
});

// Create product
app.post('/api/products',bodyApp,
    (req, res) => {
        console.log('Full request body:', req.body);
        
        const errors = validationResult(req);
        console.log('Validation errors:', errors.array());
        if (!errors.isEmpty()) {
            return res.status(400).json({ 
            success: false,
            message: 'Validation failed',
            errors: errors.array() 
            });
        }   
      
        const { CodigoBarra, Nombre, Categoria, Marca, Precio } = req.body;
        const sql = 'INSERT INTO producto (codigoBarra, nombre, categoria_id, marca, precio) VALUES (?, ?, ?, ?, ?)';
        const result = pool.query(sql, [CodigoBarra, Nombre, parseInt(Categoria), Marca, parseFloat(Precio)]);
        
        console.log('Insert result:', result);
        res.status(201).json({ 
            success: true,
            message: 'Registration successful'
        });  
    });

// Update product
app.put('/api/products/:id', bodyApp, (req, res) => {
  const { CodigoBarra, Nombre, Categoria, Marca, Precio } = req.body;
  const sql = 'UPDATE producto SET codigoBarra = ?, nombre = ?, categoria_id = ?, marca = ?, precio = ? WHERE IdProducto = ?';
  pool.query(sql, [CodigoBarra, Nombre, Categoria, Marca, Precio, req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Product updated' });
  });
});

// Delete product
app.delete('/api/products/:id', (req, res) => {
  const sql = 'DELETE FROM producto WHERE IdProducto = ?';
  pool.query(sql, [req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Product deleted' });
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://${DB_HOST}:${PORT}`);
});