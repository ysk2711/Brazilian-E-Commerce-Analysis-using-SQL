/*
PROJECT: Olist E-Commerce Data Analysis

DATABASE: PostgreSQL

Initial database preparation, data quality checks,
candidate key validation, and primary key assignment.
*/

/*
============================================
1. DUPLICATE CHECKS FOR CANDIDATE PRIMARY KEYS
============================================
*/
SELECT 'customers.customer_id' AS Table_Column,
       COUNT(*) AS Duplicate_Groups
FROM (
    SELECT customer_id
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'orders.order_id',
       COUNT(*)
FROM (
    SELECT order_id
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'products.product_id',
       COUNT(*)
FROM (
    SELECT product_id
    FROM products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'sellers.seller_id',
       COUNT(*)
FROM (
    SELECT seller_id
    FROM sellers
    GROUP BY seller_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'order_items.order_id + order_item_id',
       COUNT(*)
FROM (
    SELECT order_id, order_item_id
    FROM order_items
    GROUP BY order_id, order_item_id
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'order_payments.order_id + payment_sequential',
       COUNT(*)
FROM (
    SELECT order_id, payment_sequential
    FROM order_payments
    GROUP BY order_id, payment_sequential
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

SELECT 'category_translation.product_category_name',
       COUNT(*)
FROM (
    SELECT product_category_name
    FROM category_translation
    GROUP BY product_category_name
    HAVING COUNT(*) > 1
) AS duplicates

/*
============================================
2. NULL CHECKS FOR CANDIDATE PRIMARY KEYS
============================================
*/
SELECT 'customers.customer_id' AS Table_Column,
       COUNT(*) FILTER (WHERE customer_id IS NULL) AS Null_Count
FROM customers

UNION ALL

SELECT 'orders.order_id',
       COUNT(*) FILTER (WHERE order_id IS NULL)
FROM orders

UNION ALL

SELECT 'products.product_id',
       COUNT(*) FILTER (WHERE product_id IS NULL)
FROM products

UNION ALL

SELECT 'sellers.seller_id',
       COUNT(*) FILTER (WHERE seller_id IS NULL)
FROM sellers

UNION ALL

SELECT 'order_items.order_id + order_item_id',
       COUNT(*) FILTER (
           WHERE order_id IS NULL OR order_item_id IS NULL
       )
FROM order_items

UNION ALL

SELECT 'order_payments.order_id + payment_sequential',
       COUNT(*) FILTER (
           WHERE order_id IS NULL OR payment_sequential IS NULL
       )
FROM order_payments

UNION ALL

SELECT 'category_translation.product_category_name',
       COUNT(*) FILTER (
           WHERE product_category_name IS NULL
       )
FROM category_translation

/*
============================================
3. NULL AUDIT ACROSS ALL TABLES USING JSONB
============================================
*/
SELECT 'customers' AS Table_Name,
       j.key AS Column_Name,
       COUNT(*) AS Null_Count
FROM customers AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

UNION ALL

SELECT 'orders',
       j.key,
       COUNT(*)
FROM orders AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

UNION ALL

SELECT 'order_items',
       j.key,
       COUNT(*)
FROM order_items AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

UNION ALL

SELECT 'order_payments',
       j.key,
       COUNT(*)
FROM order_payments AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

UNION ALL

SELECT 'order_reviews',
       j.key,
       COUNT(*)
FROM order_reviews AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

UNION ALL

SELECT 'products',
       j.key,
       COUNT(*)
FROM products AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

UNION ALL

SELECT 'sellers',
       j.key,
       COUNT(*)
FROM sellers AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

UNION ALL

SELECT 'geolocation',
       j.key,
       COUNT(*)
FROM geolocation AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

UNION ALL

SELECT 'category_translation',
       j.key,
       COUNT(*)
FROM category_translation AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE j.value = 'null'::jsonb
GROUP BY j.key

ORDER BY Table_Name, Column_Name

/*
============================================
4. BLANK STRING AUDIT ACROSS ALL TABLES
============================================
*/
SELECT 'customers' AS Table_Name,
       j.key AS Column_Name,
       COUNT(*) AS Blank_Count
FROM customers AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

UNION ALL

SELECT 'orders',
       j.key,
       COUNT(*)
FROM orders AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

UNION ALL

SELECT 'order_items',
       j.key,
       COUNT(*)
FROM order_items AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

UNION ALL

SELECT 'order_payments',
       j.key,
       COUNT(*)
FROM order_payments AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

UNION ALL

SELECT 'order_reviews',
       j.key,
       COUNT(*)
FROM order_reviews AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

UNION ALL

SELECT 'products',
       j.key,
       COUNT(*)
FROM products AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

UNION ALL

SELECT 'sellers',
       j.key,
       COUNT(*)
FROM sellers AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

UNION ALL

SELECT 'geolocation',
       j.key,
       COUNT(*)
FROM geolocation AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

UNION ALL

SELECT 'category_translation',
       j.key,
       COUNT(*)
FROM category_translation AS t
CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) AS j(key, value)
WHERE jsonb_typeof(j.value) = 'string'
  AND BTRIM(j.value #>> '{}') = ''
GROUP BY j.key

ORDER BY Table_Name, Column_Name

/*
============================================
5. PRIMARY KEY CONSTRAINTS
============================================
*/
ALTER TABLE customers
ADD CONSTRAINT pk_customers
PRIMARY KEY (customer_id);

ALTER TABLE orders
ADD CONSTRAINT pk_orders
PRIMARY KEY (order_id);

ALTER TABLE products
ADD CONSTRAINT pk_products
PRIMARY KEY (product_id);

ALTER TABLE sellers
ADD CONSTRAINT pk_sellers
PRIMARY KEY (seller_id);

ALTER TABLE order_items
ADD CONSTRAINT pk_order_items
PRIMARY KEY (order_id, order_item_id);

ALTER TABLE order_payments
ADD CONSTRAINT pk_order_payments
PRIMARY KEY (order_id, payment_sequential);

ALTER TABLE category_translation
ADD CONSTRAINT pk_category_translation
PRIMARY KEY (product_category_name);
