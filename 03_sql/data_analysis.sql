USE product_analytics_db;

SELECT count(*) as rowss
FROM cleaned_events;

SELECT count(*) as rowss
FROM cleaned_products;

SELECT count(*) as rowss
FROM cleaned_transactions;

SELECT count(*) as rowss
FROM cleaned_users;

SELECT *
FROM cleaned_users;

SELECT *
FROM cleaned_transactions;

SELECT count(distinct ct.user_id) as transaction_users,count(distinct cu.user_id) as user_users
FROM cleaned_transactions ct
RIGHT JOIN cleaned_users cu
ON ct.user_id = cu.user_id;

SELECT device , count(*)
from cleaned_users
GROUP BY device;

SELECT country,MONTHNAME(signup_date) as monthh,count(*) as no_of_signups
FROM cleaned_users
GROUP BY country,monthh
ORDER BY no_of_signups desc limit 5;

SELECT
country,
SUM(CASE WHEN monthname(signup_date)="January" THEN 1 ELSE 0 END) as jan_signup,
SUM(CASE WHEN monthname(signup_date)="February" THEN 1 ELSE 0 END) as feb_signup,
SUM(CASE WHEN monthname(signup_date)="March" THEN 1 ELSE 0 END) as mar_signup,
SUM(CASE WHEN monthname(signup_date)="April" THEN 1 ELSE 0 END) as apr_signup,
SUM(CASE WHEN monthname(signup_date)="May" THEN 1 ELSE 0 END) as may_signup,
SUM(CASE WHEN monthname(signup_date)="June" THEN 1 ELSE 0 END) as jun_signup,
SUM(CASE WHEN monthname(signup_date)="July" THEN 1 ELSE 0 END) as jul_signup,
SUM(CASE WHEN monthname(signup_date)="August" THEN 1 ELSE 0 END) as aug_signup,
SUM(CASE WHEN monthname(signup_date)="September" THEN 1 ELSE 0 END) as sep_signup,
SUM(CASE WHEN monthname(signup_date)="October" THEN 1 ELSE 0 END) as oct_signup,
SUM(CASE WHEN monthname(signup_date)="November" THEN 1 ELSE 0 END) as nov_signup,
SUM(CASE WHEN monthname(signup_date)="December" THEN 1 ELSE 0 END) as dec_signup
FROM cleaned_users
GROUP BY country
ORDER BY country;

select *
from cleaned_events;

select cp.product_name,sum(ct.amount) as revenue
FROM cleaned_transactions ct
JOIN cleaned_products cp
ON ct.product_id = cp.product_id
WHERE cp.product_id <> "P0" and ct.status = 'success'
GROUP BY cp.product_name
ORDER BY revenue desc;

select cp.category,sum(ct.amount) as revenue
FROM cleaned_transactions ct
JOIN cleaned_products cp
ON ct.product_id = cp.product_id
WHERE cp.product_id <> "P0" and ct.status = 'success'
GROUP BY cp.category
ORDER BY revenue desc;

select cp.product_name,count(*) as purchase_count
FROM cleaned_transactions ct
JOIN cleaned_products cp
ON ct.product_id = cp.product_id
WHERE cp.price <> 0
GROUP BY cp.product_name
ORDER BY purchase_count DESC;

SELECT event_type, count(distinct user_id) as unique_user_event_stage
from cleaned_events
GROUP BY event_type
ORDER BY unique_user_event_stage DESC;

SELECT
payment_method,
SUM(CASE WHEN status = 'success' THEN 1 else 0 end) as success,
SUM(CASE WHEN status = 'pending' THEN 1 else 0 end) as pending,
SUM(CASE WHEN status = 'failed' THEN 1 else 0 end) as failed
FROM cleaned_transactions
WHERE amount <> 0
group by payment_method
order by failed desc;

select *
from cleaned_transactions
where payment_method = 'no payment' and status = 'failed';

SELECT
user_id_num,
count(*) as count
from cleaned_transactions
where status = 'failed' or status = 'pending'
group by user_id_num
order by count desc;

SELECT payment_method, sum(amount) as revenue
from cleaned_transactions
where payment_method <> 'no payment' or status = 'success'
group by payment_method
order by revenue desc;

SELECT 
payment_method,
SUM(CASE WHEN status = 'failed' then 1 else 0 end)*100.0/count(*) as failure_rate
from cleaned_transactions
group by payment_method
order by failure_rate desc;

SELECT payment_method, sum(amount) as revenue
from cleaned_transactions
WHERE payment_method != 'unknown' AND status = 'success'
group by payment_method
order by revenue desc;

SELECT cp.product_name,count(*) as failed_transactions
from cleaned_transactions ct
join cleaned_products cp
on ct.product_id = cp.product_id
where ct.status = 'failed' and ct.amount <> '0'
group by cp.product_name;

select cp.category,sum(amount) as revenue
from cleaned_transactions ct
join cleaned_products cp
on ct.product_id = cp.product_id
where cp.category <> 'unknown'
group by cp.category
order by revenue desc;

select
cp.product_name,
sum(CASE WHEN ct.status = 'pending' then 1 else 0 end)*100.0/count(*) as pending_rate
from cleaned_transactions ct
join cleaned_products cp
on ct.product_id = cp.product_id
WHERE ct.amount <> '0'
GROUP BY cp.product_name
ORDER BY pending_rate desc;

SELECT user_id,count(*) as failed_transactions_only
FROM cleaned_transactions
WHERE user_id NOT IN (SELECT user_id from cleaned_transactions where status = 'success')
group by user_id
ORDER BY failed_transactions_only desc;

SELECT cu.country,avg(ct.amount) as avg_revenue
FROM cleaned_transactions ct
join cleaned_users cu
on ct.user_id = cu.user_id
WHERE amount <> 0 and status = 'success' and country != 'unknown'
group by cu.country
order by avg_revenue desc;

SELECT cu.device,SUM(CASE WHEN status = 'success' then 1 else 0 end) as devices
FROM cleaned_transactions ct
join cleaned_users cu
on ct.user_id = cu.user_id
WHERE device <> 'unknown'
group by cu.device
order by devices desc
limit 1;

SELECT 
SUM(CASE WHEN status = 'Success' then 1 else 0 end) as succ_rate_count,
SUM(CASE WHEN status = 'Success' then 1 else 0 end)*100.0/count(*) as succ_rate
from cleaned_transactions