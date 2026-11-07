/*

PROJECT: Product Sales Analysis
DATABASE: PostgreSQL

DESCRIPTION:
Calculate key performance indicators (KPIs) to evaluate overall product sales performance.

KPIs:
1. Total Revenue
2. Total Orders
3. Total Quantity Sold
4. Return Rate
5. Average Order Value
6. Revenue Growth Percentage

*/

-- 1. TOTAL REVENUE
SELECT
	sum(p."TotalPrice") AS Total_Revenue
FROM
	product_sales_region AS p ;

-- 2. TOTAL ORDERS
SELECT
	count( DISTINCT psr."OrderID" ) AS Total_Orders
FROM
	product_sales_region psr ;

-- 3. TOTAL QUANTITY SOLD
SELECT
	sum(psr."Quantity" ) AS Total_Quantity_Sold
FROM
	product_sales_region psr;

-- 4. RETURN RATE (%)
SELECT
	round(100 *(sum( psr."Returned" )/ count( DISTINCT psr."OrderID" )), 2) AS Return_rate
FROM
	product_sales_region psr;

-- 5. AVERAGE ORDER VALUE
SELECT
	round(
			sum(psr."TotalPrice")::NUMERIC / 
			count( DISTINCT psr."OrderID"), 2)
			AS Average_Order_value
FROM
	product_sales_region psr ;

-- 6. YEAR-OVER-YEAR REVENUE GROWTH (%)
WITH yearly_revenue AS (
SELECT
	sum(psr."TotalPrice" ) AS revenue,
		EXTRACT(YEAR FROM "OrderDate") AS YEAR
FROM
	product_sales_region psr
GROUP BY
	EXTRACT(YEAR FROM "OrderDate")
),
    revenue_growth AS(
    SELECT "year", "revenue",
    	lag("revenue") OVER(ORDER BY "year") AS previous_revenue
    FROM yearly_revenue
    )
 SELECT
	YEAR,
	ROUND(
        (("revenue" - "previous_revenue") /
        NULLIF("previous_revenue", 0))::NUMERIC * 100,
        2
    ) AS revenue_growth_percentage
FROM
	revenue_growth;
