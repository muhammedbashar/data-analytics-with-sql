/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

## PERFOMANCE ANALYSIS
-- -->> It is the process of Comparing the Current value to a target value.
-- --> it helps us to, Measure success and compare perfomance
-- -> Formula : current[Measure] - Target[Measure]
-- -> eg , Current Sales - Average Sales
--         Current Sales - Average Sales
--         Current Year Sales - Previous Year Sales 
--         Current Sales - Lowest Sales / Current Sales - Highest Sales


/* Analyse the yearly perfomance of products by comparing their sales to both the average sales perfomance of the product and the previous year's sales */
     -- --- Year - over - Year Sales --- --
WITH yearly_product_sales AS(
	SELECT year(s.order_date) as order_year ,
			p.product_name,
			SUM(s.sales_amount) as current_total_sales
	FROM gold_fact_sales s 
	LEFT JOIN gold_dim_products p
	ON s.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY year(s.order_date),
			p.product_name)
    
    
SELECT 
	order_year,
	product_name,
	current_total_sales,
	AVG(current_total_sales) OVER (PARTITION BY product_name) AS average_sales_by_product,
    (current_total_sales - AVG(current_total_sales) OVER (PARTITION BY product_name)) as avg_diff,
    CASE 
		WHEN (current_total_sales - AVG(current_total_sales) OVER (PARTITION BY product_name)) > 0 THEN 'Above Average'
        WHEN (current_total_sales - AVG(current_total_sales) OVER (PARTITION BY product_name)) < 0 THEN 'Below Average' 
        ELSE 'Exact Average'
	END AS avg_change,
    LAG(current_total_sales) OVER (PARTITION BY product_name ORDER BY order_year) as previous_year_sales,
    (current_total_sales - LAG(current_total_sales) OVER (PARTITION BY product_name ORDER BY order_year)) AS diff_previous_year,
    CASE 
		WHEN (current_total_sales - LAG(current_total_sales) OVER (PARTITION BY product_name ORDER BY order_year)) > 0 THEN 'Increasing'
        WHEN (current_total_sales - LAG(current_total_sales) OVER (PARTITION BY product_name ORDER BY order_year)) < 0 THEN 'Decreasing' 
        ELSE 'No change'
	END AS previous_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year ; -- > if we want this into a 'MONTH - OVER - MONTH' analysis , then use 'Month()' function instead of 'Year()' 
									-- > Year over Year analysis , use for Long term analysis or understand Long term Trend 
                                    -- > Month over Month analysis , Use for Short Term analsis or understand short term Trends (understand seasonality)
