/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

### DATE RANGE EXPLORATION 
-- --> Identify the earliest and latest dates (boudaries)
-- --> Understand the scope of data and the timespan(by using DATEDIFF() function)
-- --> for minimum date -> MIN[DATE DIMENSION] /  MAX[DATE DIMENSION]


-- > find the date of the first and last order
SELECT MIN(order_date),MAX(order_date)
FROM gold_fact_sales;

-- > how many years of sales are available
SELECT MIN(order_date) as FIRST_ORDER,
	MAX(order_date) AS LAST_ORDER,
    TIMESTAMPDIFF(DAY,MIN(order_date),MAX(order_date)) as order_date_timestamp
FROM gold_fact_sales;

-- > Find the Youngest and Oldest Customer
SELECT MAX(birthdate) as youngest_customer,
		MIN(birthdate) as oldest_customer,
        TIMESTAMPDIFF(YEAR, MAX(birthdate),current_date()) as yougest_person_age,
        TIMESTAMPDIFF(YEAR, MIN(birthdate),current_date()) as oldest_person_age
FROM gold_dim_customers;