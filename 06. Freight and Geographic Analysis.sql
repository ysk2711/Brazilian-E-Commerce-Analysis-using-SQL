/*
====================================================
PROJECT: OLIST E-COMMERCE ANALYSIS
CATEGORY: Freight and Geographical Analysis
====================================================
*/

/*
====================================================
FREIGHT ANALYSIS
====================================================
*/

/*
====================================================
QUERY: 01
BUSINESS QUESTION: Total Freight Value and Average Freight Revenue
*/
SELECT COUNT(*) AS Total_Order_Items,
	SUM(order_items.freight_value) AS Total_Freight_Value,
	ROUND(AVG(order_items.freight_value), 2) AS Average_Freight_Value
	FROM Orders JOIN Order_items ON
	Orders.order_id=order_items.order_id
WHERE Orders.order_status = 'delivered'

/*
====================================================
QUERY: 02
BUSINESS QUESTION: Freight Contribution to Total Order Value
*/
SELECT SUM(Order_items.price) AS Total_Product_Value,
	SUM(Order_items.freight_value) AS Total_Freight_Value,
	SUM(Order_items.price) + SUM(Order_items.freight_value) AS Total_Order_Value,
	ROUND((SUM(Order_items.freight_value)/(SUM(Order_items.price) + SUM(Order_items.freight_value)))*100.0, 2)
	AS Freight_Percentage
	FROM Order_items JOIN orders ON
	order_items.order_id=orders.order_id
WHERE orders.order_status = 'delivered'

/*
====================================================
QUERY: 03
BUSINESS QUESTION: Average Freight Charges by Product Category
*/
SELECT category_translation.product_category_name_english AS Category_Name,
	COUNT(*) AS Total_Order_Items,
	SUM(order_items.freight_value) AS Total_Freight_Value,
	ROUND(AVG(order_items.freight_value), 2) AS Average_Freight_Value
	FROM category_translation JOIN products ON category_translation.product_category_name=products.product_category_name
	JOIN Order_items on products.product_id=order_items.product_id
	JOIN orders ON order_items.order_id=orders.order_id
WHERE orders.order_status = 'delivered'
GROUP BY Category_name
ORDER BY Average_Freight_Value DESC
/*
====================================================
QUERY: 04
BUSINESS QUESTION: Total Freight Value based on Customer State
*/
SELECT Customers.Customer_State AS Customer_State,
	COUNT(DISTINCT Orders.order_id) AS Total_Orders,
	SUM(order_items.freight_value) AS Total_Freight_Value,
	ROUND(AVG(order_items.freight_value), 2) AS Average_Freight_Value
FROM Customers JOIN Orders ON Customers.customer_id=orders.customer_id
JOIN order_items on Orders.order_id=order_items.order_id
WHERE orders.order_status = 'delivered'
GROUP BY Customer_State
ORDER BY Total_Freight_Value DESC

/*
====================================================
GEOGRAPHIC ANALYSIS
====================================================
*/
/*
====================================================
QUERY: 01
BUSINESS QUESTION: Customer Distribution by State
*/
SELECT Customer_State, COUNT(DISTINCT Customer_unique_id) AS Total_Customers,
	ROUND((COUNT(DISTINCT Customer_unique_id)/SUM(COUNT(DISTINCT Customer_unique_id)) OVER ())*100.0, 2) 
	AS Customer_Percentage
	FROM Customers
GROUP BY Customer_State
ORDER BY Customer_Percentage DESC

/*
====================================================
QUERY: 02
BUSINESS QUESTION: Total Revenue by Customer State
*/
SELECT customers.customer_state AS Customer_State,
	COUNT(DISTINCT orders.order_id) AS Total_Orders,
	SUM(Order_items.price) AS Total_Revenue,
	ROUND(SUM(Order_items.price)/COUNT(DISTINCT orders.order_id), 2) AS Avg_order_Value
FROM Customers JOIN Orders ON Customers.customer_id=orders.customer_id
JOIN order_items ON orders.order_id=order_items.order_id
WHERE orders.order_status = 'delivered'
GROUP BY Customer_State
ORDER BY Total_Revenue DESC

/*
====================================================
QUERY: 03
BUSINESS QUESTION: Average Order Value by Customer State
*/
SELECT customers.customer_state AS Customer_State,
	COUNT(DISTINCT orders.order_id) AS Total_Orders,
	SUM(Order_items.price) AS Total_Revenue,
	ROUND(SUM(Order_items.price)/COUNT(DISTINCT orders.order_id), 2) AS Avg_order_Value
FROM Customers JOIN Orders ON Customers.customer_id=orders.customer_id
JOIN order_items ON orders.order_id=order_items.order_id
WHERE orders.order_status = 'delivered'
GROUP BY Customer_State
ORDER BY Avg_order_Value DESC

/*
====================================================
QUERY: 04
BUSINESS QUESTION: Monthly Revenue by Customer State
*/
SELECT DATE_TRUNC('month', orders.order_purchase_timestamp) AS Sales_Month,
	customers.customer_state AS Customer_State,
	COUNT(DISTINCT orders.order_id) AS Total_Orders,
	SUM(order_items.price) AS Total_Revenue
	FROM Customers JOIN Orders ON customers.customer_id=orders.customer_id
	JOIN Order_items on orders.order_id=order_items.order_id
	WHERE Orders.order_status = 'delivered'
GROUP BY Customer_State, Sales_Month
ORDER BY Sales_Month
