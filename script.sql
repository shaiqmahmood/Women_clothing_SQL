--Q1.Calculate total revenue for each month.

--Total revenue distribution over period of four months.
select 
	to_char(order_date,'YYYY-MM') as	month_year,
	sum(revenue) as total_revenue
from
women_clothing_ecommerce_sales 
group by 
	month_year,date_part('month',order_date)
order by 
	date_part('month',order_date) asc;




--Q2.Calculate total revenue for each SKU.

--Aggregate revenue by sku to identify top-performing products.
SELECT 
    sku, 
    SUM(revenue) AS total_revenue
FROM 
    women_clothing_ecommerce_sales
GROUP BY 
    sku
ORDER BY 
    total_revenue DESC;




--Q3.Calculate Revenue and Quantity for color and size.

--Revenue and quantity by color and size to determine popular product attributes and stock.
select 
	color, 
	size,
	sum(revenue) as total_revenue,
	sum(quantity) as total_quantity
from  
	women_clothing_ecommerce_sales 
group by 
	color,size
order by 
	total_revenue desc;




--Q4.Calculate total revenue for each quarter.

--Revenue trends quarterly to identify peak sales periods and seasonal patterns.
select 
	date_part('year',order_date) as year,
	ceil(date_part('month',order_date)/3.0) as quarter,
	sum(revenue) as total_revenue
from
	women_clothing_ecommerce_sales
group by 
	quarter,year 
order by
	year,quarter desc;




--Q5.Calculate daily total revenue over entire period.

--Revenue trends daily over the 4 months to identify peak sales days in a week.
select
	to_char(order_date,'Day') as day_of_week,
	sum(revenue) as total_revenue
from
	women_clothing_ecommerce_sales wces
group by
	day_of_week
order by
	total_revenue desc;




--Q6.Calculate hourly total revenue over entire period.

--Revenue trends hourly over 4 months to identify peak sales hours in a day.
select 
	date_part('hour',order_date) as hour_of_the_day,
	sum(revenue) as total_revenue
from
	women_clothing_ecommerce_sales wces 
group by
	hour_of_the_day
order by
	total_revenue desc;




--Q7.Calculate Highest Revenue Days over entire period.

--Highest Revenue Days Over a Four-Month Period 
select 
	to_char(order_date,'yyyy-mm-dd') as date,
	to_char(order_date,'Day') as day,
	date_part('week',order_date) as week,
	sum(revenue) as total_revenue
from
	women_clothing_ecommerce_sales 
group by
	date,day,week
order by
	total_revenue desc;




--Q8.Calculate Highest Weekly Revenue over entire period.

--Highest Weekly Revenue During a Four-Month Period
select 
	date_part('Week',order_date) as week,
	sum(revenue) as total_revenue
from
	women_clothing_ecommerce_sales 
group by
	week 
order by
	total_revenue desc;




--Q9.Calculate Top 3 Revenue performers Monthly,Weekly and Daily.

--Highest Revenue by Day, Week, and Month: Top 3 Performers
WITH DailyRanked AS (
    SELECT 
        TO_CHAR(order_date, 'Mon DD, YYYY') AS frequency,
        SUM(revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(revenue) DESC) AS rank
    FROM women_clothing_ecommerce_sales
    GROUP BY TO_CHAR(order_date, 'Mon DD, YYYY')
),
WeeklyRanked AS (
    SELECT 
        TO_CHAR(order_date, 'IW-IYYY') AS frequency,
        SUM(revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(revenue) DESC) AS rank
    FROM women_clothing_ecommerce_sales
    GROUP BY TO_CHAR(order_date, 'IW-IYYY')
),
MonthlyRanked AS (
    SELECT 
        TO_CHAR(order_date, 'Month IYYY') AS frequency,
        SUM(revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(revenue) DESC) AS rank
    FROM women_clothing_ecommerce_sales
    GROUP BY TO_CHAR(order_date, 'Month IYYY')
)
SELECT 'Daily' AS period, frequency, total_revenue
FROM DailyRanked
WHERE rank <= 3
UNION ALL
SELECT 'Weekly' AS period, frequency, total_revenue
FROM WeeklyRanked
WHERE rank <= 3
UNION ALL
SELECT 'Monthly' AS period, frequency, total_revenue
FROM MonthlyRanked
WHERE rank <= 3;




--Q10.Calculate Highest Order Volumes Monthly,Weekly,Daily

--Highest Order Volumes: Daily, Weekly, and Monthly Leaders
WITH DailyRanked AS (
    SELECT 
        TO_CHAR(order_date, 'Mon DD, YYYY') AS frequency,
        COUNT (distinct order_id) AS order_count,
        ROW_NUMBER() OVER (ORDER BY COUNT (distinct order_id) DESC) AS rank
    FROM women_clothing_ecommerce_sales
    GROUP BY TO_CHAR(order_date, 'Mon DD, YYYY')
),
WeeklyRanked AS (
    SELECT 
        TO_CHAR(order_date, 'IW-IYYY') AS frequency,
        COUNT (distinct order_id) AS order_count,
        ROW_NUMBER() OVER (ORDER BY COUNT (distinct order_id) DESC) AS rank
    FROM women_clothing_ecommerce_sales
    GROUP BY TO_CHAR(order_date, 'IW-IYYY')
),
MonthlyRanked AS (
    SELECT 
        TO_CHAR(order_date, 'Month IYYY') AS frequency,
        COUNT (distinct order_id) AS order_count,
        ROW_NUMBER() OVER (ORDER BY COUNT (distinct order_id) DESC) AS rank
    FROM women_clothing_ecommerce_sales
    GROUP BY TO_CHAR(order_date, 'Month IYYY')
)
SELECT 'Daily' AS period, frequency, order_count
FROM DailyRanked
WHERE rank <= 3
UNION ALL
SELECT 'Weekly' AS period, frequency, order_count
FROM WeeklyRanked
WHERE rank <= 3
UNION ALL
SELECT 'Monthly' AS period, frequency, order_count
FROM MonthlyRanked
WHERE rank <= 3;




--Q11.Calculate Color Distribution for 'Dark Blue','Light Blue','Black' and 'Others'.

--Sales Contribution by Product Color
SELECT 
    CASE
        WHEN LOWER(color) = 'dark blue' THEN 'Dark Blue'
        WHEN LOWER(color) = 'light blue' THEN 'Light Blue'
        WHEN LOWER(color) = 'black' THEN 'Black'
        ELSE 'Others'
    END AS color_group,
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()), 2) AS percentage
FROM 
    women_clothing_ecommerce_sales 
GROUP BY 
    color_group
ORDER BY 
    total_count DESC;
