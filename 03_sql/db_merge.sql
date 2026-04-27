USE product_analytics_db;

SELECT *
from cleaned_users;

SELECT *
from cleaned_transactions;

SELECT *
from cleaned_events;

SELECT *
from cleaned_products;

CREATE TABLE merged_saas AS
SELECT
    u.user_id,
    u.name,
    u.email,
    u.signup_date,
    u.country,
    u.device,

    t.transaction_id,
    t.amount,
    t.payment_method,
    t.status AS payment_status,
    t.event_time AS transaction_time,

    e.event_id,
    e.event_type,
    e.event_time,

    p.product_id,
    p.product_name,
    p.category,
    p.price

FROM cleaned_users u
LEFT JOIN cleaned_transactions t ON u.user_id = t.user_id
LEFT JOIN cleaned_events e ON u.user_id = e.user_id
LEFT JOIN cleaned_products p ON e.product_id = p.product_id;

select *
from merged_saas;