-- Part 1 — Customer Segmentation
-- Step 1 — Monetary Value
-- Business Question: Who spends the most money?
SELECT
    o.customer_id,
    ROUND(SUM(p.payment_value),2) AS monetary_value
FROM orders o
JOIN payments p
ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY monetary_value DESC;

-- Step 2 — Frequency
-- Business Question: Who orders most often?
SELECT
    customer_id,
    COUNT(order_id) AS frequency
FROM orders
GROUP BY customer_id
ORDER BY frequency DESC;

-- Step 3 — Recency
-- Business Question: How recently did the customer purchase?
SELECT
    customer_id,
    MAX(order_purchase_timestamp) AS last_purchase
FROM orders
GROUP BY customer_id
ORDER BY last_purchase DESC;


-- Part 2 – Customer Segmentation
SELECT
    customer_id,
    SUM(payment_value) AS spending,

    CASE
        WHEN SUM(payment_value) >= 1000 THEN 'VIP'
        WHEN SUM(payment_value) >= 500 THEN 'Premium'
        ELSE 'Regular'
    END AS customer_segment

FROM orders o

JOIN payments p
ON o.order_id = p.order_id

GROUP BY customer_id;


-- Part 3 – Customer Lifetime Value
-- "How much revenue does each customer generate?"
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS revenue,
    ROUND(
        SUM(p.payment_value) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN payments AS p
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC;

-- Part 4 – Monthly New Customers
-- Business Question: How many new customers joined every month?
WITH first_purchase AS (

SELECT

customer_id,

MIN(order_purchase_timestamp) first_order

FROM orders

GROUP BY customer_id

)

SELECT

DATE_TRUNC('month',first_order) AS month,

COUNT(*) AS new_customers

FROM first_purchase

GROUP BY month

ORDER BY month;

-- Part 5 – Monthly Active Customers
SELECT

DATE_TRUNC('month',order_purchase_timestamp) AS month,

COUNT(DISTINCT customer_id) active_customers

FROM orders

GROUP BY month

ORDER BY month;

-- Part 6 – Revenue Growth
-- Monthly revenue
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS revenue_month,
    SUM(p.payment_value) AS revenue
FROM orders AS o
JOIN payments AS p
    ON o.order_id = p.order_id
GROUP BY revenue_month
ORDER BY revenue_month;

-- "How much did revenue grow compared with the previous month?" By using LAG() 
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS revenue_month,
        SUM(p.payment_value) AS revenue
    FROM orders AS o
    JOIN payments AS p
        ON o.order_id = p.order_id
    GROUP BY revenue_month
)

SELECT
    revenue_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue - LAG(revenue) OVER (ORDER BY revenue_month),
        2
    ) AS revenue_change
FROM monthly_revenue
ORDER BY revenue_month;

-- Now calcualte growth:
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS revenue_month,
        SUM(p.payment_value) AS revenue
    FROM orders AS o
    JOIN payments AS p
        ON o.order_id = p.order_id
    GROUP BY revenue_month
)

SELECT
    revenue_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (
            revenue - LAG(revenue) OVER (ORDER BY revenue_month)
        )
        /
        LAG(revenue) OVER (ORDER BY revenue_month)
        * 100,
        2
    ) AS growth_percent
FROM monthly_sales
ORDER BY revenue_month;

-- Part 7 – Product Ranking
-- Business Question: Which product categories are the most profitable?
SELECT

product_category_name,

SUM(price) revenue,

RANK()

OVER(

ORDER BY SUM(price) DESC

)

ranking

FROM products p

JOIN order_items oi

ON p.product_id=oi.product_id

GROUP BY product_category_name;

-- Part 8 – Delivery Analysis
-- Average delivery days
SELECT
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
    ) AS delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- Late Deliveries
-- Business Insight: Late deliveries usually reduce customer satisfaction.
SELECT

COUNT(*) delayed_orders

FROM orders

WHERE order_delivered_customer_date>

order_estimated_delivery_date;

-- Part 9 – Customer Satisfaction
-- Average Review Score
SELECT

AVG(review_score)

FROM reviews;

-- Reviews by Score
SELECT

review_score,

COUNT(*)

FROM reviews

GROUP BY review_score

ORDER BY review_score;

-- Business Question: Do late deliveries receive worse reviews?
SELECT

CASE

WHEN order_delivered_customer_date>

order_estimated_delivery_date

THEN 'Late'

ELSE 'On Time'

END delivery_status,

AVG(review_score)

FROM orders o

JOIN reviews r

ON o.order_id=r.order_id

GROUP BY delivery_status;

