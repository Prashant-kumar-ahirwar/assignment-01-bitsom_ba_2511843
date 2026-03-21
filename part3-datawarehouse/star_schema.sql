-- STAR SCHEMA DESIGN
 
 CREATE DATABASE retail_dw;
USE retail_dw;

-- DIMENSION TABLE: DATE
CREATE TABLE dim_date (
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    full_date DATE,
    month INT,
    year INT
);

-- DIMENSION TABLE: STORE
CREATE TABLE dim_store (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(50),
    store_city VARCHAR(50)
);

-- DIMENSION TABLE: PRODUCT
CREATE TABLE dim_product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

-- FACT TABLE: SALES
CREATE TABLE fact_sales (
    fact_id INT AUTO_INCREMENT PRIMARY KEY,
    date_id INT,
    store_id INT,
    product_id INT,
    customer_id VARCHAR(50),
    units_sold INT,
    unit_price DECIMAL(10,2),
    total_sales DECIMAL(10,2),

    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);


