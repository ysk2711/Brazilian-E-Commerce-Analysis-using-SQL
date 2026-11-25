/*
====================================================
PROJECT: OLIST E-COMMERCE ANALYSIS
CATEGORY: Sales Performance Analysis
====================================================
*/

/*
====================================================
QUERY: 01
BUSINESS QUESTION: Total orders and revenue.
*/
SELECT 
	COUNT(orders.order_id) AS Total_Delivered_Orders,
	SUM(order_items.price) AS Total_Revenue
	FROM Order_items JOIN Orders ON
	Order_items.order_id=Orders.order_id
WHERE orders.order_status='delivered'

/*
====================================================
QUERY: 02
BUSINESS QUESTION: Monthly Sales Performance
*/
SELECT
    DATE_TRUNC('month', orders.order_purchase_timestamp) AS sales_month,
    SUM(order_items.price) AS product_revenue,
    COUNT(DISTINCT orders.order_id) AS delivered_orders,
    COUNT(order_items.order_item_id) AS items_sold,

    ROUND(
        SUM(order_items.price) /
        COUNT(DISTINCT orders.order_id),
        2
    ) AS average_order_value

FROM order_items
JOIN orders
    ON order_items.order_id = orders.order_id
WHERE orders.order_status = 'delivered'
GROUP BY sales_month
ORDER BY sales_month;

/*
====================================================
QUERY: 03
BUSINESS QUESTION: Quarterly Sales Performance
*/
SELECT
    DATE_TRUNC('quarter', orders.order_purchase_timestamp) AS sales_quarter,
    SUM(order_items.price) AS product_revenue,
    COUNT(DISTINCT orders.order_id) AS delivered_orders,
    COUNT(order_items.order_item_id) AS items_sold,

    ROUND(
        SUM(order_items.price) /
        COUNT(DISTINCT orders.order_id),
        2
    ) AS average_order_value

FROM order_items
JOIN orders
    ON order_items.order_id = orders.order_id
WHERE orders.order_status = 'delivered'
GROUP BY sales_quarter
ORDER BY sales_quarter;

/*
====================================================
QUERY: 04
BUSINESS QUESTION: Month over Month Growth
*/
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', orders.order_purchase_timestamp) AS sales_month,
        SUM(order_items.price) AS product_revenue
    FROM order_items
    JOIN orders
        ON order_items.order_id = orders.order_id
    WHERE orders.order_status = 'delivered'
    GROUP BY sales_month
),

calendar_months AS (
    SELECT
        GENERATE_SERIES(
            MIN(sales_month),
            MAX(sales_month),
            INTERVAL '1 month'
        ) AS sales_month
    FROM monthly_sales
),

complete_monthly_sales AS (
    SELECT
        c.sales_month,
        COALESCE(m.product_revenue, 0) AS product_revenue
    FROM calendar_months c
    LEFT JOIN monthly_sales m
        ON c.sales_month = m.sales_month
),

sales_with_previous_month AS (
    SELECT
        sales_month,
        product_revenue,
        LAG(product_revenue, 1)
            OVER (ORDER BY sales_month) AS previous_month_revenue
    FROM complete_monthly_sales
)

SELECT
    sales_month,
    product_revenue,
    previous_month_revenue,
    ROUND(
        (
            (product_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS growth_percentage
FROM sales_with_previous_month
ORDER BY sales_month;

/*
====================================================
QUERY: 05
BUSINESS QUESTION: Quarter over Quarter Growth
*/
WITH Quarterly_Sales AS (
    SELECT
        DATE_TRUNC('quarter', orders.order_purchase_timestamp) AS Sales_quarter,
        SUM(order_items.price) AS Product_Revenue
    FROM Order_items
    JOIN Orders
        ON Order_items.order_id = orders.order_id
    WHERE orders.order_status = 'delivered'
    GROUP BY Sales_quarter
),

Sales_with_previous_quarter AS (
    SELECT
        Sales_quarter,
        Product_revenue,
        LAG(Product_Revenue, 1)
            OVER (ORDER BY Sales_quarter) AS Previous_quarter_revenue
    FROM Quarterly_Sales
)

SELECT
    Sales_quarter,
    Product_Revenue,
    Previous_Quarter_Revenue,
    ROUND(
        (
            (Product_Revenue - Previous_Quarter_Revenue)
            / NULLIF(Previous_Quarter_Revenue, 0)
        ) * 100,
        2
    ) AS Growth_Percentage
FROM Sales_with_previous_quarter
ORDER BY Sales_quarter;

/*
====================================================
QUERY: 06
BUSINESS QUESTION: Quarterly Sales Insights
*/
WITH quarterly_sales AS (
    SELECT
        DATE_TRUNC('quarter', orders.order_purchase_timestamp) AS sales_quarter,
        SUM(order_items.price) AS product_revenue,
        COUNT(DISTINCT orders.order_id) AS delivered_orders
    FROM order_items
    JOIN orders
        ON order_items.order_id = orders.order_id
    WHERE orders.order_status = 'delivered'
    GROUP BY sales_quarter
)

SELECT
    sales_quarter,
    product_revenue,
    delivered_orders,

    SUM(product_revenue) OVER (
        ORDER BY sales_quarter
    ) AS cumulative_product_revenue,

    SUM(delivered_orders) OVER (
        ORDER BY sales_quarter
    ) AS cumulative_delivered_orders,

    SUM(product_revenue) OVER (
        PARTITION BY EXTRACT(YEAR FROM sales_quarter)
        ORDER BY sales_quarter
    ) AS cumulative_yearly_revenue,

    RANK() OVER (
        ORDER BY product_revenue DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY delivered_orders DESC
    ) AS order_rank

FROM quarterly_sales
ORDER BY sales_quarter;

/*
====================================================
QUERY: 07
BUSINESS QUESTION: Cumulative Yearly Revenue and Orders
*/
WITH quarterly_sales AS (
    SELECT
        DATE_TRUNC('quarter', orders.order_purchase_timestamp) AS sales_quarter,
        SUM(order_items.price) AS product_revenue,
        COUNT(DISTINCT orders.order_id) AS delivered_orders
    FROM order_items
    JOIN orders
        ON order_items.order_id = orders.order_id
    WHERE orders.order_status = 'delivered'
    GROUP BY sales_quarter
)

SELECT
    sales_quarter,
    product_revenue,
    delivered_orders,

    SUM(product_revenue) OVER (
        ORDER BY sales_quarter
    ) AS cumulative_product_revenue,

    SUM(delivered_orders) OVER (
        ORDER BY sales_quarter
    ) AS cumulative_delivered_orders,

    SUM(product_revenue) OVER (
        PARTITION BY EXTRACT(YEAR FROM sales_quarter)
        ORDER BY sales_quarter
    ) AS cumulative_yearly_revenue,

    RANK() OVER (
        ORDER BY product_revenue DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY delivered_orders DESC
    ) AS order_rank

FROM quarterly_sales
ORDER BY sales_quarter;

