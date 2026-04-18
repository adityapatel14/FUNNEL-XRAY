USE product_analytics_db;

SELECT user_id,name,count(*) as count
FROM messy_users
GROUP BY user_id,name
HAVING count>1;

SELECT transaction_id , count(*) as count
FROM messy_transactions
group by transaction_id
having count > 1;

SELECT *
FROM messy_transactions;

SELECT *
FROM messy_products;

SELECT *
FROM messy_events;

SELECT *
FROM messy_users
WHERE user_id = 'U999';

SELECT DISTINCT *
FROM messy_users
WHERE device = '';

SELECT DISTINCT *
FROM messy_users
WHERE country = '' or device = '';

SELECT DISTINCT *
FROM messy_users
ORDER BY user_id desc;

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN device IS NULL OR device = '' THEN 1 ELSE 0 END) AS missing_device
FROM messy_users;

CREATE TABLE cleaned_users AS
SELECT 
    user_id,
    name,
    email,
    signup_date,
    CASE 
        WHEN country IS NULL OR TRIM(country) = '' THEN 'unknown'
        ELSE LOWER(TRIM(country))
    END AS country,
    CASE 
      WHEN device IS NULL OR TRIM(device) = '' THEN 'unknown'
      ELSE LOWER(TRIM(device))
END AS device,
CAST(SUBSTRING(user_id, 2) AS UNSIGNED) AS user_id_num
FROM messy_users;

SELECT * 
FROM cleaned_users
ORDER BY user_id_num DESC;

SELECT product_id , count(*) as count
FROM messy_transactions
WHERE product_id IS NULL OR TRIM(product_id) = '' or product_id = 'P999'
GROUP BY product_id;

CREATE TABLE cleaned_transactions AS
SELECT 
    transaction_id,
    CAST(SUBSTRING(transaction_id, 2) AS UNSIGNED) AS transaction_id_num,
    user_id,
    CAST(SUBSTRING(user_id, 2) AS UNSIGNED) AS user_id_num,
    product_id,
    COALESCE(amount, 0) AS amount,
    CASE 
        WHEN payment_method IS NULL OR TRIM(payment_method) = '' THEN 'unknown'
        ELSE LOWER(TRIM(payment_method))
    END AS payment_method,
    -- clean status
    CASE 
        WHEN status IS NULL OR TRIM(status) = '' THEN 'unknown'
        ELSE LOWER(TRIM(status))
    END AS status,
    event_time
FROM messy_transactions
WHERE 
    product_id IS NOT NULL AND TRIM(product_id) <> ''
    AND user_id IS NOT NULL AND TRIM(user_id) <> '';
    
SELECT *
FROM cleaned_transactions
where trim(amount) = '' or amount is null;

SELECT t.product_id,count(*) as count
FROM messy_transactions t
LEFT JOIN messy_products p 
ON t.product_id = p.product_id
WHERE p.product_id IS NULL
group by t.product_id;

SELECT *
FROM messy_products
WHERE product_id = 'P9';

SELECT 
    product_id,
    AVG(amount),
    COUNT(*)
FROM messy_transactions
WHERE product_id IN ('P9','P999')
GROUP BY product_id;

UPDATE cleaned_transactions t
LEFT JOIN messy_products p
ON t.product_id = p.product_id
SET t.product_id = 'unknown'
WHERE p.product_id IS NULL;

select event_id,count(*)
from messy_events
group by event_id,user_id,event_type
having count(*)>1;

select *
from messy_events;

CREATE TABLE cleaned_events AS
SELECT DISTINCT *
FROM messy_events;

UPDATE cleaned_events e
LEFT JOIN messy_products p
  ON e.product_id = p.product_id
SET e.product_id = 'unknown'
WHERE 
  e.product_id IS NULL
  OR TRIM(e.product_id) = ''
  OR p.product_id IS NULL;

select *
from messy_products;

CREATE TABLE cleaned_products as 
SELECT product_id,product_name,lower(trim(category)) as category,price
from messy_products;

select * from cleaned_users;
