-- Dashboard Views
-- KPI View
CREATE OR REPLACE VIEW vw_kpis AS
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    ROUND(SUM(p.payment_value), 2) AS revenue,
    ROUND(AVG(p.payment_value), 2) AS avg_payment
FROM orders AS o
JOIN payments AS p
    ON o.order_id = p.order_id;

-- Test The View
SELECT *
FROM vw_kpis;

-- Monthly Sales View
CREATE OR REPLACE VIEW vw_monthly_sales AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS sales_month,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders AS o
JOIN payments AS p
    ON o.order_id = p.order_id
GROUP BY sales_month
ORDER BY sales_month;

-- Test The View
SELECT *
FROM vw_monthly_sales;

-- Customer Revenue View
CREATE OR REPLACE VIEW vw_customer_revenue AS

SELECT

customer_id,

ROUND(
SUM(payment_value),2
) revenue

FROM orders o

JOIN payments p

ON o.order_id=p.order_id

GROUP BY customer_id;

-- Test The View
SELECT *
FROM vw_customer_revenue;

-- Category Revenue View
CREATE OR REPLACE VIEW vw_category_sales AS

SELECT

product_category_name,

ROUND(
SUM(price),2
) revenue

FROM products p

JOIN order_items oi

ON p.product_id=oi.product_id

GROUP BY product_category_name;

-- Test The View
SELECT *
FROM vw_category_sales;

-- Customer Analysis
-- View 1 — Customer Summary
CREATE OR REPLACE VIEW vw_customer_summary AS

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(AVG(p.payment_value), 2) AS average_order_value,
    MIN(o.order_purchase_timestamp) AS first_purchase,
    MAX(o.order_purchase_timestamp) AS last_purchase

FROM orders o

JOIN payments p
    ON o.order_id = p.order_id

WHERE o.order_status = 'delivered'

GROUP BY o.customer_id;

-- Test the View
SELECT *
FROM vw_customer_summary
ORDER BY total_revenue DESC
LIMIT 20;

-- Customer Segments
CREATE OR REPLACE VIEW vw_customer_segments AS

SELECT
    customer_id,
    total_orders,
    total_revenue,
    average_order_value,

    CASE
        WHEN total_revenue >= 1000 THEN 'VIP'
        WHEN total_revenue >= 500 THEN 'Premium'
        WHEN total_revenue >= 200 THEN 'Regular'
        ELSE 'Low Value'
    END AS customer_segment

FROM vw_customer_summary;

-- Test The View
SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS revenue
FROM vw_customer_segments
GROUP BY customer_segment
ORDER BY revenue DESC;

-- Product Analysis
-- View 2 — Category Performance
CREATE OR REPLACE VIEW vw_category_performance AS

SELECT
    p.product_category_name,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    COUNT(*) AS items_sold,

    ROUND(SUM(oi.price), 2) AS product_revenue,

    ROUND(SUM(oi.freight_value), 2) AS freight_revenue,

    ROUND(AVG(oi.price), 2) AS average_item_price

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'delivered'

GROUP BY p.product_category_name;

-- Test The View
SELECT *
FROM vw_category_performance
ORDER BY product_revenue DESC;

-- Top Products
CREATE OR REPLACE VIEW vw_product_performance AS

SELECT
    oi.product_id,
    p.product_category_name,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    COUNT(*) AS units_sold,

    ROUND(SUM(oi.price), 2) AS product_revenue,

    ROUND(AVG(oi.price), 2) AS average_price

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'delivered'

GROUP BY
    oi.product_id,
    p.product_category_name;
	
-- Test The View
SELECT *
FROM vw_product_performance
ORDER BY product_revenue DESC
LIMIT 20;

-- Operations Analysis
-- View 3 — Order Status
CREATE OR REPLACE VIEW vw_order_status AS

SELECT
    order_status,
    COUNT(*) AS total_orders

FROM orders

GROUP BY order_status;

-- Test The View
SELECT *
FROM vw_order_status
ORDER BY total_orders DESC;

-- Delivery Performance
CREATE OR REPLACE VIEW vw_delivery_performance AS

SELECT

    DATE_TRUNC(
        'month',
        order_purchase_timestamp
    ) AS purchase_month,

    COUNT(*) AS total_delivered_orders,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS average_delivery_days,

    SUM(
        CASE
            WHEN order_delivered_customer_date
                 > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN order_delivered_customer_date
                     > order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        )
        / COUNT(*),
        2
    ) AS late_delivery_rate

FROM orders

WHERE
    order_status = 'delivered'

    AND order_delivered_customer_date IS NOT NULL

    AND order_purchase_timestamp IS NOT NULL

GROUP BY purchase_month

ORDER BY purchase_month;

-- Test The View
SELECT *
FROM vw_delivery_performance;

-- Payment Methods
CREATE OR REPLACE VIEW vw_payment_methods AS

SELECT

    payment_type,

    COUNT(*) AS total_transactions,

    ROUND(SUM(payment_value), 2) AS total_payment_value,

    ROUND(AVG(payment_value), 2) AS average_payment_value

FROM payments

GROUP BY payment_type;

-- Test The View
SELECT *
FROM vw_payment_methods
ORDER BY total_payment_value DESC;

-- Review Scores
CREATE OR REPLACE VIEW vw_review_scores AS

SELECT

    review_score,

    COUNT(*) AS total_reviews,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS review_percentage

FROM reviews

GROUP BY review_score

ORDER BY review_score;

-- Test The View
SELECT *
FROM vw_review_scores;

-- Delivery vs Review Score
-- Question: "Do late deliveries appear to be associated with lower customer ratings?"
CREATE OR REPLACE VIEW vw_delivery_review_analysis AS

SELECT

    CASE
        WHEN o.order_delivered_customer_date
             > o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(AVG(r.review_score), 2) AS average_review_score

FROM orders o

JOIN reviews r
    ON o.order_id = r.order_id

WHERE
    o.order_status = 'delivered'

    AND o.order_delivered_customer_date IS NOT NULL

    AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY delivery_status;

-- Test The View
SELECT *
FROM vw_delivery_review_analysis;