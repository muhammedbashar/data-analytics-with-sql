-- Drop and recreate the 'DataWarehouseAnalytics' database
DROP DATABASE IF EXISTS DataWarehouseAnalytics;
CREATE DATABASE DataWarehouseAnalytics;
USE DataWarehouseAnalytics;

-- Create Schema (In MySQL, schema = database, so you can use database name or keep a logical prefix)
-- We'll create tables under 'gold_' naming convention to simulate the 'gold' schema
-- Alternatively, you could create another database named 'gold', but we'll keep everything in one place.

-- Create dim_customers table
CREATE TABLE gold_dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

-- Create dim_products table
CREATE TABLE gold_dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

-- Create fact_sales table
CREATE TABLE gold_fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT
);

-- Clear existing data before loading
TRUNCATE TABLE gold_dim_customers;
TRUNCATE TABLE gold_dim_products;
TRUNCATE TABLE gold_fact_sales;

-- Load data from CSV files


select * from gold_dim_customers limit 15;
select * from gold_dim_products limit 15;
select * from gold_fact_sales limit 15;


select * from information_schema.tables;
select * from information_schema.columns
where table_name = 'gold_dim_customers';
