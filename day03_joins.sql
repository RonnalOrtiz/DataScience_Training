-- ============================================================
-- File    : day03_joins.sql
-- Plan    : DataScienceTraining — 8-Week Roadmap
-- Day     : 03
-- Topics  : INNER JOIN · LEFT JOIN · Multi-table JOINs (3-4 tables)
--           NULL detection · Aliasing best practices
-- Dataset : Brazilian E-Commerce (Olist) — SQLite
-- Author  : Ronnal E Ortiz C
-- Created : 2025-03-23
-- Repo    : DataScienceTraining/sql/exercises/

-- ============================================================

-- Exercise 01: Orders delivered by customer's city
-- Tables: orders + customers
-- Bussiness question: Business question: Where are our active customers?

SELECT
	c.customer_city,
	c.customer_state,
	COUNT(o.order_id) AS total_orders
FROM orders AS o
INNER JOIN olist_customers_dataset AS c
	ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer city, c.customer_state
ORDER BY total_orders DESC
LIMIT 15;

-- ANSWER: -- Answer: Sao Paulo had the greatest orders delivered (15045), upper than 127% compared with
-- Rio de Janeiro, the city with the second largest number of delivered orders, while the other
-- cities had fewer than 3000 orders delivered.

-- =================================================================

-- Exercise 02: Average ticket by payment method
-- Tables: Orders + payments
-- Business question: Which payment method had more payments per transaction?

SELECT
	p.payment_type,
	COUNT(o.order_id) AS total_orders
	ROUND(SUM(p.payment_value),2) AS total_revenue,
	ROUND(AVG(p.payment_value),2) AS avg_order_value
FROM orders AS o
INNER JOIN olist_order_payments_dataset AS p
	ON o.order_id = p.order_id
GROUP BY p.payment_type
ORDER BY total_revenue DESC;

-- Answer: The payment method with the highest revenue was credit card, with 12.542.084 in 76795 
-- orders, the average payment was 163.32. This one was around 18.3 more than the average for boleto
-- or debit card, such as payment methods with a total revenue of 2.869.361, and 217.989, respectively.
-- The average payment using Boucher was less than half that of the other payment methods.

-- =================================================================


-- Exercise 03: Average price by category product
-- Tables: order_items + products
-- Business question: Which category generate the highest revenue?

SELECT
	p.product_category_name,
	COUNT(oi.order_id) AS total_items,
	ROUND(AVG(oi.price),2) AS avg_item_price,
	ROUND(SUM(oi.price),2) AS total_revenue
FROM olist_order_items_dataset AS oi
INNER JOIN olist_products_dataset AS p
	ON oi.product_id=p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_revenue DESC LIMIT 15;

-- Answer: The first 15 items produce a total revenue of over 273.900 per category; this result corresponds to "moveis_escritorio". The category
-- with the highest revenue was "beleza_saude" with 1.258.681, the avergae price was 130.16, followed by
-- "relogios_presentes" and "cama_mesa_banho" with a revenue of 1.205.005 and 1.036.988, respectively.

-- ==================================================================
-- LEFT JOIN
-- Exercise 04: Orders without payment register
-- Tables: orders + payments
-- Business question: Are there orders without a payment method reported?

SELECT
	p.payment_type,
	o.order_status,
	COUNT(o.order_id) AS total_orders
FROM orders AS o
LEFT JOIN olist_order_payments_dataset AS p
	ON o.order_id = p.order_id
WHERE p.payment_type IS NULL;

-- Answer: Yes, were found one delivered order without payment method.

-- ===========================================================
-- Exercise 05: Items without orders
-- Tables: orders_items + products
-- Business question: Are there any products in the catalog that have never been sold?

SELECT
	p.product_id,
	p.product_category_name
FROM olist_products_datase AS p
LEFT JOIN olist_order_items AS oi
	ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Answer: No, no item in the catalog has been reported without orders.

-- ===========================================================
-- JOIN of three tables
-- Exercise 06: Total revenue per customer with geographic and payment context
-- Tables: customers + orders + payments
-- Business question: Who are our highest-value customers and where are they located?

SELECT
	c.customer_id,
	c.customer_state,
	c.customer_city,
	p.payment_type,
	COUNT(DISTINCT c.customer_id) AS num_customers,
	COUNT(o.order_id) AS total_orders,
	ROUND(AVG(p.payment_value),2) AS avg_payment_value,
	ROUND(SUM(p.payment_value),2) AS total_payment_value
FROM olist_customers_dataset AS c
INNER JOIN orders AS o
	ON c.customer_id = o.customer_id
INNER JOIN olist_payments_dataset AS p
	ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state, c.customer_city, p.payment_type
ORDER BY total_payment_value DESC LIMIT 20;

-- Answer: The highest payment was observed in Sao Paulo with 1.683.034 from 11.813 customers that used the credit card
-- as the prefered payment method, while boleto in the same state got the third position into the customers with high value.
-- In Rio de Janeiro with credit card as the prefered payment method was found the second group with more value with total
-- payment near to 700.000 less for the half of the orders.	

-- ===========================================================
-- Exercise 07: Revenue by product category and customer state
-- Tables: orders + order_items + products + customers
-- Business question: Which categories generate the most revenue in each region?

SELECT
	p.product_category_name,
	c.customer_state,
	COUNT(DISTINCT c.customer_id) AS num_customers,
	COUNT(o.order_id) AS total_orders,
	ROUND(AVG(oi.price),2) AS avg_price,
	ROUND(SUM(oi.price),2) AS total_revenue
FROM orders AS o
INNER JOIN olist_order_items_dataser AS oi
	ON o.order_id = oi.order_id
INNER JOIN olist_products_dataset AS p
	ON oi.product_id = p.product_id
INNER JOIN olist_customers_dataset AS c
	ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
	AND p.product_category_name IS NOT NUL
GROUP BY p.product_category_name, c.customer_state
ORDER BY total_revenue DESC LIMIT 20;

-- Answer: The first 20 items with more value have total revenue above 120.000, and mainly distributed in
-- Sao Paulo state, where the item with the highest revenue was for "cama_mesa_banho" with 472.238 for 
-- 5.157 orders, followed for items in "beleza_saude" with 4.125 orders with a total revenue of 453.916.
-- In Rio de Janeiro the item with highest revenue was "relojios_presentes" in 846 orders with a revenue
-- of 174.895, while for Montes Claros the best revenue was for "beleza_saude" in 1.064 orders (154.324).
