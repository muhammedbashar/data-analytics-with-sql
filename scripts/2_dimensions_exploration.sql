/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
## EXPLORE DIMENSIONS
-- > Identify the unique values (or categories) in each dimension
	-- > Recognizing how data might be grouped or segmented. which is useful for later analysis
    

-- --> Explore all countries our customers come from:
SELECT DISTINCT
    country
FROM
    gold_dim_customers;

-- --> Explore all categories "The Major Divisions"
SELECT DISTINCT
    category
FROM
    gold_dim_products;

-- -->  Explore all categories "The Major Divisions" , more depth
SELECT DISTINCT
    category, subcategory, product_name
FROM
    gold_dim_products
ORDER BY 1 , 2 , 3;