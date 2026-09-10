--Analysis 1 - Business Overview
--Business Question
--How is the company performing overall?

-- KPI1 - Total Revenue
SELECT
ROUND(SUM(payment_value),2) AS total_revenue
FROM payments;
-- Business Insight
--This tells management the total amount customers have paid.

-- KPI2 - Total Orders
SELECT
COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- KPI3 - Total Customers
SELECT
COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

-- KPI4 - Average Order Value
SELECT

ROUND(

SUM(payment_value) /

COUNT(DISTINCT order_id)

,2)

AS average_order_value

FROM payments;

-- KPI5 - Average Items Per Order
SELECT

ROUND(

COUNT(*)::numeric /

COUNT(DISTINCT order_id)

,2)

AS avg_items_per_order

FROM order_items;


-- Analysis2 - Revenue Trend
-- Business Question: Is revenue increasing or decreasing over time?
SELECT

DATE_TRUNC('month',
order_purchase_timestamp) AS month,

ROUND(
SUM(payment_value),2
) AS revenue

FROM orders o

JOIN payments p

ON o.order_id=p.order_id

GROUP BY month

ORDER BY month;

-- Analysis3 - Order Status
-- Business Question: Are customers receiving their orders successfully?
SELECT

order_status,

COUNT(*) AS total_orders

FROM orders

GROUP BY order_status

ORDER BY total_orders DESC;

-- Business Recommendation: As many orders canceled or unavailable, investigate fulfillment issues.

-- Analysis4 - Customer Distribution
-- Business Question: Where are most customers located?
SELECT

customer_state,

COUNT(*) AS customers

FROM customers

GROUP BY customer_state

ORDER BY customers DESC;

-- Top Cities
SELECT

customer_city,

COUNT(*) AS customers

FROM customers

GROUP BY customer_city

ORDER BY customers DESC

LIMIT 20;

-- Analysis5 - Payment Behavior
-- Business Question: Which payment method is most popular?
SELECT

payment_type,

COUNT(*) AS transactions,

ROUND(SUM(payment_value),2) AS revenue

FROM payments

GROUP BY payment_type

ORDER BY revenue DESC;

-- Installments
SELECT

payment_installments,

COUNT(*) AS transactions

FROM payments

GROUP BY payment_installments

ORDER BY payment_installments;

-- Analysis6 - Product Performance
-- Top Categories
SELECT

p.product_category_name,

ROUND(SUM(oi.price),2) AS revenue

FROM products p

JOIN order_items oi

ON p.product_id=oi.product_id

GROUP BY p.product_category_name

ORDER BY revenue DESC

LIMIT 15;

-- Highest Selling Products
SELECT

product_id,

COUNT(*) AS quantity_sold,

ROUND(SUM(price),2) AS revenue

FROM order_items

GROUP BY product_id

ORDER BY revenue DESC

LIMIT 20;

-- Analysis7 - Customer Lifetime Value
SELECT

o.customer_id,

ROUND(SUM(p.payment_value),2) AS lifetime_value

FROM orders o

JOIN payments p

ON o.order_id=p.order_id

GROUP BY o.customer_id

ORDER BY lifetime_value DESC

LIMIT 20;

-- Business Recommendation
-- Top customers should receive: loyalty rewards, special offers, personalized marketing

-- Analysis8 - Repeat Customers
-- Business Question: How many customers purchased more than once?
-- Joining the orders and customers tables and group by customer-unique-id
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- To find how many customers purchased more than once
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT c.customer_unique_id
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
) AS repeat;

-- Analysis9 - Delivery Performance
-- Average delivery time
SELECT

AVG(
order_delivered_customer_date 
- 
order_purchase_timestamp)

AS avg_delivery_days

FROM orders

WHERE order_delivered_customer_date
IS NOT NULL;

-- Average delivery time in days
SELECT
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400
        ),
        2
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- Business Insight: Delivery speed directly impacts customer satisfaction.

-- Analysis10 - Customer Reviews
-- Average review score
SELECT

AVG(review_score)

FROM reviews;

-- Distribution
SELECT

review_score,

COUNT(*)

FROM reviews

GROUP BY review_score

ORDER BY review_score;

-- Analysis11 - Revenue by State
SELECT

c.customer_state,

ROUND(

SUM(p.payment_value)

,2)

AS revenue

FROM customers c

JOIN orders o

ON c.customer_id=o.customer_id

JOIN payments p

ON o.order_id=p.order_id

GROUP BY customer_state

ORDER BY revenue DESC;

-- Analysis12 - Executive KPI Table
SELECT

(SELECT ROUND(SUM(payment_value),2) FROM payments) AS revenue,

(SELECT COUNT(*) FROM orders) AS orders,

(SELECT COUNT(*) FROM customers) AS customers,

(SELECT ROUND(AVG(payment_value),2) FROM payments) AS avg_payment;