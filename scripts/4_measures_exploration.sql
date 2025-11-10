/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

### MEASURES EXPLORATION
-- --> calculate the key metric of the business (Big Numbers)
-- -->  - Highest level of aggregation / Lowest Level of Details    (sum[sales],avg[sales],min[sales],max[sales])


-- > Find the Total Sales
SELECT SUM(sales_amount) as TOTAL_SALES
FROM gold_fact_sales;

-- > Find how many items are sold
SELECT COUNT(quantity) as Total_quantity
FROM gold_fact_sales;

-- > Find the average selling price
SELECT AVG(price) as AVERAGE_SALES_AMOUNT
FROM gold_fact_sales;

-- > Find the Total number of Orders
SELECT COUNT(order_number) as TOTAL_NUMBER_OF_ORDERS
FROM gold_fact_sales;

SELECT COUNT(DISTINCT order_number) AS TOTAL_UNIQUE_NO_OF_ORDERS
FROM gold_fact_sales;

-- > Find the Total number of Products
SELECT COUNT(product_key) AS TOTAL_NUMBER_OF_PRODUCTS
FROM gold_dim_products;

SELECT COUNT(product_name) as TOTAL_PRODUCTS
FROM gold_dim_products;

-- > Find the Total number of Customers
SELECT COUNT(customer_key) AS TOTAL_NUMBER_OF_CUSTOMERS
FROM gold_dim_customers;
 
-- > Find the Total number of Customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS_PLACED_ORDERS
FROM gold_fact_sales;

-- >> Generate Reports that shows all key metrics of the business
SELECT 'Total_sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'Total_quantity' AS measure_name, COUNT(quantity) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'AVERAGE_SALES_AMOUNT' AS measure_name , AVG(sales_amount) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'TOTAL_NUMBER_OF_ORDERS' AS measure_name,COUNT(order_number) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'TOTAL_NUMBER_OF_ORDERS' AS measure_name,COUNT(DISTINCT order_number) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'TOTAL_NUMBER_OF_PRODUCTS' AS measure_name,COUNT(product_key) AS measure_value FROM gold_dim_products
UNION ALL
SELECT 'TOTAL_NUMBER_OF_CUSTOMERS' AS measure_name,COUNT(customer_key) AS measure_value FROM gold_dim_customers
UNION ALL
SELECT 'TOTAL_CUSTOMERS_PLACED_ORDERS' AS measure_name,COUNT(DISTINCT customer_key) AS measure_value  FROM gold_fact_sales;