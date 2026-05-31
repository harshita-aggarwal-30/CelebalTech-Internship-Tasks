-- Creating database --
Create database Celebal;

-- use database --
Use Celebal;

-- create tabe in database --
CREATE TABLE customers ( 
    customer_id   INT           PRIMARY KEY, 
    first_name    VARCHAR(50)   NOT NULL, 
    last_name     VARCHAR(50)   NOT NULL, 
    email         VARCHAR(100)  UNIQUE NOT NULL, 
    city          VARCHAR(50)   NOT NULL, 
    state         VARCHAR(50)   NOT NULL, 
    join_date     DATE          NOT NULL, 
    is_premium    BOOLEAN       DEFAULT FALSE 
);

CREATE INDEX idx_customers_city ON customers(city);

CREATE INDEX idx_customers_state ON customers(state);

-- inserting data into table --
INSERT INTO customers VALUES 
(101, 'Aarav',  'Sharma', 'aarav.s@email.com',  'Mumbai',    'Maharashtra', '2024-01-15', TRUE), 
(102, 'Priya',  'Patel',  'priya.p@email.com',  'Ahmedabad', 'Gujarat',     '2024-02-20', FALSE), 
(103, 'Rohan',  'Gupta',  'rohan.g@email.com',  'Delhi',     'Delhi',       '2024-03-10', TRUE), 
(104, 'Sneha',  'Reddy',  'sneha.r@email.com',  'Hyderabad', 'Telangana',   '2024-04-05', FALSE), 
(105, 'Vikram', 'Singh',  'vikram.s@email.com', 'Jaipur',    'Rajasthan',   '2024-05-12', TRUE), 
(106, 'Ananya', 'Iyer',   'ananya.i@email.com', 'Chennai',   'Tamil Nadu',  '2024-06-18', FALSE), 
(107, 'Karan',  'Mehta',  'karan.m@email.com',  'Pune',      'Maharashtra', '2024-07-22', TRUE), 
(108, 'Divya',  'Nair',   'divya.n@email.com',  'Kochi',     'Kerala',      '2024-08-30', FALSE);

Select  * from customers;

-- table 2 --
CREATE TABLE products ( 
    
product_id    INT           PRIMARY KEY, 
    product_name  VARCHAR(100)  NOT NULL, 
    category      VARCHAR(50)   NOT NULL, 
    brand         VARCHAR(50)   NOT NULL, 
    unit_price    DECIMAL(10,2) NOT NULL  CHECK (unit_price > 0), 
    stock_qty     INT           NOT NULL  DEFAULT 0  CHECK (stock_qty >= 0) 
);

CREATE INDEX idx_products_category ON products(category);

INSERT INTO products VALUES 
(201, 'Wireless Earbuds',     'Electronics', 'BoAt',          1499.00, 250), 
(202, 'Cotton T-Shirt',       'Clothing',    'Levis',         799.00,  500), 
(203, 'Smart Watch',          'Electronics', 'Noise',         2999.00, 150), 
(204, 'Running Shoes',        'Clothing',    'Nike',          4599.00, 120), 
(205, 'Bluetooth Speaker',    'Electronics', 'JBL',           3499.00, 200), 
(206, 'Bedsheet Set',         'Home',        'Spaces',        1299.00, 300), 
(207, 'Laptop Stand',         'Electronics', 'AmazonBasics',  899.00,  180), 
(208, 'Cushion Covers (Set)', 'Home',        'HomeCenter',    599.00,  400);

Select * from products;

-- table 3 --
CREATE TABLE orders ( 
    order_id      INT           PRIMARY KEY, 
    customer_id   INT           NOT NULL, 
    order_date    DATE          NOT NULL, 
    status        VARCHAR(20)   NOT NULL  DEFAULT 'Pending' 
                  CHECK (status IN ('Pending','Shipped','Delivered','Cancelled')), 
    total_amount  DECIMAL(12,2) NOT NULL  CHECK (total_amount >= 0), 
     
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);

CREATE INDEX idx_orders_date ON orders(order_date); 
CREATE INDEX idx_orders_status ON orders(status);

INSERT INTO orders VALUES 
(1001, 101, '2024-08-01', 'Delivered',  4498.00), 
(1002, 102, '2024-08-03', 'Delivered',  799.00), 
(1003, 103, '2024-08-05', 'Shipped',    7498.00), 
(1004, 101, '2024-08-10', 'Delivered',  3499.00), 
(1005, 104, '2024-08-12', 'Cancelled',  2999.00), 
(1006, 105, '2024-08-15', 'Delivered',  5898.00), 
(1007, 106, '2024-08-18', 'Pending',    1299.00), 
(1008, 103, '2024-08-20', 'Delivered',  899.00), 
(1009, 107, '2024-08-25', 'Shipped',    6098.00), 
(1010, 108, '2024-08-28', 'Delivered',  1598.00); 

Select * from orders;

-- table 4 --
CREATE TABLE order_items ( 
    item_id       INT           PRIMARY KEY, 
    order_id      INT           NOT NULL, 
    product_id    INT           NOT NULL, 
    quantity      INT           NOT NULL  CHECK (quantity > 0), 
    unit_price    DECIMAL(10,2) NOT NULL  CHECK (unit_price > 0), 
    discount_pct  DECIMAL(5,2)  DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100), 
     
    FOREIGN KEY (order_id)   REFERENCES orders(order_id), 
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
); 

INSERT INTO order_items VALUES 
(5001, 1001, 201, 2, 1499.00, 0), 
(5002, 1001, 207, 1, 899.00,  10), 
(5003, 1002, 202, 1, 799.00,  0), 
(5004, 1003, 203, 1, 2999.00, 0), 
(5005, 1003, 204, 1, 4599.00, 5), 
(5006, 1004, 205, 1, 3499.00, 0), 
(5007, 1005, 203, 1, 2999.00, 0), 
(5008, 1006, 201, 1, 1499.00, 10), 
(5009, 1006, 204, 1, 4599.00, 5), 
(5010, 1007, 206, 1, 1299.00, 0), 
(5011, 1008, 207, 1, 899.00,  0), 
(5012, 1009, 205, 1, 3499.00, 0), 
(5013, 1009, 208, 2, 599.00,  15), 
(5014, 1010, 206, 1, 1299.00, 0), 
(5015, 1010, 208, 1, 599.00,  0);

select * from order_items;

-- now here the all queries corresponds to questions --

-- Section A — SQL Basics (SELECT, Constraints, Primary Keys) --

-- Q1. Write a query to display all columns and rows from the customer's table. --
Select * From customers;

-- Q2. Retrieve only the first_name, last_name, and city of all customers. --
select
	first_name,
    last_name,
    city
From customers;

-- Q3. List all unique categories available in the products table.  --
Select Distinct 
    category
from products;

-- Q4. Identify the Primary Key of each table in the schema. Explain why a Primary Key must be unique and NOT NULL. --
show tables;
describe customers;
IN this customer_id	= PRI
 
describe orders;
IN this order_id	= PRI

describe products;
IN this product_id = PRI

describe order_items;
IN this item_id	= PRI 

Primary key must be unique to ensure that each row has is identifiabe seprately and each row has a seprate and unique identity.it ensures that redudandancy must not be there.
It must not be null to ensures that each row has an identity as it is used as a reference column in another table . 
They together make ensures that the data must be accurate.


-- Q5. What constraints are applied to the email column in the customers table? What would happen if you tried to insert a duplicate email? --
UNIQUE constraint is applied to the email column to ensures that the no repeated data or email address must be there or to avoid redudancy. 
NOT NULL is also used sometimes to ensure that every email has a  email value.
SO, we use unique and not null constraints to avoid duplicate values and to ensure that every row has a  value .
IF we tried to enter it will instantly give a error:"Error : Duplicate entry "
ex- 
create table Tech(
 email varchar(78) unique not null);
insert into tech values ('harshita638@gmail.com'),('huwyddd928@gmail.com'),('harshita638@gmail.com');

So in above example i tried to enter a duplicate value and i recieve a error i.e:"Error Code: 1062. Duplicate entry 'harshita638@gmail.com' for key 'tech.email'	0.000 sec"

-- Q6. Try inserting a product with unit_price = -50. What happens and which constraint prevents it? Write both the INSERT statement and explain the error. --
WE cant insert -50 as a unit_price here, iF we tried to do so it will return an error .
    Check constarint willl prevent it.
    As in products table we applied 
    check (unit_price > 0),
    so it will check the condition if condition is not get fulfilled it will not allow us to insert that value and immediatly return an error.
    ex=
 for unit_price=-50:-
INSERT INTO products 
    (product_id, product_name, category, brand, unit_price, stock_qty) 
VALUES
    (101, 'Laptop', 'Electronics', 'Dell', -50, 10);
    
IT gives an error i.e:"Error Code: 3819. Check constraint 'products_chk_1' is violated."
 check (unit_price > 0),
This condition ensures that the unit_price should be greater than 0 if any value less than 0 will get insert the database will not allow us to insert that data in table.
    
-- Section B — Filtering & Optimization (WHERE, Indexes) --

-- Q7. Retrieve all orders with status = 'Delivered'. --
select * from orders
where status = 'Delivered';

-- Q8. Find all products in the 'Electronics' category with a unit_price greater than ₹2000. --
Select * FRom products
Where category = 'Electronics' AND unit_price > 2000;

-- Q9. List all customers who joined in the year 2024 and belong to the state 'Maharashtra' --
select *from customers
where state = 'Maharashtra' AND year(join_date) = 2024;

-- Q10. Find all orders placed between '2024-08-10' and '2024-08-25' (inclusive) that are NOT cancelled. --
Select * from orders
Where status != 'Cancelled' And order_date between '2024-08-10' AND '2024-08-25';

-- Q11. Explain what the index idx_orders_date does. How would it improve the performance of a query that filters orders by order_date? Write a sample query that would benefit from this index. --
The idx_orders_date helps find the order date fast and easily . it is created on the order_date column of the order column. 
Instead of scanning every row in the table, the database can quickly locate matching records using the index, making queries faster, especially for large datasets.
ex-
SELECT * FROM orders
 WHERE order_date = '2024-08-15';
 
 -- Q12. If you run: SELECT * FROM customers WHERE YEAR(join_date) = 2024; — would the index on join_date be used? Explain why or why not, and rewrite the query to be index-friendly (SARGable). --
 SELECT * FROM customers 
 WHERE YEAR(join_date) = 2024;
 No the index on join_date will not be used. the database has to chk every row to find match.
 this is because we used year function in this.
 we have to make it index friendly to make it execute faster.
 query-
 Select * from orders
Where status != 'Cancelled' And order_date between '2024-08-10' AND '2024-08-25';
This query is fast because the databse will directly check  in the order_date column and fetch the result.


-- Section C — Aggregation (GROUP BY, SUM, COUNT, AVG, MIN, MAX) --

-- Q13. Count the total number of orders in the orders table. --
Select 
	Count(order_id) as total_orders
from orders;

-- Q14. Find the total revenue (SUM of total_amount) from all 'Delivered' orders. --
select 
	status,
	sum(total_amount) as revenue
from orders
Where status = 'Delivered';

-- Q15. Calculate the average unit_price of products in each category. --
select 
	category,
    avg(unit_price) as avg_price
from products
GROUP BY Category;

-- Q16. For each order status, find the count of orders and the total revenue. Sort the result by total revenue in descending order. --
select
	status,
    count(order_id) as total_orders,
    sum(total_amount) as total_revenue
from orders
group  by status
order by total_revenue desc;

-- Q17. Find the most expensive (MAX) and cheapest (MIN) product in each category. --
SELECT
	category,
	MAX(product_name) AS expensive_product,
	MAX(unit_price) AS expensive_price,
	MIN(product_name) AS cheapest_product,
	MIN(unit_price) AS cheapest_price
FROM products
GROUP BY category;

-- Q18. List all product categories where the average unit_price is greater than ₹2000. (Hint: Use HAVING clause) --
SELECT
	category,
	AVG(unit_price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;

-- Section D — Joins & Relationships --

-- Q19. Write an INNER JOIN query to display each order along with the customer's first_name and last_name. Show: order_id, order_date, first_name, last_name, total_amount. --
SELECT
	o.order_id,
	o.order_date,
	c.first_name,
	c.last_name,
	o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- Q20. Using a LEFT JOIN, list ALL customers and their orders (if any). Customers with no orders should still appear with NULL values for order columns. --	
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	o.order_id,
	o.order_date,
	o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- Q21. Write a query using JOINs across three tables (orders → order_items → products) to show: order_id, product_name, quantity, unit_price, and discount_pct for each order item. --
SELECT
	o.order_id,
	p.product_name,
	oi.quantity,
	oi.unit_price,
	oi.discount_pct
FROM orders o
	INNER JOIN order_items oi
ON o.order_id = oi.order_id
	INNER JOIN products p
ON oi.product_id = p.product_id;

-- Q22. Explain the difference between LEFT JOIN and RIGHT JOIN with an example from this schema. When would you use a FULL OUTER JOIN? --
A `LEFT JOIN` returns all records from the left table and matching records from the right table.
If there is no matching data in the right table, `NULL` values are shown.

Example:
SELECT
	c.first_name,
	o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

This query shows all customers, even if they have no orders.

A `RIGHT JOIN` returns all records from the right table and matching records from the left table.
If there is no matching data in the left table, `NULL` values are shown.

Example:
SELECT
	c.first_name,
	o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;
This query shows all orders, even if customer details are missing.

A `FULL OUTER JOIN` is used when we want all records from both tables, including matching and non-matching rows.
It is useful when we want complete data from both tables. MySQL does not directly support `FULL OUTER JOIN`.

-- Q23. Identify all Foreign Key relationships in the schema. Explain what would happen if you tried to insert an order with customer_id = 999 (which doesn't exist in customers).--
SELECT 
    TABLE_NAME AS child_table,
    COLUMN_NAME AS foreign_key_column,
    REFERENCED_TABLE_NAME AS parent_table,
    REFERENCED_COLUMN_NAME AS referenced_column
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    REFERENCED_TABLE_NAME IS NOT NULL
    AND TABLE_SCHEMA = DATABASE();

Foreign Key Relationships in the Schema:-

orders.customer_id → customers.customer_id
order_items.order_id → orders.order_id
order_items.product_id → products.product_id

A Foreign Key is used to connect tables and maintain relationships between them.

Example:
INSERT INTO orders
VALUES (1011, 999, '2024-09-01', 'Pending', 1000);

If we try to insert an order with customer_id = 999, the database will return an error because this customer ID does not exist in the customers table.
This happens due to the Foreign Key constraint, which prevents invalid data from being inserted and maintains data consistency between related tables.

-- Section E — Advanced Concepts (CASE, ACID, Transactions) --

/* Q24. Write a query using CASE to classify products into price tiers: 
  • 'Budget'    → unit_price < 1000 
  • 'Mid-Range' → unit_price BETWEEN 1000 AND 3000 
  • 'Premium'   → unit_price > 3000 
Display: product_name, unit_price, price_tier. */
SELECT
	product_name,
	unit_price,
CASE
	WHEN unit_price < 1000 THEN 'Budget'
	WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
	ELSE 'Premium'
END AS price_tier
FROM products;

-- Q25. Using a CASE statement inside an aggregate function, count how many orders are 'Delivered' vs 'Not Delivered' (all other statuses). Display the result in a single row. --
select * from orders;
SELECT
COUNT(
    CASE
        WHEN status = 'Delivered' THEN 1
    END
) AS delivered_orders,

COUNT(
    CASE
        WHEN status != 'Delivered' THEN 1
    END
) AS not_delivered_orders

FROM orders;

/* Q26. Explain each letter of ACID: 
  • A – Atomicity 
  • C – Consistency 
  • I – Isolation 
  • D – Durability 
Give a real-world example (e.g., bank transfer) showing why each property is important. */
A – Atomicity:
Atomicity means “all or nothing.” For example, in a bank transfer, money should be deducted from one account and added to another together. If one step fails, the whole process is cancelled.
example:
START TRANSACTION;

INSERT INTO orders
VALUES (1911, 102, '2024-09-01', 'Pending', 1500);
select * from orders;
ROLLBACK;

C – Consistency:
Consistency means data remains correct and valid before and after a transaction. For example, account balances should remain accurate.
example:
INSERT INTO products
VALUES
(301, 'Laptop', 'Electronics', 'Dell', -50, 10);
error because rule:- CHECK (unit_price > 0)

I – Isolation:
Isolation means multiple transactions happen independently without affecting each other. For example, two people withdrawing money at the same time should not create incorrect balance calculations.
example:
START TRANSACTION;

UPDATE orders
SET total_amount = 2000
WHERE order_id = 1001;
select * from orders;

D – Durability:
Durability means once a transaction is saved, it stays saved permanently even if the system crashes or power fails.
example:
START TRANSACTION;

INSERT INTO orders
VALUES
(1171, 102, '2024-09-01', 'Pending', 1500);
select * from orders;
COMMIT;
COMMIT permanently saves the transaction..

/* Q27. Write a SQL transaction that does the following atomically: 
  1. Insert a new order (order_id=1011, customer_id=102, today's date, 'Pending', 1598.00) 
  2. Insert two order items for that order 
  3. Update the stock_qty of the purchased products 
  4. If any step fails, ROLLBACK the entire transaction. Otherwise, COMMIT. 
Write the complete BEGIN...COMMIT/ROLLBACK block. */
START TRANSACTION;

-- 1. Insert a new order (order_id=1011, customer_id=102, today's date, 'Pending', 1598.00) --
INSERT INTO orders
VALUES
(1011, 102, CURDATE(), 'Pending', 1598.00);
select * from orders;

-- 2. Insert two order items for that order --
-- Insert first order item --
INSERT INTO order_items
VALUES
(5016, 1011, 206, 1, 1299.00, 0);
select * from order_items;

-- Insert second order item --
INSERT INTO order_items
VALUES
(5017, 1011, 208, 1, 299.00, 0);
select * from order_items;

-- 3. Update the stock_qty of the purchased products  --
UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 206;

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 208;

--  4. If any step fails, ROLLBACK the entire transaction. Otherwise, COMMIT. --
-- Save changes --
COMMIT;

-- If any step fails --
ROLLBACK;



