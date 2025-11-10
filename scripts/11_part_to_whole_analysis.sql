/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

## PART-TO-WHOLE ANALYSIS  (kinda pie chart model)
-- -->> It is, Analyse how an individual part is perfoming compared to the overall. 
-- --> its allowing us to understand which categories has the greatest impact on the overall business 
-- -> Foumula : ([Measure] / Total [Measure]) * 100 By [Dimension]
-- - Eg , (Sales / Total Sales) * 100 by Category
--        (Quantity / Total Quantity) * 100 by category , etc..


-- > Which categories contribute the most to overall sales? 
-- # >> WINDOW FUNCTION , To Display aggregation at multiple levels in the results, use window functions.
WITH category_sales AS(
	SELECT p.category,
			SUM(s.sales_amount) AS sales_amount
    FROM gold_fact_sales s
    LEFT JOIN gold_dim_products p
    ON s.product_key = p.product_key
    GROUP BY p.category)
    
SELECT category,
		sales_amount,
        SUM(sales_amount) OVER() AS actual_total_sale,
        CONCAT(ROUND((sales_amount / SUM(sales_amount) OVER()) *100 , 1 ), '%') AS contribuitio 
FROM category_sales
ORDER BY sales_amount DESC;
