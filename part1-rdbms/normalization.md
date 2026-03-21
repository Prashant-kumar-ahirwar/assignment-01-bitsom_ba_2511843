## Anomaly Analysis

### Insert Anomaly

In the given `orders_flat.csv`, each row contains information about orders, customers, products, and sales representatives together.

For example:

* Row 1: `ORD1001, CUST01, ..., P001, ..., SR01`
* Row 2: `ORD1002, CUST02, ..., P002, ..., SR02`

If we want to insert a new product such as:

* `product_id = P009`
* `product_name = PC`

We cannot insert it independently because the table requires additional fields like `order_id`, `customer_id`, and `sales_rep_id`.

This forces the insertion of dummy or invalid data, which is known as an **Insert Anomaly**.

---

### Update Anomaly

In the dataset, the same product appears in multiple rows.

Example:

* `product_id = P002` appears in multiple rows 

If the price of this product changes from `1000` to `1200`, all rows containing `P002` must be updated.

If even one row is missed, the data becomes inconsistent. This is called an **Update Anomaly**.

---

### Delete Anomaly

Consider a row like:

* Row 12: `ORD1012, CUST03, ..., P005, ..., SR02`

If this row is deleted:

* Customer information (CUST03)
* Product information (P005)
* Sales representative details (SR02)

may also be lost, especially if they appear only in this row.

This leads to unintended loss of important data, known as a **Delete Anomaly**.

---

### Data Redundancy Observation

```sql
SELECT COUNT(*) AS total_rows,
COUNT(DISTINCT customer_id) AS unique_customers,
COUNT(DISTINCT product_id) AS unique_products
FROM csv_data;
```

Result:

* Total Rows = 186
* Unique Customers = 8
* Unique Products = 8

This shows heavy redundancy, as the same customer and product data is repeated multiple times across rows.

---

## Normalization Justification

Keeping all data in a single table may seem simple, but it introduces several issues such as redundancy and inconsistency. In the given dataset, customer, product, and sales representative details are repeated across multiple rows. This repetition leads to update anomalies, where a single change (like updating a product price) must be applied in multiple places, increasing the risk of inconsistent data.

Insert anomalies also occur because new entities like products or customers cannot be added without creating a complete order record. Similarly, delete anomalies can result in the loss of important information when a row is removed.

By normalizing the dataset into Third Normal Form (3NF), we separate data into logical tables such as Customers, Products, Sales_Representatives , Orders, and Order_Items. This eliminates redundancy and ensures each piece of information is stored only once. Relationships are maintained using foreign keys, preserving data integrity.

Although normalization increases the need for joins in queries, it significantly improves data consistency, reduces redundancy, and makes the database more scalable and maintainable. Therefore, **normalization is not over-engineering but a necessary step for efficient database design.**
