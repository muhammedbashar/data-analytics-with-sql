/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

## DATE SEGMENTATION
-- -->> You can Group the data based on a specific range. 
-- --> It Helps us to understad correlation between TWO measures.
-- -> Formula : [Measure] By [Measure]
-- -> eg , Total products by Sales range , Total Customers by Age 

/* Segment Products into cost range and count how many Products fall into each Segments */
WITH cost_segments AS (
	SELECT product_key,
			product_name,
			cost,
			CASE 
				WHEN cost<100 THEN 'Below 100'
				WHEN cost BETWEEN 100 AND 500 THEN '100-500'
				WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
				ELSE 'Above 1000'
			END AS cost_range
	FROM gold_dim_products)
    
SELECT cost_range,count(product_key) as count
FROM cost_segments
GROUP BY cost_range
ORDER BY count DESC;

/* Group Customer Into Three segments based on their spending behavior :
	- VIP : Customers with atleast 12 months of History and Spending more than 5000.
    - Regular : Customers with atleast 12 months of History but spednig 5000 or less. 
    - New : Customers with a lifespan less than 12 months. 
And find the Total number of customers by each group */  


with cte as(
select customer_key , min(order_date) as first_order,max(order_date) as last_order
from gold_fact_sales
group by customer_key),

cte_1 as(
	select s.customer_key,
			sum(s.sales_amount) total_sales,
			timestampdiff(month,ct.first_order,ct.last_order) as month_diff
	from gold_fact_sales s
	left join cte as ct
	on s.customer_key = ct.customer_key
	group by s.customer_key,timestampdiff(month,ct.first_order,ct.last_order))
    
select t.segments,
	count(t.segments) as counts
from
	(select c1.customer_key,
			case 
				when c1.total_sales > 5000 and c1.month_diff >=12 then 'vip'
				when c1.total_sales <= 5000 and c1.month_diff >=12 then 'regular'
				when c1.month_diff < 12 then 'new' 
			end as segments
	from cte_1 c1)t
group by t.segments
order by counts desc;


-- another way
WITH CTE AS (
SELECT c.customer_key,sum(s.sales_amount) as total_sales,
		min(s.order_date) as first_order, max(s.order_date) as last_order,
        TIMESTAMPDIFF(month,min(s.order_date),max(s.order_date)) as month_diff
FROM gold_fact_sales s
LEFT JOIN gold_dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key)

SELECT segmentation,count(customer_key) as count_segment
FROM(
    SELECT customer_key,
		CASE 
			WHEN month_diff >= 12 AND total_sales >5000 THEN 'VIP'
			WHEN month_diff >= 12 AND total_sales <= 5000 THEN 'Regular'
			WHEN month_diff < 12 THEN 'New'
		END AS segmentation
	FROM CTE)t
GROUP BY segmentation
ORDER BY count_segment DESC;