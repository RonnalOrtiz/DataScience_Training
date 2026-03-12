-- ============================================================
-- Day 02: GROUP BY, Aggregations & Sales Analysis
-- Dataset: Brazilian E-Commerce (Olist)
-- Topics: GROUP BY, COUNT, SUM, AVG, MIN, MAX, HAVING
-- Author: Ronnal Ortiz
-- Date: 2025-03-09
-- ============================================================

-- Aggregation functions
-- COUNT(*): Row count by group
-- COUNT(col): Non null values count
-- SUM(col): Sum of numeric values
-- AVG(col): Average of the group
-- MIN(col)/MAX(col): Minimum/Maximum value

-- ============================================================

-- Basic aggregations using "orders"

-- Exercise 01: Order distribution by status
-- How many orders by status are there?

SELECT order_status,
	COUNT(*) AS Total_orders
FROM orders
GROUP BY order_status
ORDER BY Total_orders DESC;

-- Answer: A total of 96.478 orders were delivered, while 1.107 orders are in delivering. A low proportion of orders were canceled (625). 

================================================================

-- Exercise 02: Amount of orders by month
-- How many orders were asked by month?

SELECT STRFTIME("%y-%m", order_purchase_timestamp) AS order_month,
	COUNT(*) as total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- Note: STRFTIME is the date funtion in SQLite, in PostgreSQL is DATE_TRUNC, with MySQL the date function is DATE_FORMAT

-- Answer: The number of orders showed a notable increase in the second quarter of the 2017. This behavior remained consistently 
-- between 3000 and 8000 orders per month during the observed period; the highest volume of orders was observed in November 2017, and the first quarter of 2018.

=================================================================

-- Payments and orders aggregations

-- Average, minimum, and maximum ticket by order

-- Excerise 03: Payment metrics by order
 
SELECT order_id
	COUNT(*) AS total_items,
	SUM(payment_value) AS order_revenue,
	AVG(payment_value) AS avg_item_price,
	SUM(payment_value) AS sum_item_price,
	MIN(payment_value) AS min_item_price,
	MAX(payment_value) AS max_item_price
FROM olist_order_payments_dataset
GROUP BY order_id
ORDER BY order_revenue DESC
LIMIT 10;

-- Answer: The highest payment per order was of 13.664, nearly of 87% more than the payment of the next order. Excluding the highest payment, the observed payment
-- of the next nine highest payments was between 4.681 to 7.664. The total items reported in those orders was one por order.

=================================================================

-- Total payment by payment method

-- Exercise 04: Payment and volumen by payment method

SELECT payment_type,
	COUNT(*) AS total_transactions,
	SUM(payment_value) AS total_revenue,
	ROUND(AVG(payment_value),2) AS avg_payment,
	MIN(payment_value) AS min_payment,
	MAX(payment_value) AS max_payment
FROM olits_order_payments_dataset
GROUP BY payment_type
ORDER BY total_revenue; 

-- Answer: The prefer method to pay the orders was credit card with 76.795 transactiones for a total of 12.542.084, the less value in this category was 0,01,
-- while the highest value was of 13.664. Boleto was the second payment method with 19784 transactions with a total payment of 2.869.731. The use of vouchers,
-- debit card were methods with low preference to pay orders.

=================================================================

--  Orders with more than 3 items

-- Exercise 05: Orders with more number of items

SELECT order_id,
	COUNT(*) AS total_items
FROM orders
GROUP BY order_id
HAVING total_items > 3
ORDER BY total_items DESC;

-- Answer: This SQL operation returns no results because each order has one item. 
-- However, the next query that use other table give us other perspective with more powerful.

-- Exercise 05-1: Orders with more number of items - order_items table

SELECT order_id,
	COUNT(*) AS total_items
FROM olist_order_items_dataset
GROUP BY order_id
HAVING total_items > 3
ORDER BY total items DESC;

-- Answer: The greater number of items per order was 20 to 21, while most of the orders included fewer than 10 items. According to the query, it seems that four
-- items is the most common number of elements in each order.

=================================================================
-- Advanced query. Integration of all queries of the day

-- Use of JOIN to combine orders + payments dataset to get bussiness metrics per month

-- Exercise 06: Month selling summary

SELECT strftime("%Y-%m", o.order_purchase_timestamp) AS order_month,
	COUNT(DISTINCT o.order_id) AS total_orders,
	ROUND(SUM(p.payment_value),2) AS total_orders,
	ROUND(AVG(p.payment_value),2) AS avg_order_value,
	COUNT(DISTINCT o.customer_id) AS unique_customers
FROM order o
JOIN olist_order_payments_dataset p ON o.order_id=p_order_id
WHERE o.order_status = "delivered"
GROUP BY order_month
ORDER BY order_month;

-- Answer: The amount of orders start to increase since the second quarter of 2017 and get the highest numbers in 2028, where the first quarter of this 
-- year shows the greater number of orders for near to 6.500 customers with aroun of 1.000.000 of revenue.	
