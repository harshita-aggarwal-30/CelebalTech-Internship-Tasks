-- Creating Database --
Create database intern;

-- Use database --
use intern;

-- Step 1: Setup Data 
-- 1.Import the Superstore dataset into a table named superstore_raw.  --
We set up data using table data import Wizard (Drag and Drop).
Steps:tables-> table data import wizard-> Browse-> Finish.

-- Showing data of csv file that i imported -- 
select *from superstore_raw;

-- Create these 3 tables from it:  
   1.customers:-
   
CREATE TABLE customers (
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    Postal_Code VARCHAR(20),
    region VARCHAR(50)
);

2.products:-

CREATE TABLE products (
    Product_ID VARCHAR(30),
    category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(255)
);

3.orders:-

CREATE TABLE orders (
    Row_ID INT,
    Order_ID VARCHAR(30),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(30),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)
);

-- Insert data into these tables using SELECT DISTINCT. --
1.For customers:-

INSERT INTO customers
SELECT DISTINCT
    Customer_ID,
    Customer_Name,
    segment,
    country,
    city,
    state,
    Postal_Code,
    region
FROM superstore_raw;
-- To show data --
select * from customers;

2.for products:-

INSERT INTO products
SELECT DISTINCT
    Product_ID,
    Category,
    Sub_Category,
    Product_Name
FROM superstore_raw;
select * from products;
3.for orders:-

INSERT INTO orders
SELECT DISTINCT
    Row_ID,
    Order_ID,
    str_to_date(Order_Date, '%m/%d/%Y'), 
	str_to_date(Ship_Date, '%m/%d/%Y'),
    Ship_Mode,
    Customer_ID,
    Product_ID,
    sales,
    quantity,
    discount,
    profit
FROM superstore_raw;
select * from orders;

-- Step 2: Perform Required Queries --

-- 1.Find all orders where sales are greater than the average sales. (Subquery)  --
SELECT *
FROM orders
WHERE sales > (
    SELECT AVG(sales)
    FROM orders
);

-- 2.Find the highest sales order for each customer. (Subquery)  --
SELECT * FROM orders o
WHERE sales = (
    SELECT MAX(sales)
    FROM orders
    WHERE Customer_ID = o.Customer_ID
) limit 5;


-- 3.Calculate total sales for each customer. (CTE)   --
WITH customer_sales AS
(
    SELECT
	customer_id,
	SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales;

-- 4.Find customers whose total sales are above average. (CTE + Subquery)   --
WITH customer_sales AS(
    SELECT 
		customer_id,
		SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales >(
    SELECT AVG(total_sales)
    FROM customer_sales
);

-- 5.Rank all customers based on total sales. (Window Function)--
WITH customer_sales AS(
    SELECT 
		customer_id,
		SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)SELECT 
	customer_id,
	total_sales,
	RANK() OVER(ORDER BY total_sales DESC) AS sales_rank
FROM customer_sales;

-- 6.Assign row numbers to each order within a customer. (Window Function + PARTITION BY)   -- 
SELECT 
	customer_id,
	order_id,
	sales,
	ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY sales DESC) AS row_num
FROM orders;

-- 7.Display top 3 customers based on total sales. (Window Function)   -- 
WITH customer_sales AS(
    SELECT 
		customer_id,
		SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)SELECT *FROM(
    SELECT 
		customer_id,
		total_sales,
		RANK() OVER(ORDER BY total_sales DESC) AS sales_rank FROM customer_sales) ranked_customers
WHERE sales_rank <= 3;

-- Step 3: Final Combined Query -- 

-- Write one final query that shows: 
-- Customer Name  
-- Total Sales  
-- Rank  
-- (Use JOIN + CTE + Window Function together) -- 

WITH customer_sales AS(
    SELECT
		c.customer_name,
		SUM(o.sales) AS total_sales
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
)SELECT 
	customer_name,
	total_sales,RANK() OVER(ORDER BY total_sales DESC) AS sales_rank FROM customer_sales;

-- Mini Project: Customer Sales Insights --

-- 1.Who are the top 5 customers?  --
SELECT
	c.customer_name,
	SUM(o.sales) AS total_sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC
LIMIT 5;

-- 2.Who are the bottom 5 customers?  --
SELECT 
	c.customer_name,
	SUM(o.sales) AS total_sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_sales ASC
LIMIT 5;

-- 3.Which customers made only one order?   -- 
SELECT 
	customer_id,
	COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) = 1;

-- 4.Which customers have above-average sales?   --
WITH customer_sales AS(
    SELECT 
		customer_id,
		SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales >(SELECT AVG(total_sales)FROM customer_sales);

-- 5.What is the highest order value per customer?  --
SELECT
	customer_id,
	MAX(sales) AS highest_order_value
FROM orders
GROUP BY customer_id;