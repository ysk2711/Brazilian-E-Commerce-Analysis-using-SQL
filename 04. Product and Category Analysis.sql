/*
====================================================
PROJECT: OLIST E-COMMERCE ANALYSIS
CATEGORY: Product and Category Analysis
====================================================
*/

/*
====================================================
PRODUCT ANALYSIS
====================================================
*/

/*
====================================================
QUERY: 01
BUSINESS QUESTION: Top 10 Most Selling Products
*/
SELECT product_id,
	COUNT (*) AS Total_quantity,
	COUNT(DISTINCT order_items.order_id) AS Total_orders 
	FROM Order_items
	JOIN Orders ON 
	Order_items.order_id=orders.order_id
WHERE orders.order_status='delivered'
GROUP BY Product_id
ORDER BY Total_Quantity DESC
Limit 10

/*
====================================================
QUERY: 02
BUSINESS QUESTION: Highest Revenue Generating Products
*/
SELECT product_id,
	SUM(order_items.price) AS Total_Product_Revenue,
	COUNT(*) AS Total_Quantity,
	COUNT(DISTINCT order_items.order_id) AS Total_Orders 
	FROM Order_items
	JOIN Orders ON 
	Order_items.order_id=orders.order_id
WHERE orders.order_status='delivered'
GROUP BY Product_id
ORDER BY Total_Product_Revenue DESC
Limit 10

/*
====================================================
QUERY: 03
BUSINESS QUESTION: Product Order Freaquency 
*/
SELECT product_id,
	COUNT(*) AS Total_Quantity,
	COUNT(DISTINCT order_items.order_id) AS Total_Orders 
	FROM Order_items
	JOIN Orders ON 
	Order_items.order_id=orders.order_id
WHERE orders.order_status='delivered'
GROUP BY Product_id
ORDER BY Total_orders DESC
Limit 10

/*
====================================================
QUERY: 04
BUSINESS QUESTION: Top 10 Products With Highest Selling Price
*/
SELECT product_id,
	ROUND(AVG(order_items.price), 2) AS Avg_selling_Price,
	COUNT(*) AS Total_Quantity,
	SUM(order_items.price) AS Total_Product_Revenue 
	FROM Order_items
	JOIN Orders ON 
	Order_items.order_id=orders.order_id
WHERE orders.order_status='delivered'
GROUP BY Product_ID
ORDER BY Avg_selling_price DESC
LIMIT 10
/*
====================================================
QUERY: 05
BUSINESS QUESTION: Monthly Product Sales Performance
*/
SELECT order_items.Product_id, 
	DATE_TRUNC('month', orders.order_purchase_timestamp) AS Sales_Month,
	SUM(Order_items.price) AS Total_Product_Revenue,
	COUNT(*) AS Total_Quantity,
	COUNT(DISTINCT Orders.order_id) AS Total_orders
	FROM Order_items JOIN Orders ON 
	order_items.order_id=orders.order_id
WHERE Orders.order_status='delivered'
GROUP BY Product_id, Sales_Month
ORDER BY Product_id, Sales_Month

/*
====================================================
QUERY: 06
BUSINESS QUESTION: Top 10 Products by Revenue per Order
*/
SELECT order_items.Product_id, 
	SUM(Order_items.price) AS Total_Product_Revenue,
	COUNT(DISTINCT Orders.order_id) AS Total_orders,
    ROUND(SUM(Order_items.price)/COUNT(DISTINCT Orders.order_id), 2) AS Average_revenue_per_order
	FROM Order_items JOIN Orders ON 
	order_items.order_id=orders.order_id
WHERE Orders.order_status='delivered'
GROUP BY Product_id
ORDER BY Average_revenue_per_order DESC
LIMIT 10

/*
====================================================
QUERY: 07
BUSINESS QUESTION: Products with Lowest Sales
*/
SELECT product_id,
	COUNT (*) AS Total_quantity,
	COUNT(DISTINCT order_items.order_id) AS Total_orders,
	SUM(Order_items.price) AS Total_Product_Revenue
	FROM Order_items
	JOIN Orders ON 
	Order_items.order_id=orders.order_id
WHERE orders.order_status='delivered'
GROUP BY Product_id
ORDER BY Total_Quantity ASC
Limit 10

/*
====================================================
QUERY: 08
BUSINESS QUESTION: Top Products by Revenue Percentage
*/
WITH Revenue_Contribution AS (
	SELECT Order_items.Product_id,
	COUNT(*) AS Total_Quantity,
	COUNT(DISTINCT Orders.order_id) AS Total_Orders,
	SUM(order_items.price) AS Total_Product_Revenue
	FROM Order_items JOIN Orders ON 
	Order_items.order_id=orders.order_id
	WHERE orders.order_status = 'delivered'
	GROUP BY Product_id
)
SELECT Product_id, Total_quantity, Total_Orders, Total_Product_Revenue, 
	ROUND((Total_Product_Revenue/SUM(Total_Product_Revenue) OVER())*100.0, 2) AS Revenue_Percentage
	FROM Revenue_Contribution
ORDER BY Revenue_Percentage DESC
LIMIT 10

/*
====================================================
CATEGORY ANALYSIS
====================================================
*/
/*
====================================================
QUERY: 01
BUSINESS QUESTION: Total Revenue by Product Category
*/
SELECT Category_translation.product_category_name_english AS Category_Name, 
	COUNT(*) as Total_Quantity, 
	COUNT(Distinct Orders.order_id) AS Total_Orders,
	SUM(order_items.price) AS Total_Category_revenue
	FROM Order_items 
	JOIN orders ON order_items.order_id=orders.order_id
	JOIN products ON order_items.product_id=products.product_id
	JOIN Category_translation 
	ON products.product_category_name=Category_translation.product_category_name
WHERE orders.order_status='delivered'
GROUP BY Category_Name
ORDER BY Total_Category_revenue DESC
LIMIT 10

/*
====================================================
QUERY: 02
BUSINESS QUESTION: Most Selling Product Categories 
*/
SELECT Category_translation.product_category_name_english AS Category_Name, 
	COUNT(*) as Total_Quantity, 
	COUNT(Distinct Orders.order_id) AS Total_Orders,
	SUM(order_items.price) AS Total_Category_revenue
	FROM Order_items 
	JOIN orders ON order_items.order_id=orders.order_id
	JOIN products ON order_items.product_id=products.product_id
	JOIN Category_translation 
	ON products.product_category_name=Category_translation.product_category_name
WHERE orders.order_status='delivered'
GROUP BY Category_Name
ORDER BY Total_Quantity DESC
LIMIT 10

/*
====================================================
QUERY: 03
BUSINESS QUESTION: Highest Revenue Generating Categories
*/
WITH Category_Wise_Revenue AS (
	SELECT Category_translation.product_category_name_english AS Category_Name, 
		COUNT(*) as Total_Quantity, 
		COUNT(Distinct Orders.order_id) AS Total_Orders,
		SUM(order_items.price) AS Total_Category_revenue
		FROM Order_items 
		JOIN orders ON order_items.order_id=orders.order_id
		JOIN products ON order_items.product_id=products.product_id
		JOIN Category_translation 
		ON products.product_category_name=Category_translation.product_category_name
	WHERE orders.order_status='delivered'
	GROUP BY Category_Name)
SELECT Category_name, Total_Orders, Total_Quantity, Total_Category_revenue, 
	ROUND((Total_Category_revenue/SUM(Total_Category_revenue)OVER())*100.0, 2) AS Category_Revenue_Percentage
	FROM Category_wise_revenue
ORDER BY Category_Revenue_Percentage DESC
LIMIT 10

/*
====================================================
QUERY: 04
BUSINESS QUESTION: Number of Products per Category
*/
SELECT Category_translation.product_category_name_english AS Category_Name,
	COUNT(DISTINCT Products.product_id) AS Total_Products
	FROM Category_translation JOIN Products ON
	Category_translation.product_category_name=products.product_category_name
GROUP BY Category_Name
ORDER BY Total_Products DESC

/*
====================================================
QUERY: 05
BUSINESS QUESTION: Average Product Price per Category
*/
WITH Category_Wise_Revenue AS (
	SELECT Category_translation.product_category_name_english AS Category_Name, 
		COUNT(*) as Total_Quantity, 
		COUNT(Distinct Orders.order_id) AS Total_Orders,
		SUM(order_items.price) AS Total_Category_revenue,
		ROUND(AVG(order_items.price), 2) AS Avg_Price
		FROM Order_items 
		JOIN orders ON order_items.order_id=orders.order_id
		JOIN products ON order_items.product_id=products.product_id
		JOIN Category_translation 
		ON products.product_category_name=Category_translation.product_category_name
	WHERE orders.order_status='delivered'
	GROUP BY Category_Name)
SELECT Category_name, Total_Orders, Total_Quantity, Total_Category_revenue, Avg_Price
	FROM Category_wise_revenue
ORDER BY Avg_Price DESC
LIMIT 10

/*
====================================================
QUERY: 06
BUSINESS QUESTION: Monthly Category Performance
*/
WITH Category_Wise_Revenue AS (
	SELECT Category_translation.product_category_name_english AS Category_Name, 
		DATE_TRUNC('month', orders.order_purchase_timestamp) AS Sales_Month,
		COUNT(*) as Total_Quantity, 
		COUNT(Distinct Orders.order_id) AS Total_Orders,
		SUM(order_items.price) AS Total_Category_revenue
		FROM Order_items 
		JOIN orders ON order_items.order_id=orders.order_id
		JOIN products ON order_items.product_id=products.product_id
		JOIN Category_translation 
		ON products.product_category_name=Category_translation.product_category_name
	WHERE orders.order_status='delivered'
	GROUP BY Category_Name, Sales_Month)
SELECT *
FROM Category_wise_revenue
ORDER BY Category_Name, Sales_Month

/*
====================================================
QUERY: 07
BUSINESS QUESTION: Category-wise Order Distribution
*/
WITH Category_Order_Distribution AS (
	SELECT Category_translation.product_category_name_english AS Category_Name, 
		COUNT(*) as Total_Quantity, 
		COUNT(Distinct Orders.order_id) AS Total_Orders,
		SUM(order_items.price) AS Total_Category_revenue
		FROM Order_items 
		JOIN orders ON order_items.order_id=orders.order_id
		JOIN products ON order_items.product_id=products.product_id
		JOIN Category_translation 
		ON products.product_category_name=Category_translation.product_category_name
	WHERE orders.order_status='delivered'
	GROUP BY Category_Name)
SELECT *
FROM Category_order_distribution
ORDER BY Total_Orders DESC

/*
====================================================
QUERY: 08
BUSINESS QUESTION: Highest Revenue Generating Categories
*/
WITH Category_AOV_Distribution AS (
	SELECT Category_translation.product_category_name_english AS Category_Name, 
		COUNT(*) as Total_Quantity, 
		COUNT(Distinct Orders.order_id) AS Total_Orders,
		SUM(order_items.price) AS Total_Category_revenue
		FROM Order_items 
		JOIN orders ON order_items.order_id=orders.order_id
		JOIN products ON order_items.product_id=products.product_id
		JOIN Category_translation 
		ON products.product_category_name=Category_translation.product_category_name
	WHERE orders.order_status='delivered'
	GROUP BY Category_Name)
SELECT Category_Name, Total_Quantity, Total_Orders, Total_Category_revenue, 
	ROUND((Total_Category_revenue/Total_Orders), 2) AS Category_AOV
FROM Category_AOV_distribution
ORDER BY Category_AOV DESC

/*
====================================================
QUERY: 09
BUSINESS QUESTION: Category-wise Product Distribution
*/
WITH Category_Product_Distribution AS (
	SELECT Category_translation.product_category_name_english AS Category_Name, 
		COUNT(DISTINCT Products.product_id) AS Distinct_Products,
		COUNT(*) as Total_Quantity, 
		COUNT(Distinct Orders.order_id) AS Total_Orders,
		SUM(order_items.price) AS Total_Category_revenue
		FROM Order_items 
		JOIN orders ON order_items.order_id=orders.order_id
		JOIN products ON order_items.product_id=products.product_id
		JOIN Category_translation 
		ON products.product_category_name=Category_translation.product_category_name
	WHERE orders.order_status='delivered'
	GROUP BY Category_Name)
SELECT *
FROM Category_Product_distribution
ORDER BY Distinct_Products DESC

/*
====================================================
QUERY: 10
BUSINESS QUESTION: Category-wise Month over Month Growth
*/
WITH Category_Wise_Revenue AS (
	SELECT Category_translation.product_category_name_english AS Category_Name, 
		DATE_TRUNC('month', orders.order_purchase_timestamp) AS Sales_Month,
		SUM(order_items.price) AS Total_Category_revenue
		FROM Order_items 
		JOIN orders ON order_items.order_id=orders.order_id
		JOIN products ON order_items.product_id=products.product_id
		JOIN Category_translation 
		ON products.product_category_name=Category_translation.product_category_name
	WHERE orders.order_status='delivered'
	GROUP BY Category_Name, Sales_Month),

MONTHLY_SALES AS (
	SELECT Category_Name, Sales_Month, Total_Category_revenue,
	LAG(Total_Category_Revenue,1) OVER (PARTITION BY Category_name ORDER BY Sales_Month) AS Previous_month_revenue
	FROM Category_wise_revenue)


SELECT Category_Name, Sales_month, Total_Category_revenue, Previous_month_revenue,
	ROUND((Total_category_revenue-Previous_month_revenue)/NULLIF(Previous_month_revenue, 0)*100.0, 2) 
	AS MoM_Growth_Percentage
	FROM Monthly_sales 
ORDER BY Category_Name
