/* 
======================= I- CUSTOMER ANALYSIS REPORT ==============================================
This report consolidates key customer metrics and behaviors 

1- Gathers essential fields as names, ages, and transaction details
2- Segement customers into categories (VIP,Regular, new) and age segment
3- Aggregates customer-level metrics : 
	- total orders, 
	- total sales, 
	- total quantity purchased, 
	- total products
	- lifespan
4- Calculates valuable KPIs : 
	- recency (months since last order)
	- average order value (AOV)
	- average monthly spend (AMS)
=====================================================================================
*/
-- 1- Gathers essential fields as names, ages, and transaction details
WITH customers_base AS (
SELECT 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
DATEDIFF(YEAR,c.birthdate,CURRENT_DATE) AS customer_age
FROM fact_sales AS f
LEFT JOIN dim_customers AS c
ON f.customer_key = c.customer_key
WHERE order_date IS NOT NULL
),

-- Customer-level aggregations 
customer_aggregation AS (
SELECT 
customer_key,
customer_number,
customer_name,
customer_age,
MAX(order_date) AS last_order_date,
COUNT(order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(product_key)  AS total_products,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan
FROM customers_base
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	customer_age
)


SELECT 
	customer_key,customer_number,customer_name,customer_age,total_orders,total_sales,total_quantity,	
	total_products,	last_order_date,
	DATEDIFF(MONTH,last_order_date,CURRENT_DATE) AS recency,
	CASE 
		WHEN total_sales > 5000 AND lifespan >= 12 THEN 'VIP'
		WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'Regular'
		ELSE 'New' 
	END AS customer_segment,
	CASE 
		WHEN customer_age < 20 THEN 'Young'
		WHEN customer_age BETWEEN 20 AND 39 THEN 'Old young'
		WHEN customer_age BETWEEN 40 AND 59 THEN 'Older'
		ELSE '60 and Older'
	END AS age_segment,
	-- Calculate Average order value
	total_sales / COALESCE(NULLIF(total_orders,0),1) AS avg_order_value,
	
	-- Calculate average monmthly spend
	total_sales / COALESCE(NULLIF(lifespan,0),1) AS avg_monthly_spend
FROM customer_aggregation;



/* 
======================= II- PRODUCT ANALYSIS REPORT==============================================
This report consolidates key products metrics and behaviors 

1- Gathers essential fields as product names, category, subcategory and cost
2- Segement products by revenue to identify High-Performes, Mid-Range, Or Low-Performers
3- Aggregates product-level metrics : 
	- total orders, 
	- total sales, 
	- total quantity sold, 
	- total customers
	- lifespan (in months)
4- Calculates valuable KPIs : 
	- recency (months since last sales)
	- average order revenue (AOR)
	- average monthly revenue (AMV) 
=====================================================================================
*/
-- 1- Gathers essential fields as names, ages, and transaction details
WITH products_base AS (
SELECT 
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM fact_sales AS f
LEFT JOIN dim_products AS p
ON f.customer_key = p.product_key
WHERE order_date IS NOT NULL
),

-- Customer-level aggregations 
product_aggregation AS (
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key)  AS total_customers,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)),1) AS avg_selling_price
FROM products_base
GROUP BY 
	product_key,
	product_name,
	category,
	subcategory,
	cost
)

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH,last_sale_date,CURRENT_DATE) AS recency_in_month,
	CASE 
		WHEN total_sales > 50000 THEN 'High-Permormer'
		WHEN total_sales >= 10000 THEN 'Mid-range'
		ELSE 'Low-Performer' 
	END AS product_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	
	-- Calculate Average order Revenue (AOR)
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders 
	END AS avg_order_revenue,
	-- Calculate average monmthly revenue
	CASE 
		WHEN lifespan = 0 THEN 0
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue
		
FROM product_aggregation