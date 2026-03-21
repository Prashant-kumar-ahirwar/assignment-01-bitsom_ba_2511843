#  Part 3 — Data Warehouses 

---

##  Objective

Design a **Star Schema Data Warehouse** for retail sales data and perform analytical queries using MySQL.

---

#  1. Star Schema Design

##  Fact Table: `fact_sales`

Stores transactional data.

| Column      | Description                       |
| ----------- | --------------------------------- |
| fact_id     | Primary Key                       |
| date_id     | FK → dim_date                     |
| store_id    | FK → dim_store                    |
| product_id  | FK → dim_product                  |
| customer_id | Customer identifier               |
| units_sold  | Number of units sold              |
| unit_price  | Price per unit                    |
| total_sales | Revenue (units_sold × unit_price) |

---

##  Dimension Table: `dim_date`

| Column    | Description |
| --------- | ----------- |
| date_id   | Primary Key |
| full_date | Actual date |
| month     | Month       |
| year      | Year        |

---

##  Dimension Table: `dim_store`

| Column     | Description |
| ---------- | ----------- |
| store_id   | Primary Key |
| store_name | Store name  |
| store_city | Store city  |

---

##  Dimension Table: `dim_product`

| Column       | Description      |
| ------------ | ---------------- |
| product_id   | Primary Key      |
| product_name | Product name     |
| category     | Product category |

---

#  2. ETL Process (Data Cleaning)

## 🔴 Issues Found

1. `store_city` → Missing values (19 NULLs)
2. `category` → Inconsistent Casing
3. `date` → Stored as string
4. No `total_sales` column

---

## ✅ Cleaning Steps

### 1. Handling Missing `store_city`

Filled missing values using corresponding `store_name`.

```sql
UPDATE retail_raw r1
JOIN retail_raw r2 
ON r1.store_name = r2.store_name
SET r1.store_city = r2.store_city
WHERE r1.store_city IS NULL
AND r2.store_city IS NOT NULL;
```

---

### 2. Standardizing Category

Converted all categories to consistent format.

```sql
UPDATE retail_raw
SET category = LOWER(category);
```
```sql
UPDATE retail_raw
SET category = 'groceries'
WHERE category IN ('grocery', 'groceries');
```

---

### 3. Converting Date Format

Converted string to DATE type.

```sql
ALTER TABLE retail_raw ADD clean_date DATE;

UPDATE retail_raw
SET clean_date = STR_TO_DATE(date, '%d/%m/%Y')
WHERE date LIKE '%/%';

UPDATE retail_raw
SET clean_date = STR_TO_DATE(date, '%d-%m-%Y')
WHERE date LIKE '__-__-____';

UPDATE retail_raw
SET clean_date = STR_TO_DATE(date, '%Y-%m-%d')
WHERE date LIKE '____-__-__';

ALTER TABLE retail_raw DROP COLUMN date;

ALTER TABLE retail_raw CHANGE clean_date date DATE;
```

---

### 4. Creating Total Sales Column

```sql
ALTER TABLE retail_raw ADD total_sales DECIMAL(10,2);

UPDATE retail_raw
SET total_sales = units_sold * unit_price;
```

---

#  3. Data Loading (Star Schema)

##  Populate dim_date

```sql
INSERT INTO dim_date (full_date, month, year)
SELECT DISTINCT
    date,
    MONTH(date),
    YEAR(date)
FROM retail_raw;
```

---

##  Populate dim_store

```sql
INSERT INTO dim_store (store_name, store_city)
SELECT DISTINCT store_name, store_city
FROM retail_raw;
```

---

##  Populate dim_product

```sql
INSERT INTO dim_product (product_name, category)
SELECT DISTINCT product_name, category
FROM retail_raw;
```

---

##  Populate fact_sales

```sql
INSERT INTO fact_sales (
    date_id, store_id, product_id,
    customer_id, units_sold, unit_price, total_sales
)
SELECT 
    d.date_id,
    s.store_id,
    p.product_id,
    r.customer_id,
    r.units_sold,
    r.unit_price,
    r.total_sales
FROM retail_raw r
JOIN dim_date d ON r.date = d.full_date
JOIN dim_store s ON r.store_name = s.store_name
JOIN dim_product p ON r.product_name = p.product_name;
```

---

#  4. Analytical Queries

---

##  Q1: Monthly Revenue by Category

```sql
SELECT 
    d.year,
    d.month,
    p.category,
    SUM(f.total_sales) AS total_revenue
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY d.year, d.month, p.category
ORDER BY d.year, d.month;
```

---

##  Q2: Top 2 Performing Stores

```sql
SELECT 
    s.store_name,
    SUM(f.total_sales) AS total_revenue
FROM fact_sales f
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_revenue DESC
LIMIT 2;
```

---

##  Q3: Month-over-Month Sales Trend

```sql
SELECT 
    d.year,
    d.month,
    SUM(f.total_sales) AS monthly_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
```

---

#  5. Key Learnings

* Designed a **Star Schema** for efficient querying
* Performed **data cleaning (ETL)** in MySQL
* Handled missing values and inconsistent data
* Created optimized analytical queries using joins and aggregation

---

# ✅ Conclusion

The project successfully demonstrates how raw retail data can be transformed into a structured **data warehouse** and used to generate meaningful business insights such as revenue trends, top-performing stores, and category-wise sales.

---
