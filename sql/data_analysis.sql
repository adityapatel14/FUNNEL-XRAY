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
FROM cleaned_users;

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
