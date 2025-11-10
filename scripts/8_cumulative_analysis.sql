/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

## CUMULATIVE ANALYSIS
-- -->> It is aggregating the data progressively over time
-- --> it helps us to understand whether our business is growing or declining.
-- --> Formula : [Cumulative Measure] By [Date Dimension]
-- -> eg, Running total of sales by Year , Moving average of sales By Month, etc...


-- > Calculate the total sales per month
SELECT STR_TO_DATE(DATE_FORMAT(order_date,'%Y-%m-%d'), '%Y-%m-%d') AS order_mont,
	SUM(sales_amount) AS total_sales
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY STR_TO_DATE(DATE_FORMAT(order_date,'%Y-%m-%d'), '%Y-%m-%d')
ORDER By STR_TO_DATE(DATE_FORMAT(order_date,'%Y-%m-%d'), '%Y-%m-%d');

-- > and the Running total of sales over-Time 
SELECT order_month,
		total_sales,
        SUM(total_sales) OVER(ORDER BY order_month) AS running_total_sales
FROM 
	(SELECT STR_TO_DATE(DATE_FORMAT(order_date,'%Y-%m-01'),'%Y-%m-%d') AS order_month,
		SUM(sales_amount) AS total_sales
	FROM gold_fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY STR_TO_DATE(DATE_FORMAT(order_date,'%Y-%m-01'),'%Y-%m-%d')
	ORDER BY STR_TO_DATE(DATE_FORMAT(order_date,'%Y-%m-01'),'%Y-%m-%d'))t
;

-- > Calculate the Moving average by each year
SELECT order_year,total_sales,
	avg(average_price) over ( order by order_year) as moving_average
FROM 
(SELECT DATE_FORMAT(order_date,'%Y') as order_year,
		SUM(sales_amount) AS total_sales,
        AVG(price) as average_price
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date,'%Y') 
ORDER BY DATE_FORMAT(order_date,'%Y'))t;