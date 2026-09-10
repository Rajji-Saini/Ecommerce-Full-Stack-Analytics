-- Importing csv file in each table

-- customers data
COPY customers
FROM 'D:\Data Analytics Bootcamp\GitHub Projects\Ecommerce-Full-Stack-Analytics\data\olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;
-- Validating data
SELECT COUNT(*) FROM customers;

-- Products data
COPY products
FROM 'D:\Data Analytics Bootcamp\GitHub Projects\Ecommerce-Full-Stack-Analytics\data\olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;
-- Validate data
SELECT COUNT(*) FROM products;

-- Orders data
COPY orders
FROM 'D:\Data Analytics Bootcamp\GitHub Projects\Ecommerce-Full-Stack-Analytics\data\olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;
-- Validate data
SELECT COUNT(*) FROM orders;

-- Payments data
COPY payments
FROM 'D:\Data Analytics Bootcamp\GitHub Projects\Ecommerce-Full-Stack-Analytics\data\olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;
-- Validate data
SELECT COUNT(*) FROM payments;

-- Reviews data
COPY reviews
FROM 'D:\Data Analytics Bootcamp\GitHub Projects\Ecommerce-Full-Stack-Analytics\data\olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;
-- Validate data
SELECT COUNT(*) FROM reviews;

-- Order_items data
COPY order_items
FROM 'D:\Data Analytics Bootcamp\GitHub Projects\Ecommerce-Full-Stack-Analytics\data\olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;
-- Validate data
SELECT COUNT(*) FROM order_items;


-- Verifying Relationships
SELECT
    o.order_id,
    c.customer_city,
    o.order_status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
LIMIT 10;