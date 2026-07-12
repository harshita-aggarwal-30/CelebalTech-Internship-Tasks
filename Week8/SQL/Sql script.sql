
Part 3: SQL Analysis
-- E-Commerce Order Analytics System --
-- Create Database --


CREATE DATABASE IF NOT EXISTS ecommerce_order_analytics;

USE ecommerce_order_analytics;

USE ecommerce_order_analytics;

-- Customers Table --

CREATE TABLE customers (

    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_type VARCHAR(20)

);

-- Products Table --

CREATE TABLE products (

    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    cost_price DECIMAL(10,2)

);

-- Orders Table --

CREATE TABLE orders (

    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    order_date DATETIME,
    status VARCHAR(20),
    region_code VARCHAR(20),

    CONSTRAINT fk_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)

);

-- Order Items Table --

CREATE TABLE order_items (

    item_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_percent DECIMAL(5,2),

    CONSTRAINT fk_order
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    CONSTRAINT fk_product
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)

);

SHOW TABLES;

USE ecommerce_order_analytics;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;

Basic Queries :

1. Total revenue per category (revenue = quantity × unit_price × (1 - discount_percent/100))
SELECT
    p.category,
    SUM(
        oi.quantity *
        oi.unit_price *
        (1 - oi.discount_percent / 100)
    ) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

2. Top 10 customers by total order value 
SELECT
o.customer_id,
SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)) AS total_order_value
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY o.customer_id
ORDER BY total_order_value DESC
LIMIT 10;

3. Month-wise order count for the last 12 months 
SELECT
YEAR(order_date) AS year,
MONTH(order_date) AS month,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY YEAR(order_date),
 MONTH(order_date)
ORDER BY YEAR(order_date), 
MONTH(order_date);

Intermediate Queries :

4. Find customers who placed orders but never had any item delivered
SELECT DISTINCT
customer_id
FROM orders
WHERE customer_id NOT IN
(
SELECT customer_id
FROM orders
WHERE status='DELIVERED'
);

5. Products that were ordered but had more returns than purchases 
SELECT
    p.product_name,
    SUM(CASE WHEN o.status = 'RETURNED' THEN 1 ELSE 0 END) AS total_returns,
    SUM(CASE WHEN o.status <> 'RETURNED' THEN 1 ELSE 0 END) AS total_purchases
FROM products p
INNER JOIN order_items oi
ON p.product_id = oi.product_id
INNER JOIN orders o
ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name
HAVING total_returns > total_purchases
ORDER BY total_returns DESC;

6. Calculate the return rate (returned items / total items) per category 
SELECT
p.category,
SUM(CASE WHEN o.status='RETURNED' THEN 1 ELSE 0 END) AS returned_items,
COUNT(*) AS total_items,
ROUND(
(SUM(CASE WHEN o.status='RETURNED' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
2
) AS return_rate_percent
FROM products p
INNER JOIN order_items oi
ON p.product_id=oi.product_id
INNER JOIN orders o
ON oi.order_id=o.order_id
GROUP BY p.category
ORDER BY return_rate_percent DESC;

Advanced Queries (Window Functions, CTEs, Subqueries) :

7. Running Totals with Window Functions 
SELECT
o.region_code,
DATE(o.order_date) AS order_date,
SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)) AS daily_revenue,
SUM(SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)))
OVER(PARTITION BY o.region_code ORDER BY DATE(o.order_date)) AS running_total
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY o.region_code,DATE(o.order_date)
ORDER BY o.region_code,DATE(o.order_date); 

8. Ranking with DENSE_RANK 
SELECT
category,
product_name,
total_revenue,
DENSE_RANK() OVER(PARTITION BY category ORDER BY total_revenue DESC) AS rank_in_category
FROM
(
SELECT
p.category,
p.product_name,
SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.category,p.product_name
) AS revenue_data;

9. LAG/LEAD Analysis 
SELECT
customer_id,
order_date,
LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
DATEDIFF(order_date,
LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)
) AS days_gap
FROM orders;

10. CTE with Multiple Levels
WITH monthly_revenue AS
(
SELECT
o.customer_id,
DATE_FORMAT(o.order_date,'%Y-%m') AS month,
SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY o.customer_id,DATE_FORMAT(o.order_date,'%Y-%m')
)
SELECT
month,
CASE
WHEN revenue>10000 THEN 'High'
WHEN revenue BETWEEN 5000 AND 10000 THEN 'Medium'
ELSE 'Low'
END AS customer_category,
COUNT(*) AS total_customers
FROM monthly_revenue
GROUP BY month,customer_category;

11. NTILE for Segmentation 
SELECT
customer_id,
total_value,
NTILE(4) OVER(ORDER BY total_value DESC) AS quartile,
CASE
WHEN NTILE(4) OVER(ORDER BY total_value DESC)=1 THEN 'Platinum'
WHEN NTILE(4) OVER(ORDER BY total_value DESC)=2 THEN 'Gold'
WHEN NTILE(4) OVER(ORDER BY total_value DESC)=3 THEN 'Silver'
ELSE 'Bronze'
END AS quartile_label
FROM
(
SELECT
o.customer_id,
SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)) AS total_value
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY o.customer_id
) customer_value;

12. Year-over-Year Comparison
SELECT
YEAR(o.order_date) AS year,
p.category,
SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)) AS total_revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY YEAR(o.order_date),p.category
ORDER BY year,p.category;

13. First/Last Value Analysis 
SELECT
customer_id,
order_id,
order_date,
FIRST_VALUE(order_date) OVER(
PARTITION BY customer_id
ORDER BY order_date
) AS first_order,
LAST_VALUE(order_date) OVER(
PARTITION BY customer_id
ORDER BY order_date
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS last_order
FROM orders;

14. Cumulative Distribution 
SELECT
customer_id,
total_value,
CUME_DIST() OVER(ORDER BY total_value DESC) AS cumulative_distribution
FROM
(
SELECT
o.customer_id,
SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)) AS total_value
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY o.customer_id
) customer_value;

15. Complex CTE: Cohort Analysis 
SELECT
DATE_FORMAT(c.registration_date,'%Y-%m') AS cohort_month,
COUNT(DISTINCT c.customer_id) AS total_customers,
COUNT(DISTINCT o.customer_id) AS customers_with_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY DATE_FORMAT(c.registration_date,'%Y-%m')
ORDER BY cohort_month;

16. Self-Join with Window Function 
WITH order_value AS
(
SELECT
o.customer_id,
o.order_id,
o.order_date,
SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100)) AS order_value
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY o.customer_id,o.order_id,o.order_date
)
SELECT
customer_id,
order_id,
order_date,
order_value,
LAG(order_value) OVER(
PARTITION BY customer_id
ORDER BY order_date
) AS previous_order_value
FROM order_value;