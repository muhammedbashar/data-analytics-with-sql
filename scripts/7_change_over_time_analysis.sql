/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

## CHANGE OVER TIME ANALYSIS
-- -->> Analyse how a measure evolves over time
-- --> it Helps to track trends and identify seasonality in you data.
-- -> Formula : [Measure] By [Date Dimension]
-- eg , Total sales by year , Average cost by Month
-- by doing this kinda analysis, we usually target our 'FACT Table' . most time that table contain different types of dates



-- > analyse total sale over year
SELECT year(order_date) as order_year,
	SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_number_of_customers,
    SUM(quantity) AS total_quantity
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY year(order_date)
ORDER BY year(order_date);  -- > This one give us , A high-level overview insights that helps with strategic decision-making

--     > analyse total sale over month
SELECT month(order_date) as order_year,
	SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_number_of_customers,
    SUM(quantity) AS total_quantity
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY month(order_date)
ORDER BY month(order_date); -- > This oen gives us, Detailed insights to discover seasonality in your data

--    > analyse total sale over both year and each month
SELECT DATE_FORMAT(order_date,'%Y-%m-%d') as order_date,
	SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_number_of_customers,
    SUM(quantity) AS total_quantity
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date,'%Y-%m-%d')
ORDER BY DATE_FORMAT(order_date,'%Y-%m-%d');
