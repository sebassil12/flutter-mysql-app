const pool = require('../config/db');

exports.getProducts = (req, res) => {
    const sql = 'SELECT * FROM producto';
    pool.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
    });
};

// Get one product
exports.getProductsById =  (req, res) => {
    const sql = 'SELECT * FROM producto WHERE IdProducto = ?';
    pool.query(sql, [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Product not found' });
    res.json(results[0]);
    });
};

// Create product
exports.createProduct = (req, res) => {
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
    };

// Update product
exports.updateProduct = (req, res) => {
    const { CodigoBarra, Nombre, Categoria, Marca, Precio } = req.body;
    const sql = 'UPDATE producto SET codigoBarra = ?, nombre = ?, categoria_id = ?, marca = ?, precio = ? WHERE IdProducto = ?';
    pool.query(sql, [CodigoBarra, Nombre, Categoria, Marca, Precio, req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Product updated' });
    });
};

// Delete product
exports.deleteProduct = (req, res) => {
    const sql = 'DELETE FROM producto WHERE IdProducto = ?';
    pool.query(sql, [req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Product deleted' });
    });
};
