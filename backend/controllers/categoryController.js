const pool = require('../config/db');

// Get all categories
exports.getCategory = (req, res) => {
    const sql = 'SELECT * FROM categoria';
    pool.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
    });
};

// Get one category
exports.getCategoryById =  (req, res) => {
    const sql = 'SELECT * FROM category WHERE IdCategoria = ?';
    pool.query(sql, [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Category not found' });
    res.json(results[0]);
    });
};

// Create category
exports.createCategory = (req, res) => {
    const errors = validationResult(req);
    console.log('Validation errors:', errors.array());
    if (!errors.isEmpty()) {
        return res.status(400).json({ 
        success: false,
        message: 'Validation failed',
        errors: errors.array() 
        });
    }   
      
    const { Nombre } = req.body;
    const sql = 'INSERT INTO producto (nombre) VALUES (?)';
    const result = pool.query(sql, [Nombre]);
    
    console.log('Insert result:', result);
    res.status(201).json({ 
        success: true,
        message: 'Registration successful'
    });  
    };

// Update category
exports.updateCategory = (req, res) => {
    const { Nombre } = req.body;
    const sql = 'UPDATE categoria SET nombre = ? WHERE IdCategoria = ?';
    pool.query(sql, [Nombre, req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Category updated' });
    });
};

// Delete category
exports.deleteCategory = (req, res) => {
    const sql = 'DELETE FROM categoria WHERE IdCategoria = ?';
    pool.query(sql, [req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Category deleted' });
    });
};