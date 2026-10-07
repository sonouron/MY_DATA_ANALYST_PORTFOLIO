


-- 1. Overall sales per year
SELECT 
	YEAR(order_date) AS order_year, 
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_clients,
	COUNT(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date) ASC


--2. Drill Down Overall sales per month and year 
SELECT 
	YEAR(order_date) AS order_year, 
	FORMAT(order_date,'MMM') AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_clients,
	COUNT(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), FORMAT(order_date,'MMM'),MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)


--3. Total sales per month, running total sales and moving average 
SELECT order_month,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY order_month ORDER BY order_month) AS running_total_sales,
	SUM(avg_price) OVER (ORDER BY order_month) AS moving_avg_price
FROM(
	SELECT DATETRUNC(month,order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
	FROM fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month,order_date)
) t


--4. Yearly performance of products : products/average sales and products/previous year's sales
WITH yearly_sales_by_product AS (
	SELECT YEAR(f.order_date) AS order_year,
	p.product_name,
	SUM(f.sales_amount) AS current_sales
	FROM fact_sales AS f
	LEFT JOIN dim_products AS p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL 
	GROUP BY YEAR(f.order_date),p.product_name
)

SELECT order_year,
	product_name,current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_with_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above avg'
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below avg'
		ELSE 'Avg'
	END AS avg_change,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
	CASE WHEN current_sales-LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Incresing'
		WHEN current_sales-LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decresing'
		ELSE 'Sate'
	END AS sales_change
FROM yearly_sales_by_product
ORDER BY product_name, order_year


--5. Categories that contribute the most to overall sales : Bikes category
WITH category_sales AS (
	SELECT category, SUM(sales_amount) AS total_sales
	FROM fact_sales f
	LEFT JOIN dim_products p
	ON p.product_key = f.product_key 
	GROUP BY category
)

SELECT 
	category, 
	total_sales, 
	SUM(total_sales) OVER () AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ())*100,2),'%') AS sales_percent
FROM category_sales
ORDER BY total_sales DESC


--6. Products segmentation into cost ranges
WITH products_segment AS (
	SELECT cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
		ELSE 'Above 1000'
	END AS segment
	FROM dim_products
)

SELECT segment, COUNT(cost) AS total_products
FROM products_segment
GROUP BY segment
ORDER BY total_products DESC


--7. Segmentation of customers based on their spending behavior
WITH customer_total_price AS (
	SELECT customer_key,
	CASE WHEN SUM(sales_amount) > 5000 AND DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) >= 12 THEN 'VIP'
		WHEN SUM(sales_amount) <= 5000 AND DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) >= 12 THEN 'Regular'
		ELSE 'New' 
		END AS customer_segment 
	FROM fact_sales
	GROUP BY customer_key
)

SELECT customer_segment, COUNT(customer_key) AS total_customer
FROM customer_total_price
GROUP BY customer_segment
ORDER BY total_customer DESC
