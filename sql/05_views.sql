-- Part 10 – SQL Views
CREATE VIEW vw_customer_revenue AS

SELECT

customer_id,

SUM(payment_value) revenue

FROM orders o

JOIN payments p

ON o.order_id=p.order_id

GROUP BY customer_id;

-- now
SELECT *

FROM vw_customer_revenue

ORDER BY revenue DESC;

-- Part 11 – Build an Analytics Data Mart
-- Create another view.
-- Later, Power BI will connect directly to this view.
CREATE VIEW executive_dashboard AS

SELECT

COUNT(DISTINCT o.order_id) total_orders,

COUNT(DISTINCT customer_id) total_customers,

ROUND(SUM(payment_value),2) revenue,

ROUND(AVG(payment_value),2) avg_order

FROM orders o

JOIN payments p

ON o.order_id=p.order_id;