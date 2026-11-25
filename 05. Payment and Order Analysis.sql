/*
====================================================
PROJECT: OLIST E-COMMERCE ANALYSIS
CATEGORY: Payment and Order Analysis
====================================================
*/

/*
====================================================
PAYMENT ANALYSIS
====================================================
*/

/*
====================================================
QUERY: 01
BUSINESS QUESTION: Payment Method Distribution
*/
SELECT Payment_type, 
	COUNT(*) AS Total_Payments, 
	COUNT(DISTINCT order_id) AS Total_Orders, 
	ROUND((COUNT(*)/SUM(COUNT(*)) OVER())*100.0, 2)AS Payment_Percentage
FROM Order_Payments
GROUP BY Payment_Type

/*
====================================================
QUERY: 02
BUSINESS QUESTION: Payment Value Contribution
*/
SELECT Payment_type, 
	SUM(Payment_value) AS Total_payment_value,
	ROUND((SUM(Payment_value)/SUM(SUM(Payment_value)) OVER())*100.0, 2)AS Payment_value_Percentage
FROM Order_Payments
GROUP BY Payment_Type

/*
====================================================
QUERY: 03
BUSINESS QUESTION: Average Payment Value by Payment Method
*/
SELECT Payment_type, 
	COUNT(*) AS Total_Payments, 
	ROUND((SUM(Payment_value)/SUM(SUM(Payment_value)) OVER())*100.0, 2)AS Payment_value_Percentage,
	ROUND(AVG(Payment_value), 2) AS Avg_Payment_value
FROM Order_Payments
GROUP BY Payment_Type

/*
====================================================
QUERY: 04
BUSINESS QUESTION: Payment Installments Distribution
*/
SELECT Payment_installments,
	COUNT(*) AS Total_Payments,
	COUNT(DISTINCT order_id) AS Total_Orders
FROM order_payments
GROUP BY Payment_installments
ORDER BY Payment_installments DESC

/*
====================================================
QUERY: 05
BUSINESS QUESTION: Average Installment by Payment Method
*/
SELECT Payment_type, 
	COUNT(*) AS Total_Payments, 
	ROUND(AVG(Payment_installments), 2) AS Avg_Installments
	FROM Order_Payments
GROUP BY Payment_Type
ORDER BY Avg_Installments DESC

/*
====================================================
ORDER AND DELIVERY ANALYSIS
====================================================
*/
/*
====================================================
QUERY: 01
BUSINESS QUESTION: Order Status Distribution
*/
SELECT Order_status, COUNT(order_id) as Total_Orders,
	ROUND((COUNT(*)/SUM(COUNT(*)) OVER())*100.0, 2) AS Status_percentage
	FROM Orders
GROUP BY Order_status
ORDER BY Status_percentage DESC
/*
====================================================
QUERY: 02
BUSINESS QUESTION: Average Delivery Time
*/
SELECT ROUND(AVG((EXTRACT(EPOCH FROM order_delivered_customer_date-order_purchase_timestamp)/86400.0)), 2)
	AS Avg_Delivery_time
	FROM Orders
WHERE order_status='delivered'

/*
====================================================
QUERY: 03
BUSINESS QUESTION: Actual vs Estimated Delivery Time
*/
SELECT Order_id, ROUND(EXTRACT(EPOCH FROM order_delivered_customer_date-order_purchase_timestamp)/86400.0, 2)
	AS Actual_Delivery_Days,
	ROUND(EXTRACT(EPOCH FROM order_estimated_delivery_date-order_purchase_timestamp)/86400.0, 2) 
	AS Estimated_Delivery_Days
FROM Orders
WHERE Order_status = 'delivered'

/*
====================================================
QUERY: 04
BUSINESS QUESTION: Percentage of Late-delivered Orders
*/
SELECT COUNT(*) AS Total_Orders_Delivered,
	COUNT(*) FILTER (WHERE order_estimated_delivery_date<order_delivered_customer_date) AS Late_Delivered_Orders,
	ROUND((COUNT(*) FILTER (WHERE order_estimated_delivery_date<order_delivered_customer_date)*1.0/COUNT(*))*100.0, 2)
	AS Late_Delivery_Percentage
	FROM orders
WHERE order_status ='delivered'

/*
====================================================
QUERY: 05
BUSINESS QUESTION: Monthly Late Delivery Trend
*/
SELECT DATE_TRUNC('month', order_delivered_customer_date) AS Delivery_Month,
	COUNT(*) AS Total_Orders_Delivered,
	COUNT(*) FILTER (WHERE order_estimated_delivery_date<order_delivered_customer_date) AS Late_Delivered_Orders,
	ROUND((COUNT(*) FILTER (WHERE order_estimated_delivery_date<order_delivered_customer_date)*1.0/COUNT(*))*100.0, 2)
	AS Late_Delivery_Percentage
	FROM orders
WHERE order_status ='delivered'
GROUP BY Delivery_month
ORDER BY Delivery_month

