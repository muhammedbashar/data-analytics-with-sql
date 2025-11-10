/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

###  RANKING ANALYSIS
-- -->> Order the values of Dimensions by Measure. 
-- --> FORMULA : Rank[Dimension] By [measure]
-- -> eg , RANK[Dimension] By [measure] , RANK countries By Total Sales , Top 5 Products by Quantity , Bottom 3 Customers By Total Orders


-- > Which 5 products genereate the highest revenue ? 
SELECT s.product_key,p.product_name , sum(s.sales_amount) as total_revenue
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY s.product_key,p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- OR 

select product_key,tr,ranking 
from 
(select product_key,sum(sales_amount) as tr , rank()over(order by sum(sales_amount) desc) as ranking
from gold_fact_sales
group by product_key)t
where ranking <=5;



-- > What are the 5 worst-perfoming products in terms of Sales ? 

SELECT s.product_key,p.product_name,SUM(s.sales_amount) as total_revenue
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p 
ON s.product_key = p.product_key
GROUP BY s.product_key,p.product_name
ORDER BY total_revenue
LIMIT 5;


SELECT t.product_key,p.product_name,t.total_revenue,t.wpr
FROM 
	(SELECT product_key,sum(sales_amount) as total_revenue, rank()over(order by sum(sales_amount) asc) as wpr
	FROM gold_fact_sales
	GROUP BY product_key)t
LEFT JOIN gold_dim_products p 
ON t.product_key = p.product_key
where wpr <= 5;    

-- > Find the Top-10 customers who have generated the highest revenue
SELECT s.customer_key,concat(c.first_name,' ',c.last_name) as cust_name,sum(s.sales_amount) as total_revenue
FROM gold_fact_sales s
LEFT JOIN gold_dim_customers c
ON s.customer_key = c.customer_key
GROUP BY s.customer_key,concat(c.first_name,' ',c.last_name)
ORDER BY total_revenue desc
limit 10;


select t.*, concat(c.first_name,' ',c.last_name) as cust_name
from
(select customer_key,sum(sales_amount) as total_revenue,dense_rank() over(order by sum(sales_amount) desc) as ranking
from gold_fact_sales
group by customer_key)t
left join gold_dim_customers c
on t.customer_key = c.customer_key 
where ranking <=10;

-- > The 3 Customers with the fewest orders placed
SELECT s.customer_key,concat(c.first_name,' ',c.last_name) as cust_name,count(distinct s.order_number) as order_placed
FROM gold_fact_sales s
left join gold_dim_customers c 
on s.customer_key = c.customer_key
group by s.customer_key,concat(c.first_name,' ',c.last_name)
order by order_placed 
limit 3;


select t.*,concat(c.first_name,' ',c.last_name) as cust_name
from
(select customer_key,count(order_number),row_number() over(order by count(distinct order_number)) as ranking
from gold_fact_sales
group by customer_key)t
left join gold_dim_customers c
on t.customer_key = c.customer_key
where ranking <=3;
