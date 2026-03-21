
-- i did this on DBeaver 
-- open and connect to duckdb then create a new sql file on that and 
-- tried those quries with matching adresses

-- =========================================
-- Q1: List all customers along with the total number of orders they have placed
-- =========================================

SELECT 
    c.customer_id,
    c.name,
    COUNT(j.order_id) AS total_orders
FROM read_csv_auto('..//datasets//customers.csv') c
LEFT JOIN read_json_auto('..//datasets//orders.json') j
ON c.customer_id = j.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC;


-- =========================================
-- Q2: Find the top 3 customers by total order value
-- =========================================

SELECT 
    c.customer_id,
    c.name,
    SUM(j.total_amount) AS total_spent
FROM read_csv_auto('..//datasets//customers.csv') c
JOIN read_json_auto('..//datasets//orders.json') j
ON c.customer_id = j.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 3;


-- =========================================
-- Q3: List all products purchased by customers from Bangalore
-- =========================================

SELECT 
    c.name,
    c.city,
    p.product_name,
    p.quantity
FROM read_csv_auto('..//datasets//customers.csv') c
JOIN read_json_auto('..//datasets//orders.json') j
ON c.customer_id = j.customer_id
JOIN read_parquet('..//datasets//products.parquet') p
ON j.order_id = p.order_id
WHERE c.city = 'Bangalore';


-- =========================================
-- Q4: Join all three files to show: customer name, order date, product name, and quantity
-- =========================================

SELECT 
    c.name,
    j.order_date,
    p.product_name,
    p.quantity
FROM read_csv_auto('..//datasets//customers.csv') c
JOIN read_json_auto('..//datasets//orders.json') j
ON c.customer_id = j.customer_id
JOIN read_parquet('..//datasets//products.parquet') p
ON j.order_id = p.order_id
ORDER BY j.order_date;