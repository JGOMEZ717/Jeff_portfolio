-- purpose:
-- to analyze global video game sales trends across regions 
-- and platforms to uncover insights about market performance, 
-- top-selling games, and regional preferences.

-- approach:
-- used common table expressions ctes, aggregations, and filtering to:
-- identify top-selling games globally and by region
-- analyze platform and publisher performance over time
-- explore regional market differences
-- visualized trends using pivot tables or bi tools like tableau

-- goal:
-- best-selling games by region
-- shifts in sales over time
-- regional market differences

-- each cte returns the region name, game title, and its corresponding sales value
with top_na as (
	select 'na' as region, name_cleaned as game, na_sales as sales
	from vgsales
	where na_sales is not null
	order by na_sales desc
	limit 1
),
top_eu as (
	select 'eu' as region, name_cleaned as game, eu_sales as sales
	from vgsales
	where eu_sales is not null
	order by eu_sales desc
	limit 1
),
top_jp as (
	select 'jp' as region, name_cleaned as game, jp_sales as sales
	from vgsales
	where jp_sales is not null
	order by jp_sales desc
	limit 1
),
top_other as (
	select 'other' as region, name_cleaned as game, other_sales as sales
	from vgsales
	where other_sales is not null
	order by other_sales desc
	limit 1
)
select * from top_na
union all
select * from top_eu
union all
select * from top_jp
union all
select * from top_other;

-- best-selling games in each region

with top_na as (
	select 'na' as region, name_cleaned as game, na_sales as sales
	from vgsales
	where na_sales is not null
	order by na_sales desc
	limit 1
),
top_eu as (
	select 'eu' as region, name_cleaned as game, eu_sales as sales
	from vgsales
	where eu_sales is not null
	order by eu_sales desc
	limit 1
),
top_jp as (
	select 'jp' as region, name_cleaned as game, jp_sales as sales
	from vgsales
	where jp_sales is not null
	order by jp_sales desc
	limit 1
),
top_other as (
	select 'other' as region, name_cleaned as game, other_sales as sales
	from vgsales
	where other_sales is not null
	order by other_sales desc
	limit 1
)
select * from top_na
union all
select * from top_eu
union all
select * from top_jp
union all
select * from top_other;

-- global sales trends over years
select 
	year_cleaned,
	round(sum(global_sales)::numeric, 2) as total_global_sales
from vgsales
where
	year_cleaned is not NULL
group by 1
order by 2;

-- decline in video game production led to decrease in global sales
select 
    year_cleaned,
    count(*) as total_games,
    ROUND(sum(global_sales)::numeric, 2) as total_sales
from vgsales
where year_cleaned is not null
group by year_cleaned
order by 2 desc;

--highest avg global sales per platform
select
	platform,
	round(avg(global_sales)::numeric, 2) as highest_avg_platform
from vgsales
where 
	platform is not null
	and
	global_sales is not null
group by 1
order by 2 desc;

-- best selling platform
select
	platform,
	round(sum(global_sales)::numeric, 2) as top_platform
from vgsales
where 
	platform is not null
	and
	global_sales is not null
group by 1
order by 2 desc;

--top perfoming platform
select 
	publisher,
    round(sum(global_sales)::numeric, 2) as total_global_sales
from vgsales
where
	global_sales is not null
	and
	publisher is not null
group by publisher
order by total_global_sales desc
limit 10;

-- highest genre global sales varying by region
select 
	genre,
    round(sum(global_sales)::numeric, 2) as total_global_sales,
    round(sum(na_sales)::numeric, 2) as na_sales,
    round(sum(eu_sales)::numeric, 2) as eu_sales,
    round(sum(jp_sales)::numeric, 2) as jp_sales,
    round(sum(other_sales)::numeric, 2) as other_sales
from vgsales
where 
	genre is not null
group by genre
order by total_global_sales desc
