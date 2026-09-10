-- Create Index
CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orders_purchase_date
ON orders(order_purchase_timestamp);

-- Products
CREATE INDEX idx_product_category
ON products(product_category_name);

-- Payments
CREATE INDEX idx_payment_order
ON payments(order_id);

-- Explain
EXPLAIN

SELECT *

FROM orders

WHERE customer_id='abc123';