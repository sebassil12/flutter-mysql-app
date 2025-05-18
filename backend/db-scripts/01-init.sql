-- Create the table category
CREATE TABLE IF NOT EXISTS categoria(
    IdCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Create th table product with relation on category
CREATE TABLE IF NOT EXISTS producto (
    IdProducto INT AUTO_INCREMENT PRIMARY KEY,
    codigoBarra VARCHAR(255) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    categoria_id INT NOT NULL,
    marca VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_categoria
        FOREIGN KEY(categoria_id)
        REFERENCES categoria(IdCategoria)
        ON DELETE CASCADE
);

-- Grant permissions to the user
-- Create user if not exists
CREATE USER IF NOT EXISTS 'dbuser'@'%' IDENTIFIED BY 'dbpass';

-- Grant access to the specific database
GRANT USAGE ON *.* TO 'dbuser'@'%';
GRANT ALL PRIVILEGES ON business_db.* TO 'dbuser'@'%' WITH GRANT OPTION;

-- Apply changes
FLUSH PRIVILEGES;


