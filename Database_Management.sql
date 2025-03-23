CREATE DATABASE IF NOT EXISTS ecommerce_pricing;
USE ecommerce_pricing;

-- Table to store product details
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    brand VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store pricing data from Amazon & Flipkart
CREATE TABLE pricing_data (
    price_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    platform ENUM('Amazon', 'Flipkart') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2),
    final_price DECIMAL(10,2) GENERATED ALWAYS AS (price - (price * discount_percentage / 100)) STORED,
    availability_status ENUM('In Stock', 'Out of Stock') NOT NULL,
    payment_methods VARCHAR(255),
    scrape_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Table to store promotions and discount trends
CREATE TABLE promotions (
    promo_id INT AUTO_INCREMENT PRIMARY KEY,
    platform ENUM('Amazon', 'Flipkart') NOT NULL,
    product_id INT,
    promo_type VARCHAR(255),
    start_date DATE,
    end_date DATE,
    discount_percentage DECIMAL(5,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Table for tracking price fluctuations
CREATE TABLE price_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    platform ENUM('Amazon', 'Flipkart') NOT NULL,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Table for region-wise revenue analysis
CREATE TABLE sales_data (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    platform ENUM('Amazon', 'Flipkart') NOT NULL,
    region VARCHAR(100),
    units_sold INT,
    revenue DECIMAL(12,2),
    cost DECIMAL(12,2),
    profit DECIMAL(12,2) GENERATED ALWAYS AS (revenue - cost) STORED,
    sale_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
