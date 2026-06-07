# Week 3 – SQL Data Analysis Project

## Project Overview

This project focuses on data import, database normalization, and analytical SQL query development using the Superstore dataset. The objective was to transform raw transactional data into a structured relational database and generate meaningful business insights through SQL.

## Tasks Performed

### 1. Data Import and Preparation

* Imported the Superstore dataset into a raw staging table named `superstore_raw`.
* Verified data quality and column structure.
* Created a dedicated database for the project.

### 2. Database Design

Normalized the dataset by creating the following tables:

* **customers** – Stores customer-related information.
* **products** – Stores product-related information.
* **orders** – Stores transactional order details.

Data was transferred from the raw dataset into these tables using `SELECT DISTINCT` to eliminate duplicate records and maintain data integrity.

### 3. SQL Query Implementation

The following SQL concepts were implemented:

#### Subqueries

* Orders with sales greater than average sales.
* Highest sales order for each customer.

#### Common Table Expressions (CTEs)

* Total sales calculation for each customer.
* Identification of customers with above-average sales.

#### Window Functions

* Customer ranking based on total sales.
* Row numbering of orders within each customer group using `PARTITION BY`.
* Top-performing customers based on total sales.

### 4. Customer Sales Insights

Business insights generated include:

* Top 5 customers by sales.
* Bottom 5 customers by sales.
* Customers with only one order.
* Customers with above-average sales performance.
* Highest order value achieved by each customer.

### 5. Final Combined Analysis

A consolidated query was developed using:

* JOIN
* CTE
* Window Function (`RANK()`)

The query provides:

* Customer Name
* Total Sales
* Sales Rank

## Technologies Used

* MySQL
* MySQL Workbench
* SQL (DDL, DML, Joins, Subqueries, CTEs, Window Functions)

## Learning Outcomes

Through this project, I gained practical experience in:

* Database creation and management
* Data normalization techniques
* Writing analytical SQL queries
* Implementing CTEs and Window Functions
* Extracting business insights from transactional datasets

This project demonstrates the application of SQL for data preparation, transformation, and business analytics in a real-world dataset.

