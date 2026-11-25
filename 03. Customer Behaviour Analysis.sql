/*
====================================================
PROJECT: OLIST E-COMMERCE ANALYSIS
CATEGORY: Customer Behaviour Analysis
====================================================
*/

/*
====================================================
QUERY: 01
BUSINESS QUESTION: Total Unique Customers and Number of Orders
*/
WITH customer_orders AS (
    SELECT
        customers.customer_unique_id,
        COUNT(DISTINCT orders.order_id) AS number_of_orders
    FROM customers
    JOIN orders
        ON customers.customer_id = orders.customer_id
    WHERE orders.order_status = 'delivered'
GROUP BY customers.customer_unique_id
)
SELECT * 
FROM Customer_Orders
/*
====================================================
QUERY: 02
BUSINESS QUESTION: Customer Purchase Freaquency
*/
WITH customer_orders AS (
    SELECT
        customers.customer_unique_id,
        COUNT(DISTINCT orders.order_id) AS number_of_orders
    FROM customers
    JOIN orders
        ON customers.customer_id = orders.customer_id
    WHERE orders.order_status = 'delivered'
    GROUP BY customers.customer_unique_id
),

customer_frequency AS (
    SELECT
        CASE
            WHEN number_of_orders = 1 THEN 'One Time'
            WHEN number_of_orders = 2 THEN 'Two Times'
            WHEN number_of_orders = 3 THEN 'Three Times'
            ELSE 'More than three times'
        END AS Frequency_of_customer
    FROM customer_orders
)
SELECT
    Frequency_of_Customer,
    COUNT(*) AS Number_of_Customers
FROM customer_frequency
GROUP BY Frequency_of_Customer;

/*
====================================================
QUERY: 03
BUSINESS QUESTION: One-time vs Repeat Customers
*/
WITH customer_orders AS (
    SELECT
        customers.customer_unique_id,
        COUNT(DISTINCT orders.order_id) AS number_of_orders
    FROM customers
    JOIN orders
        ON customers.customer_id = orders.customer_id
    WHERE orders.order_status = 'delivered'
    GROUP BY customers.customer_unique_id
),
Customer_Type AS (
	SELECT
		Customer_unique_id,
		CASE
		WHEN Number_of_orders=1 THEN 'One-time Customer'
		WHEN Number_of_orders>1 THEN 'Repeat Customer'
		END AS Onetime_or_Repeat_Customer
	FROM Customer_orders
)
SELECT customer_unique_id, Onetime_or_Repeat_Customer 
FROM Customer_Type

/*
====================================================
QUERY: 04
BUSINESS QUESTION: Repeat Customer Percentage
*/
WITH customer_orders AS (
    SELECT
        customers.customer_unique_id,
        COUNT(DISTINCT orders.order_id) AS number_of_orders
    FROM customers
    JOIN orders
        ON customers.customer_id = orders.customer_id
    WHERE orders.order_status = 'delivered'
    GROUP BY customers.customer_unique_id
),
Customer_Type AS (
	SELECT
		Customer_unique_id,
		CASE
		WHEN Number_of_orders=1 THEN 'One-time Customer'
		WHEN Number_of_orders>1 THEN 'Repeat Customer'
		END AS Onetime_or_Repeat_Customer
	FROM Customer_orders
)
SELECT
    COUNT(*) AS Total_Customers,
    COUNT(*) FILTER (
        WHERE Onetime_or_Repeat_Customer = 'Repeat Customer'
    ) AS Repeat_Customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE Onetime_or_Repeat_Customer = 'Repeat Customer'
        ) * 100.0 / COUNT(*),
        2
    ) AS Repeat_Customer_Percentage
FROM Customer_Type;

/*
====================================================
QUERY: 05
BUSINESS QUESTION: Customer-level Spending and AOV
*/
WITH Customer_spending AS(
	SELECT customers.customer_unique_id, 
	COUNT(DISTINCT orders.order_id) AS Order_Count, 
	SUM(order_items.price) AS Total_Product_Spending 
	FROM Customers 
	JOIN Orders ON 
	customers.customer_id=orders.customer_id 
	JOIN Order_items ON
	orders.order_id=order_items.order_id
	WHERE orders.order_status='delivered'
	GROUP BY Customer_unique_id),

Customer_classification AS(
	SELECT customer_unique_id, order_count, total_product_spending, 
	CASE
		WHEN Order_Count>1 THEN 'Repeat Customer'
		ELSE 'One Time Customer'
		END AS Customer_Type 
	FROM Customer_spending) 

SELECT Customer_Type, 
	COUNT(*) AS Customer_Count, 
	ROUND(AVG(Total_Product_Spending), 2) AS Average_Spending, 
	ROUND(AVG(Order_count), 2) AS Average_Order_Count, 
	ROUND(AVG(Total_product_spending/order_count), 2) AS Average_OV 
FROM Customer_classification
GROUP BY Customer_Type

/*
====================================================
QUERY: 06
BUSINESS QUESTION: Customer Spending Segmentation
*/
WITH Customer_spending AS(
	SELECT customers.customer_unique_id, 
	COUNT(DISTINCT orders.order_id) AS Order_Count, 
	SUM(order_items.price) AS Total_Product_Spending 
	FROM Customers 
	JOIN Orders ON 
	customers.customer_id=orders.customer_id 
	JOIN Order_items ON
	orders.order_id=order_items.order_id
	WHERE orders.order_status='delivered'
	GROUP BY Customer_unique_id
),
Customer_segmentation AS (
	SELECT Customer_unique_id, Total_Product_Spending,
	CASE 
	WHEN Total_Product_Spending>=2000 THEN 'High Value Customer'
	WHEN Total_Product_Spending>=750 THEN 'Medium Value Customer'
	ELSE 'Low Value Customer'
	END AS Customer_value
	FROM customer_spending
)
SELECT * FROM Customer_segmentation

/*
====================================================
QUERY: 07
BUSINESS QUESTION: Customer Distribution by Spending Category
*/
WITH Customer_spending AS(
	SELECT customers.customer_unique_id, 
	COUNT(DISTINCT orders.order_id) AS Order_Count, 
	SUM(order_items.price) AS Total_Product_Spending 
	FROM Customers 
	JOIN Orders ON 
	customers.customer_id=orders.customer_id 
	JOIN Order_items ON
	orders.order_id=order_items.order_id
	WHERE orders.order_status='delivered'
	GROUP BY Customer_unique_id
),
Customer_segmentation AS (
	SELECT Customer_unique_id, Total_Product_Spending,
	CASE 
	WHEN Total_Product_Spending>=2000 THEN 'High Value Customer'
	WHEN Total_Product_Spending>=750 THEN 'Medium Value Customer'
	ELSE 'Low Value Customer'
	END AS Customer_value
	FROM customer_spending
)
SELECT Customer_value, COUNT(*) AS Number_of_Customers
FROM Customer_segmentation
GROUP BY Customer_value

/*
====================================================
QUERY: 08
BUSINESS QUESTION: One-time vs Repeat Customer Spending
*/
WITH Customer_spending AS(
	SELECT customers.customer_unique_id, 
	COUNT(DISTINCT orders.order_id) AS Order_Count, 
	SUM(order_items.price) AS Total_Product_Spending 
	FROM Customers 
	JOIN Orders ON 
	customers.customer_id=orders.customer_id 
	JOIN Order_items ON
	orders.order_id=order_items.order_id
	WHERE orders.order_status='delivered'
	GROUP BY Customer_unique_id),

Customer_classification AS(
	SELECT customer_unique_id, order_count, total_product_spending, 
	CASE
		WHEN Order_Count>1 THEN 'Repeat Customer'
		ELSE 'One Time Customer'
		END AS Customer_Type 
	FROM Customer_spending) 

SELECT Customer_Type, SUM(Total_product_spending) AS Total_Spending
FROM Customer_classification
GROUP BY Customer_Type

/*
====================================================
QUERY: 09
BUSINESS QUESTION: Monthly Customer Acquisition
*/
WITH First_Order AS (
    SELECT
        customers.customer_unique_id,
        MIN(orders.order_purchase_timestamp) AS First_order_Month 
    FROM customers
    JOIN orders
        ON Customers.customer_id=orders.customer_id
    GROUP BY customers.customer_unique_id
),
Acquisition_Month AS (
	SELECT Customer_unique_id, DATE_TRUNC('month', First_Order_Month) AS Acq_month
	FROM First_order
),
Monthly_Count AS (
	SELECT Acq_Month, 
	COUNT(customer_unique_id) AS Number_of_Customers_Acquired
	FROM Acquisition_Month
	GROUP BY Acq_Month
	ORDER BY Acq_Month
)
SELECT
    Acq_Month,
    Number_of_Customers_Acquired,
    SUM(Number_of_Customers_Acquired)
        OVER (ORDER BY Acq_Month) AS Cumulative_Customers
FROM Monthly_Count
ORDER BY Acq_Month

/*
====================================================
QUERY: 10
BUSINESS QUESTION: Customer Retention Analysis
*/
WITH Customer_Monthly_Activity AS (
    SELECT DISTINCT Customers.customer_unique_id, 
	DATE_TRUNC('month', orders.order_purchase_timestamp) AS Order_Month 
	FROM Customers
    JOIN Orders
        ON Customers.customer_id=orders.customer_id
    WHERE orders.order_status = 'delivered'
),
Customer_Cohort AS(
	SELECT customer_unique_id, MIN(Order_Month) AS Cohort_month
	FROM customer_monthly_activity
	GROUP BY Customer_unique_id
),
Cohort_Activity AS(
	SELECT Customer_Monthly_Activity.customer_unique_id, 
	Customer_Monthly_Activity.order_month, 
	Customer_Cohort.cohort_month, 
	((EXTRACT(YEAR FROM Customer_Monthly_Activity.Order_Month)
     - EXTRACT(YEAR FROM Customer_Cohort.Cohort_Month)) * 12) + 
	 (EXTRACT(MONTH FROM Customer_Monthly_Activity.Order_Month)
	 - EXTRACT(MONTH FROM Customer_Cohort.Cohort_Month)) AS Cohort_Index
	FROM Customer_Monthly_Activity 
	INNER JOIN Customer_Cohort ON 
	Customer_Monthly_Activity.customer_unique_id=Customer_Cohort.customer_unique_id),

Cohort_retention AS (
	SELECT Cohort_Month, Cohort_Index, 
	COUNT(DISTINCT Customer_unique_id) AS Active_Customers
	FROM Cohort_Activity
	GROUP BY Cohort_Month, Cohort_Index
),

Retention_Percentage AS (
	SELECT Cohort_month, Cohort_index, Active_customers, 
	FIRST_VALUE(Active_Customers) OVER 
	(PARTITION BY Cohort_Month ORDER BY Cohort_Index) AS First_Month_Customers, 
	ROUND( (Active_Customers*100.0/FIRST_VALUE(Active_Customers) 
	OVER (Partition BY Cohort_Month ORDER BY Cohort_Index)), 2) AS Retention_Rate
	FROM Cohort_Retention)

SELECT
    Cohort_Month,
    MAX(Retention_Rate) FILTER (WHERE Cohort_Index = 0) AS Month_0,
    MAX(Retention_Rate) FILTER (WHERE Cohort_Index = 1) AS Month_1,
    MAX(Retention_Rate) FILTER (WHERE Cohort_Index = 2) AS Month_2,
    MAX(Retention_Rate) FILTER (WHERE Cohort_Index = 3) AS Month_3,
    MAX(Retention_Rate) FILTER (WHERE Cohort_Index = 4) AS Month_4
FROM Retention_Percentage
GROUP BY Cohort_Month
ORDER BY Cohort_Month;