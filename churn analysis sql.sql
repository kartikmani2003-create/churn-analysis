create database if not exists churn;
use churn;
select*from customer_subscription_churn_usage_patterns;
select distinct tenure_months from customer_subscription_churn_usage_patterns
order by tenure_months desc;

-- login frequency
-- 1 percentage of not login
with counts as ( select count(last_login_days_ago) total_customer from customer_subscription_churn_usage_patterns),

not_recent as ( select count(last_login_days_ago) no_login from customer_subscription_churn_usage_patterns
where last_login_days_ago>7)


select c.total_customer,n.no_login,
n.no_login*100/c.total_customer as not_login_percentage
from counts c cross join not_recent n;

-- 2 login frequency differ between churn and active

select churn,count(user_id) total_users,round(avg(last_login_days_ago),2)as avg_last_login,
round(avg(avg_weekly_usage_hours),2) as avg_week_usage
from customer_subscription_churn_usage_patterns
group by churn;


-- 3 likely to churn

with id as (select user_id,last_login_days_ago from customer_subscription_churn_usage_patterns),

naming as (select user_id,last_login_days_ago,
case
when last_login_days_ago between 0 and 30 then "not churn" 
when last_login_days_ago between 31 and 40 then "Likely to churn"
when last_login_days_ago between 41 and 50 then "Almost churn"
else 'churn'
end serve
from id
order by last_login_days_ago)

select serve,count(*) as total ,count(*)*100/( select count(*) from customer_subscription_churn_usage_patterns) as percentage
 from naming
 group by serve;
 
 
 -- 4 percentage of churn and no churned
 
 select churn,avg(last_login_days_ago) as percnetage from 
 customer_subscription_churn_usage_patterns
 group by churn;
 
 -- 5 which plan have most inactive users
 
 with users as( select*,
 case
 when last_login_days_ago>40 then 'inactive'
 else 'active'
 end active_users
 from customer_subscription_churn_usage_patterns)
 
 select plan_type,count(*) total_users
 from users
 where active_users="inactive"
 group by plan_type
 order by total_users desc;
 
 
 -- payment delays/payment_failures
 -- 1 does the number of payment failures increase the likelihood of churn
 select payment_failures ,count(*) as total_users,sum(case when churn="yes" then 1 else 0 end) as churn_customer,
 round(sum(case when churn="yes" then 1 else 0 end)*100/count(*),2) as percentage
 from customer_subscription_churn_usage_patterns
 group by payment_failures 
 order by payment_failures;
 
 
 -- 2 percentege of users with payment failure have churned
 
 select round(sum(case when churn="yes" then 1 else 0 end)*100/count(*),2) as percentage
 from customer_subscription_churn_usage_patterns
 where payment_failures>0;
 
 -- 3 which plan type has the highest number of churn of payment faailure
 
 select plan_type,count(payment_failures) as payment_fail_count from customer_subscription_churn_usage_patterns
 where payment_failures>0
 group by plan_type;
 
 
 -- 4 what is avg no. of payment  failures for churned vs active
 
 select churn,round(avg(payment_failures),2) as average,count(*) as total_users
 from customer_subscription_churn_usage_patterns
 group by churn;
 
 -- 5 does monthly fee have any reltionship with payment failures and churn
 
 select monthly_fee,sum(case when churn="yes" then 1 else 0 end) churn_customer,
  round(sum(case when churn="yes" then 1 else 0 end)*100/count(*),2) as percentage,
  round(avg(payment_failures),2) as avg_payment_failurer
  from customer_subscription_churn_usage_patterns
  where payment_failures>0
  group by monthly_fee;
 
-- complaints

-- 1 dose a higher number of  support tickets increase customer churn

select support_tickets,count(*) as total_users,sum(case when churn="yes" then 1 else 0 end) as churn_customer,
round(sum(case when churn="yes" then 1 else 0 end)*100/count(*),2) as percentage
from customer_subscription_churn_usage_patterns
group by support_tickets
order by  support_tickets;
 
-- 2 average number of support tickets for churned and active
select churn,count(*) as total,round(avg(support_tickets),2) as avg_support_tickets from
customer_subscription_churn_usage_patterns
group by churn;

-- 3 which plan type genterated the most support tickets

select plan_type,count(*) total_users,sum(support_tickets) total_support_tickets,round(avg(support_tickets),2),
sum(case when churn="yes" then 1 else 0 end) as churn_customer,
round(sum(case when churn="yes" then 1 else 0 end)*100/count(*),2) as percentage
from customer_subscription_churn_usage_patterns
group by plan_type;


-- 4 what percentage of users with 3+ support tickets have churned
select support_tickets,count(*) total,sum(case when churn="yes" then 1 else 0 end) as churn_customer,
round(sum(case when churn="yes" then 1 else 0 end)*100/count(*),2) as percentage
from customer_subscription_churn_usage_patterns
where support_tickets>=3
group by support_tickets
order by percentage desc;

-- 5 is there a relation ship between tickets and payment-failures
SELECT 
    ROUND(AVG(support_tickets), 2) AS avg_tickets,
    ROUND(AVG(payment_failures), 2) AS avg_failures,
    ROUND((SUM(support_tickets * payment_failures) - SUM(support_tickets) * SUM(payment_failures) / COUNT(*)) / SQRT((SUM(support_tickets * support_tickets) - POW(SUM(support_tickets), 2) / COUNT(*)) * (SUM(payment_failures * payment_failures) - POW(SUM(payment_failures), 2) / COUNT(*))),
            3) AS correlation,
    COUNT(*) AS total_users
FROM
    customer_subscription_churn_usage_patterns;
    
    
    
    -- usage trends
    
    
    -- 1 dose lower weekly usage lead to higher churn
    SELECT
 CASE 
   WHEN avg_weekly_usage_hours <= 5 THEN 'Low Usage (0-5h)'
   WHEN avg_weekly_usage_hours <= 10 THEN 'Medium Usage (5-10h)'
   WHEN avg_weekly_usage_hours <= 15 THEN 'High Usage (10-15h)'
   ELSE 'Very High (15h+)'
 END as usage_bucket,
 COUNT(*) as total_users,
 SUM(CASE WHEN churn='yes' THEN 1 ELSE 0 END) as churned,
 ROUND(SUM(CASE WHEN churn='yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) as churn_pct,
 ROUND(AVG(avg_weekly_usage_hours),2) as avg_hours_in_bucket
FROM customer_subscription_churn_usage_patterns
GROUP BY usage_bucket
ORDER BY avg_hours_in_bucket;


-- 2 what is the avg weekly usage of churn vs active users

select churn,count(*) count,round(avg(avg_weekly_usage_hours),2)
from customer_subscription_churn_usage_patterns
group by churn;

-- 3 which type plan has the highest avg week usage
select plan_type,round(avg(avg_weekly_usage_hours),2) avg_plane_rate
from customer_subscription_churn_usage_patterns
group by plan_type
order by avg_plane_rate desc;


-- 4. how customer_tenure effect customer churn

select tenure_months, count(*) total,SUM(CASE WHEN churn='yes' THEN 1 ELSE 0 END) as churned,
 ROUND(SUM(CASE WHEN churn='yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) as churn_pct
 from customer_subscription_churn_usage_patterns
 group by tenure_months
 order by tenure_months;
 
 -- 5 are new customer more likely to churn than lonh term customer
 with customers as ( select*,
 case 
 when tenure_months between 1 and 10 then 'New Customer'
 when tenure_months between 11 and 25 then 'Old Customer'
 else "loyal"
 end customer_age
 from customer_subscription_churn_usage_patterns)
 
 select customer_age,count(*) total,SUM(CASE WHEN churn='yes' THEN 1 ELSE 0 END) as churned,
  ROUND(SUM(CASE WHEN churn='yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) as churn_pct
  from customers
  group by customer_age
  order by customer_age;
 