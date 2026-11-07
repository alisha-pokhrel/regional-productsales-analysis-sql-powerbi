/*

PROJECT: Product Sales Analysis
DATABASE: PostgreSQL

OBJECTIVE: To analyze product sales data to identify revenue trends,
regional performance, customer patterns, and order returns.

Analysts:
1. Revenue by Region
2. Monthly Revenue
3. No of returned vs unreturned order
4. Revenue by Customer Type
5. Revenue by Payment
6. Revenue by Product 

*/
-- 1. Revenue by Region
SELECT 
	sum(psr."TotalPrice" ) AS revenue,
	psr."Region"
FROM
	product_sales_region psr
GROUP BY
	psr."Region"
ORDER BY
	"revenue" DESC;
-- 2. Monthly Revenue
SELECT
	DATE_TRUNC('month', psr."OrderDate")::DATE AS MONTH,
	SUM(psr."TotalPrice") AS revenue
FROM
	product_sales_region psr
GROUP BY
	DATE_TRUNC('month', psr."OrderDate")
ORDER BY
	MONTH;
-- 3. No of returned vs unreturned order
WITH no_of_return AS (
SELECT 
	count(psr."Returned" ) AS RETURN
FROM
	product_sales_region psr
WHERE
	psr."Returned" = 1
),
no_of_unreturn AS (
SELECT 
	count("Returned") AS unreturn
FROM
	product_sales_region psr
WHERE
	"Returned" = 0
)
SELECT
	count (DISTINCT "OrderID" ) AS orders,
	"return",
	unreturn
FROM
	product_sales_region psr
CROSS JOIN no_of_return
CROSS JOIN no_of_unreturn
GROUP BY
	"return",
	unreturn ;
-- 4. Revenue by Customer Type
SELECT
	sum(psr."TotalPrice" ) AS revenue,
	psr."CustomerType"
FROM
	product_sales_region psr
GROUP BY
	psr."CustomerType";
-- 5. Revenue by Payment
SELECT
	sum(psr."TotalPrice" ) AS revenue,
	psr."PaymentMethod"
FROM
	product_sales_region psr
GROUP BY
	psr."PaymentMethod" ;
--6.Revenue by Product
SELECT
	sum(psr."TotalPrice" ) AS revenue,
	psr."Product"
FROM
	product_sales_region psr
GROUP BY
	psr."Product";
