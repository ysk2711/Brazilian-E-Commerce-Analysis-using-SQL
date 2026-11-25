# Brazilian E-Commerce Data Analysis Using PostgreSQL

## Project Overview

An exploratory data analysis project using PostgreSQL to investigate business performance, customer behaviour, product and category performance, payment patterns, delivery efficiency, freight costs and geographical trends in a Brazilian e-commerce marketplace.

The project uses the Brazilian E-Commerce Public Dataset by Olist and consists of **55 business-oriented analytical questions across seven major areas**.

The objective is to extract meaningful business insights from relational data using SQL and understand the factors influencing marketplace performance.

## About the Dataset

- **Dataset:** Brazilian E-Commerce Public Dataset by Olist
- **Source:** [Kaggle – Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Geographical coverage:** Brazil
- **Dataset period:** September 2016 – October 2018 (based on the order acquisition records)
- **Database:** PostgreSQL
- **Currency:** Brazilian Real (BRL / R$)
- **Structure:** Nine relational tables

## Database Tables

Customers - Customer and geographical information
Orders - Order status and timestamps
Order_items - Purchased products, prices and freight
Products - Product attributes and categories
Category_translation - Product category translations
Order_payments - Payment methods, values and instalments
Order_reviews - Customer reviews and ratings
Sellers - Seller information
Geolocation - Geographical coordinates

## Tools and Technologies

- **PostgreSQL:** Database querying and analytical processing.
- **pgAdmin 4:** Database management and SQL execution.

## SQL Skills and Techniques

The project demonstrates the following SQL concepts and analytical techniques:

- **Data Retrieval & Filtering:** SELECT, DISTINCT, WHERE, ORDER BY, LIMIT, OFFSET and conditional filtering.
- **Data Aggregation:** GROUP BY, HAVING, COUNT, SUM, AVG, MIN, MAX and COUNT(DISTINCT).
- **Joins:** INNER, LEFT, RIGHT and FULL OUTER JOIN; multi-table joins and relational data analysis.
- **Subqueries & Set Operations:** Nested and correlated subqueries, EXISTS, NOT EXISTS, UNION, UNION ALL, INTERSECT and EXCEPT.
- **Conditional Logic:** CASE WHEN, COALESCE and NULL handling.
- **String & Date Operations:** String functions, DATE_TRUNC, EXTRACT, timestamp arithmetic and interval operations.
- **Common Table Expressions:** CTEs, multiple CTEs and chained CTEs for complex analytical queries.
- **Window Functions:** OVER(), PARTITION BY, ROW_NUMBER(), RANK(), DENSE_RANK(), LAG(), LEAD(), running totals and percentage calculations.
- **Data Exploration & Quality Checks:** NULL and duplicate identification, blank value detection, candidate key validation, primary key definitions and relationship assessment.

### Business and Analytical Methods

- Sales and revenue trend analysis
- Customer segmentation and repeat-purchase analysis
- Cohort and customer retention analysis
- Product and category performance analysis
- Month-over-month growth analysis
- Payment method and instalment analysis
- Order fulfilment and delivery performance analysis
- Freight cost and contribution analysis
- Geographical and state-wise analysis
- Ranking, top-N and percentage contribution analysis

## Analysis Areas

The project covers 55 analytical questions across seven business domains:

Sales Performance Analysis - 9
Customer Behaviour Analysis - 10
Product Analysis - 8
Category Analysis - 10
Payment & Order Delivery Analysis - 10
Freight Analysis - 4
Geographic Analysis - 4


## Key Business Insights

### 1. Sales Performance

- November 2017 recorded the highest monthly revenue of **R$ 987,765** and the highest order volume of **7,289 orders**.
- December 2016 recorded the lowest monthly revenue and order volume, at R$ 10.90 and one order, respectively.
- Monthly revenue and order volume followed broadly similar trends, reaching their peaks in November 2017.
- January 2017 recorded exceptionally high month-over-month revenue growth due to the very low December 2016 baseline.

### 2. Customer Behaviour

- The dataset contained **93,358 unique customers**, of whom only **3.00%** made repeat purchases.
- Repeat customers had average cumulative spending of **R$ 260.05**, compared with R$ 137.96 for one-time customers.
- Repeat customers placed an average of 2.11 orders, compared with 1.00 for one-time customers.
- Despite higher cumulative spending, repeat customers had a lower average customer-level order value (R$ 122.96 versus R$ 137.96).
- Customer retention analysis indicated low repeat-purchase activity across acquisition cohorts.

### 3. Product and Category Performance

- The highest-selling individual product recorded **520 units sold across 425 orders**.
- The highest revenue-generating product generated **R$ 63,560** from 194 units sold.
- Health & Beauty was the highest revenue-generating category, contributing **R$ 1.23 million (9.45% of total product revenue)**.
- Watches & Gifts ranked second, generating R$ 1.17 million (8.94%).
- Bed Bath & Table recorded the highest sales volume, with **10,953 units sold**, despite ranking third in category revenue.

### 4. Payment Analysis

- Credit cards were the dominant payment method, accounting for **73.92% of payment records**.
- Credit card transactions contributed **78.34% of total payment value**, amounting to approximately R$ 12.54 million.
- Credit card payments recorded the highest average payment value per payment record at R$ 163.32.
- Credit card transactions averaged 3.51 instalments, while other payment methods averaged one instalment.

### 5. Order and Delivery Performance

- Approximately **97.02% of all orders were successfully delivered**, representing 96,478 orders.
- The average delivery time was **12.56 days**.
- Of all delivered orders, 7,826 were delivered later than their estimated delivery dates, resulting in an overall late delivery rate of **8.11%**.
- April 2018 recorded a particularly high late delivery rate of **18.62%**, indicating a period of weaker delivery punctuality.

### 6. Freight Analysis

- Total freight charges amounted to **R$ 2.20 million**, with an average freight charge of R$ 19.95 per order item.
- Freight represented **14.26% of the combined product and freight value**.
- The Computers category recorded the highest average freight charge among the leading categories analysed, at R$ 48.57 per item.
- São Paulo generated the highest total freight value, approximately R$ 702,070.

### 7. Geographic Analysis

- São Paulo accounted for **41.92% of the customer base**, with 40,302 unique customers.
- São Paulo also generated the highest total product revenue, approximately **R$ 5.07 million**.
- Paraíba recorded the highest average order value among Brazilian states, at R$ 217.77.
- Roraima had the lowest customer concentration, with 45 unique customers.

## Conclusion

This project demonstrates the application of PostgreSQL for exploratory data analysis and business problem-solving using a real-world relational e-commerce dataset.

The analysis highlights important patterns in sales performance, customer retention, product and category contribution, payment preferences, delivery efficiency, freight costs and geographical distribution.

Among the key findings, the low repeat-purchase rate, dominance of credit card payments, significant freight contribution and geographical concentration of customers and revenue offer useful perspectives on marketplace performance.

The project also strengthened practical SQL skills, particularly in relational database analysis, advanced aggregations, CTEs, subqueries and window functions.

---

*Note: Revenue figures represent product revenue unless otherwise specified. Freight is analysed separately, and all monetary values are expressed in Brazilian Reais (BRL). Customer retention metrics are based on delivered-order cohorts.*
