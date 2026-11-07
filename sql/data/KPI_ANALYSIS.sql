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
select sum(p."TotalPrice") as Total_Revenue
from product_sales_region as p ;

-- 2. TOTAL ORDERS
select count( distinct psr."OrderID" ) as Total_Orders
from product_sales_region psr ;

-- 3. TOTAL QUANTITY SOLD
select sum(psr."Quantity" ) as Total_Quantity_Sold
from product_sales_region psr;

-- 4. RETURN RATE (%)
select
round(100*(sum( psr."Returned" )/ count( distinct psr."OrderID" )),2) as Return_rate
from product_sales_region psr; 

-- 5. AVERAGE ORDER VALUE
select round(
			sum(psr."TotalPrice")::NUMERIC/ 
			count( distinct psr."OrderID"),2)
			as Average_Order_value
from product_sales_region psr ;

-- 6. YEAR-OVER-YEAR REVENUE GROWTH (%)
with yearly_revenue as (
select 
        sum(psr."TotalPrice" ) as revenue,
		extract(year from "OrderDate") as year		
from product_sales_region psr 
group by extract(year from "OrderDate")
),
    revenue_growth as(
    select "year", "revenue",
    	lag("revenue") over(order by "year") as previous_revenue
    from yearly_revenue
    )
 select year,
 		ROUND(
        (("revenue" - "previous_revenue") /
        NULLIF("previous_revenue", 0))::NUMERIC * 100,
        2
    ) AS revenue_growth_percentage
 from revenue_growth;

