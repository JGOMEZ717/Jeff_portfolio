create table bank_marketing_raw(
	age int,
    job text,
    marital text,
    education text,
    "default" text,
    balance int,
    housing text,
    loan text,
    contact text,
    day int,
    month text,
    duration int,
    campaign int,
    pdays int,
    previous int,
    poutcome text,
    deposit text
);

-- create a customers table with one row per unique customer profile.
-- assigns each unique combination of personal info a customer_id.
drop table if exists customers;
create table customers as (
	select distinct
		row_number() over() as customer_id,
		age,
		job,
		marital,
		education,
		"default",
		balance, 
		housing, 
		loan 
		from bank_marketing_raw
);

alter table customers
add constraint customers_pkey primary key (customer_id);

-- create a campaigns table with one row per unique campaign interaction.
-- each campaign interaction is assigned a campaign_id.
create table campaigns as (
    select distinct
        row_number() over () as campaign_id,
        contact,
        day,
        month,
        duration,
        campaign,
        pdays,
        previous,
        poutcome
    from bank_marketing_raw
);
alter table campaigns
add constraint campaigns_pkey primary key (campaign_id);

-- create an outcomes table that links customers to campaigns.
-- deposit is the result of the interaction (yes/no).
-- each record is joined to the correct customer and campaign using all relevant fields.
drop table if exists outcomes;

create table outcomes (
    outcome_id serial primary key,
    deposit text,
    customer_id int,
    campaign_id int,
    foreign key (customer_id) references customers(customer_id),
    foreign key (campaign_id) references campaigns(campaign_id)
);

-- populate outcomes by joining customers and campaigns using matching fields
insert into outcomes (deposit, customer_id, campaign_id)
select
    r.deposit,
    c.customer_id,
    p.campaign_id
from bank_marketing_raw r
join customers c on 
    r.age = c.age and
    r.job = c.job and
    r.marital = c.marital and
    r.education = c.education and
    r."default" = c."default" and
    r.balance = c.balance and
    r.housing = c.housing and
    r.loan = c.loan
join campaigns p on 
    r.contact = p.contact and
    r.day = p.day and
    r.month = p.month and
    r.duration = p.duration and
    r.campaign = p.campaign and
    r.pdays = p.pdays and
    r.previous = p.previous and
    r.poutcome = p.poutcome;
-- purpose: 
-- analyze the last marketing campaign to identify key patterns and insights
-- that can improve the effectiveness of future campaigns

-- approach:
-- this analysis combines data from the customers, campaigns, and outcomes tables
-- by examining customer demographics, communication methods, campaign timing
-- and prior outcomes, we can determine which segments and strategies led to higher deposit conversions

-- goal:
-- to provide actionable recommendations that help the financial institution
-- improve targeting, timing, and communication for future marketing campaigns

/* this query analyzes deposit conversion rates by customer age group.
It joins the customers and outcomes tables on customer_id,
then groups customers into age bands and calculates how many made a deposit.
The conversion rate is calculated to help identify which age groups are more likely to open a deposit */

-- which age group is most likely to open a deposit 

select
	case
		when c.age < 30 then 'under 30'
		when c.age between 30 and 39 then '30-39'
		when c.age between 40 and 49 then '30-49'
		when c.age between 50 and 59 then '50-59'
		else '60+'
	end as age_group,
	count(*) as total_customers,
	sum(case when o.deposit = 'yes' then 1 else 0 end) as deposits,
	round(100.0 * sum(case when o.deposit = 'yes' then 1 else 0 end)/count(*), 2) as conversion_rate
from customers as c
join outcomes as o on c.customer_id = o.customer_id
group by age_group
order by conversion_rate desc;

/* this query evaluates how effective each contact method like cellular or telephone is
in converting customers to open a deposit.
It joins the campaigns and outcomes tables and calculates the success rate for each method. */

-- which contact method leads to the highest deposit conversion rate?

select 
	ca.contact,
	count(*) as total_contacts,
	sum(case when o.deposit = 'yes' then 1 else 0 end) as successful_deposits,
	round(100.0 * sum(case when o.deposit = 'yes' then 1 else 0 end)/count(*),2) as success_rate
from campaigns as ca
join outcomes as o on ca.campaign_id = o.campaign_id
group by ca.contact
order by success_rate desc;

/* This query determines which months have the highest deposit conversion rates.
It joins campaign and outcomes tables and groups results by month to see seasonal trends in success.*/

-- when is the best month to run marketing campaigns for deposits?

select 
	c.job,
	count(*) as total_customers,
	sum(case when o.deposit = 'yes' then 1 else 0 end) as deposits,
	round(100.0 * sum(case when o.deposit = 'yes' then 1 else 0 end)/count(*), 2) as conversion_rate
from customers as c
join outcomes as o on c.customer_id = o.customer_id
group by c.job
order by conversion_rate desc;

-- what martial status has the highest successful conversion rate?

select 
	marital,
	count(deposit) deposit
from bank_marketing_raw
where deposit = 'yes'
group by 1
order by 2 desc