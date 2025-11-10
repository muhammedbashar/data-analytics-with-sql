## BUILDING CUSTOMER REPORT 
/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	 4. Calculates valuable KPIs:
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
       - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

/* 
1 - Base Querey : Retrieves columns from tables
==================================================*/ 
WITH base_query AS (
	SELECT 
		s.order_number,
		s.product_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name,' ',c.last_name) AS customer_name,
		TIMESTAMPDIFF(YEAR,c.birthdate,CURRENT_DATE) AS age
	FROM gold_fact_sales s
	LEFT JOIN gold_dim_customers c
	ON s.customer_key = c.customer_key
	WHERE s.order_date IS NOT NULL),
    
/* 
2 - Customer Aggregation : Summerizes key metrics at the cusomer level
==================================================*/ 
customer_aggregation AS (
	SELECT 
		customer_key,
		customer_number,
		customer_name,
		age,
		-- from here we can do aggregations
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS latest_order_date,
		TIMESTAMPDIFF(month,MIN(order_date),MAX(order_date)) AS lifespan_in_months
	FROM base_query
	GROUP BY customer_key,
		customer_number,
		customer_name,
		age)
        
SELECT 
	customer_key,
    customer_number,
    customer_name,
    age,
    CASE 
		WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and Above'
	END AS customer_age_group,
    CASE 
		WHEN lifespan_in_months >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan_in_months >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
	END AS customer_segmentation,
    latest_order_date,
    TIMESTAMPDIFF(month,latest_order_date,CURRENT_DATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan_in_months,
    -- Compute Average order value(AVO)
    CASE
		WHEN total_sales = 0 THEN 0 
        ELSE ROUND(total_sales / total_orders ,1)
	END AS average_order_value,
    -- Compute average monthly spent
    CASE
		WHEN lifespan_in_months = 0 THEN total_sales
        ELSE ROUND(total_sales / lifespan_in_months ,1)
	END AS average_monthly_spent
FROM customer_aggregation;
