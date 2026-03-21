SHOW DATABASES;

-- drop database orders_flat;

CREATE DATABASE  IF NOT EXISTS orders_flat;

USE orders_flat;

show tables;

CREATE TABLE Customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_city VARCHAR(50)
);

CREATE TABLE Products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price INT
);

CREATE TABLE Sales_Representatives (
    sales_rep_id VARCHAR(20) PRIMARY KEY,
    sales_rep_name VARCHAR(100),
    sales_rep_email VARCHAR(100),
    office_address VARCHAR(255)
);

CREATE TABLE Orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    sales_rep_id VARCHAR(20),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (sales_rep_id) REFERENCES Sales_Representatives(sales_rep_id)
);

CREATE TABLE Order_Items (
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);




-- Importing the Given Data in SQL

-- First: Create a Temporary Table (Same as CSV)
CREATE TABLE csv_data (
order_id VARCHAR(20),
customer_id VARCHAR(20),
customer_name VARCHAR(100),
customer_email VARCHAR(100),
customer_city VARCHAR(100),
product_id VARCHAR(20),
product_name VARCHAR(100),
category VARCHAR(50),
unit_price INT,
quantity INT,
order_date DATE,
sales_rep_id VARCHAR(20),
sales_rep_name VARCHAR(100),
sales_rep_email VARCHAR(100),
office_address TEXT
);


-- Import CSV into MySQL
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\orders_flat.csv'
INTO TABLE csv_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;



-- 1️⃣ Insert Customers
INSERT INTO Customers (customer_id, customer_name, customer_email, customer_city)
SELECT DISTINCT
customer_id,
customer_name,
customer_email,
customer_city
FROM csv_data;

-- 2️⃣ Insert Products
INSERT IGNORE INTO Products
(product_id, product_name, category, unit_price)
SELECT DISTINCT
product_id,
product_name,
category,
unit_price
FROM csv_data;


-- 3️⃣ Insert Sales Representatives
INSERT IGNORE INTO Sales_Representatives
(sales_rep_id, sales_rep_name, sales_rep_email, office_address)
SELECT DISTINCT
sales_rep_id,
sales_rep_name,
sales_rep_email,
office_address
FROM csv_data;

-- 4️⃣ Insert Orders
INSERT INTO Orders (order_id, customer_id, sales_rep_id, order_date)
SELECT DISTINCT
order_id,
customer_id,
sales_rep_id,
order_date
FROM csv_data;

-- 5️⃣ Insert Order Items (Bridge Table)
INSERT INTO Order_Items (order_id, product_id, quantity)
SELECT
order_id,
product_id,
quantity
FROM csv_data;

-- 6️⃣ Verify Data
SELECT
o.order_id,
c.customer_name,
p.product_name,
oi.quantity
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
LIMIT 10;
