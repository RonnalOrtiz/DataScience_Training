-- ============================================================
-- File    : Reviewing_sqlbolt_lessons_01_to_07.sql
-- Course  : SQLBolt — Interactive SQL Tutorial
-- Lessons : 1 to 7
-- Topics  : SELECT basics · Filtering · Sorting · Aggregations
--           INNER JOIN · LEFT JOIN · RIGHT JOIN · FULL JOIN
-- Dataset : Brazilian E-Commerce (Olist) — SQLite
-- Author  : Ronnal Esneyder Ortiz
-- Created : 2025-03-18
-- Repo    : DataScienceTraining/sql/
-- Notes   : Practice queries adapted from SQLBolt lessons to the
--           Olist ecommerce dataset.
-- ============================================================

-- Basic queries, returning one or several columns
-- SQL Lesson 1: SELECT with queries

SELECT order_id
FROM orders;

SELECT order_id, customer_id
FROM orders;

SELECT *
FROM orders;

-- Defining constraints, use of WHERE clause with numeric data
-- SQL Lesson 2: Queries with constraints (Part 1)
-- Some operators
-- =, !=, <, <=, >, >=
-- BETWEEN ... AND ...
-- NOT BETWEEN ... AND ...
-- IN (...)
-- NOT IN (...)
 
SELECT order_id, payment_value
FROM olist_order_payments_dataset
WHERE payment_value = 65.71;

SELECT payment_value
FROM olist_order_payments_dataset
WHERE payment_value != 65.71;

SELECT payment_value
FROM olist_order_payments_dataset
WHERE payment_value  BETWEEN 65.71 AND 100;

SELECT payment_value
FROM olist_order_payments_dataset
WHERE payment_value NOT BETWEEN 65.71 AND 100;

SELECT payment_value
FROM olist_order_payments_dataset
WHERE payment_value IN (24.39,107.78,128.45);

SELECT payment_value
FROM olist_order_payments_dataset
WHERE payment_value NOT IN (24.39,107.78,128.45);

-- Defining constraints, use of WHERE clause with text data
-- SQL Lesson 3: Queries with constraints (Part 2)
-- Some operators
-- = Case sensitive exact string comparison
-- != or <> Case sensitive exact string inequality comparison
-- LIKE Case insensitive exact string comparison
-- NOT LIKE Case insensitive exact string inequality comparison 
-- % Used anywhere in a string to match a sequence of zero or more characters (only with LIKE or NOT LIKE)
-- _ Used anywhere in a string to match a single character (only with LIKE or NOT LIKE)
-- IN (...) String exists in a list
-- NOT IN (...) String does not exists in a list

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type = "debit_card";

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type <> "credit_card";

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type != "credit_card";

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type LIKE "boleto";

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type  NOT LIKE "boleto";

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type LIKE "%card";

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type NOT LIKE "credit%"; 

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type IN ("credit_card","voucher");

SELECT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_type NOT IN ("credit_card", "voucher");

-- Defining queries with row operations, use of WHERE and, DISTINCT clauses
-- SQL Lesson 4: Filtering and, sorting Query results using ORDER BY, LIMIT, OFFSET

SELECT DISTINCT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_value >5000;

SELECT DISTINCT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_value >1000
ORDER BY payment_value DESC;

SELECT DISTINCT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_value >1000
ORDER BY payment_value ASC;

SELECT DISTINCT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_value >1000
ORDER BY payment_value DESC
LIMIT 20;

SELECT DISTINCT payment_type, payment_value
FROM olist_order_payments_dataset
WHERE payment_value >1000
ORDER BY payment_value ASC
LIMIT 20 OFFSET 500;

-- SQL Lesson 6: Multiple-table queries with JOINS
-- INNER JOIN

SELECT 
	o.order_id, 
	c.customer_city, 
	c.customer_state,
	o.order_delivered_customer_date
FROM orders AS o
INNER JOIN olist_customers_dataset AS c
	ON o.customer_id = c.customer_id;

SELECT 
	o.order_id, 
	c.customer_city, 
	c.customer_state,
	o.order_delivered_customer_date,
	o.order_estimated_delivery_date
FROM orders AS o
INNER JOIN olist_customers_dataset AS c
	ON o.customer_id = c.customer_id
WHERE (o.order_estimated_delivery_date - o.order_delivered_customer_date) > 5;

SELECT 
	o.order_id,
	o.order_status,
	p.payment_type,
	p.payment_value
FROM orders AS o
INNER JOIN olist_order_payments_dataset AS p
	ON o.order_id = p.order_id
ORDER BY p.payment_value DESC LIMIT 15;

-- SQL Lesson 7: Multiple-table queries with JOINS
-- OUTER JOINs: LEFT JOIN/RIGHT JOIN/FULL JOIN

-- List of payment type methods
SELECT DISTINCT payment_type 
FROM olist_order_payments_dataset;

-- Payment value for each method payment
SELECT DISTINCT payment_type, payment_value 
FROM olist_order_payments_dataset
GROUP BY payment_type;

SELECT 
	o.order_item_id,
	p.product_category_name,
	p.product_name_lenght,
	o.price
FROM olist_order_items_dataset AS o
LEFT JOIN olist_products_dataset AS p
	ON o.product_id = p.product_id
WHERE p.product_category_name = 'perfumaria';
