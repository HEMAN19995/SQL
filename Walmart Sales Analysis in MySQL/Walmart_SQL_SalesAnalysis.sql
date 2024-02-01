-- creating database
create database if not exists walmartSales;

-- use db walmartSales
use walmartSales;

-- creating table sales
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- data cleaning
select * from sales;

-- forming category i.e period of the day
select 
	time,
    (case 
		when time between '00:00:00' and '12:00:00' then 'Morning'
        when time between '12:00:01' and '16:00:00' then 'Afternoon'
        else 'Evening' 
	end) as 'time_of_day'
from sales;

-- alter table i.e adding column to the sales table
alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
		case 
			when time between '00:00:00' and '12:00:00' then 'Morning'
			when time between '12:00:01' and '16:00:00' then ' Afternoon'
			else 'Evening' 
		end);
        
-- add dayname column
select date, dayname(date)
from sales;

alter table sales add column day_name varchar(10);
        
-- update day name column with the data
update sales
set day_name = dayname(date);
        
-- add month name column
select date, monthname(date)
from sales;

alter table sales add column month_name varchar(12);

update sales
set month_name = monthname(date);
        
select * from sales;

-- --------- Questions -----------
-- How many unique cities does the data have?
select distinct city from sales;
select count(distinct city) as Total_Cities_count from sales;
        
-- In which city is each branch?
select distinct city, branch from sales;
        
-- ---------------------------- Product -------------------------------
select * from sales;

-- How many unique product lines does the data have?
select distinct product_line from sales;

-- What is the most selling product line
select product_line, sum(quantity) as sold_quantities from sales
group by product_line
order by sold_quantities desc;

-- What is the total revenue by month
select month_name, round(sum(total),2) as Revenue
from sales
group by month_name
order by Revenue desc;

-- What month had the largest COGS?
select month_name, round(sum(cogs),2) as total_Cogs
from sales
group by month_name
order by total_Cogs desc;

-- What product line had the largest revenue?
select product_line, round(sum(total),2) as Revenue
from sales
group by product_line
order by Revenue desc
limit 1;

-- What is the city with the largest revenue?
select branch, city, round(sum(total),2) as Revenue
from sales
group by branch, city
order by Revenue desc;

select avg(quantity) as avg_qnty
from sales;

select product_line,
		case 
			when avg(quantity) > 5.49 then 'good'
            else 'bad' end as remark
from sales
group by product_line;

-- Which branch sold more products than average product sold?
select branch, sum(quantity) as qnty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender
select gender, product_line, (count(product_line)) as count
from sales
group by gender, product_line
order by count desc;

-- What is the average rating of each product line
select product_line, round(avg(rating),2) as rating from sales
group by product_line;

-- ---------------------------- Sales ---------------------------------
select * from sales;
-- Number of sales made in each time of the day per weekday 
select day_name, time_of_day, count(invoice_id) as sales_count 
from sales
group by day_name, time_of_day
order by sales_count desc;

-- Which of the customer types brings the most revenue?
select customer_type, round(sum(total),2) as Revenue
from sales
group by customer_type
order by Revenue desc;

-- Which city has the largest tax/VAT percent?
select city, max(tax_pct) as max_tax from sales
group by city;

-- Which city has the largest avg tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
