drop table if exists online_sales;
Create table online_sales (
	invoiceno varchar(25),
	stock_code varchar(20),
	description varchar(255),
	quantity int, 
	invoice_date date,
	unit_price float,
	revenue float, 
	customer_id varchar(100), 
	customer_type varchar(100), 
	country text,
	flagged text
); 

-- purpose:
-- to explore customer purchasing behavior, product performance,
-- and sales patterns in an e-commerce setting using transaction level data.

-- approach:
-- cleaned data handled missing values, removed extra columns, standardized columns
-- identify top selling and most returned products
-- analyze total and seasonal revenue trends
-- compare guest vs known customer behavior
-- explore return rates and country-level revenue

-- goal:
-- which products generate the most revenue?
-- are there seasonal spikes in sales?
-- should we encourage guest to customer conversion?
-- which countries contribute most to sales?

-- this query gives you the top 5 products by revenue and their return rates.
-- also had to offset some results because they were misc.

select 
    description,
    Round(sum(revenue)::numeric, 0) as total_revenue,
    round(count(*) filter (where flagged = 'return')::numeric / count(*), 2) as return_rate_percent
from online_sales
where 
	description is not null
	and
	revenue is not null
group by description
order by total_revenue desc
limit 5 
offset 4;

-- Total revenue by month
select 
    date_trunc('month', invoice_date) as month,
    round(sum(revenue)::numeric, 0) as monthly_revenue
from online_sales
group by month
order by month;

--This shows how many transactions come from guests vs known customers

select 
    customer_type,
    count(*) as total_transactions,
    round(sum(revenue)::numeric, 0) as total_revenue,
    round(100.0 * count(*) / sum(count(*)) over (), 2) as percent_of_transactions
from online_sales
group by customer_type;