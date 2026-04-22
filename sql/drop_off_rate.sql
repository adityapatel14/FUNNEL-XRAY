USE product_analytics_db;

with login as (
  select distinct user_id
  from cleaned_events
  where event_type = 'login'
),

viewer as (
  select distinct e.user_id
  from login l
  join cleaned_events e on e.user_id = l.user_id
  where e.event_type = 'view'
),

click as (
  select distinct e.user_id
  from viewer v
  join cleaned_events e on e.user_id = v.user_id
  where e.event_type = 'click'
),

add_to_cart as (
  select distinct e.user_id
  from click c
  join cleaned_events e on e.user_id = c.user_id
  where e.event_type = 'add_to_cart'
),

purchase as (
  select distinct e.user_id
  from add_to_cart a
  join cleaned_events e on e.user_id = a.user_id
  where e.event_type = 'purchase'
),

counts as (
  select 'login' as step, count(*) as users from login
  union all
  select 'view', count(*) from viewer
  union all
  select 'click', count(*) from click
  union all
  select 'add_to_cart', count(*) from add_to_cart
  union all
  select 'purchase', count(*) from purchase
)

select 
  step,
  users,
  lag(users) over(order by 
    case step
      when 'login' then 1
      when 'view' then 2
      when 'click' then 3
      when 'add_to_cart' then 4
      when 'purchase' then 5
    end
  ) as prev_users,

  -- drop off
  lag(users) over(order by 
    case step
      when 'login' then 1
      when 'view' then 2
      when 'click' then 3
      when 'add_to_cart' then 4
      when 'purchase' then 5
    end
  ) - users as drop_off,

  -- drop off rate
  round(
    (lag(users) over(order by 
      case step
        when 'login' then 1
        when 'view' then 2
        when 'click' then 3
        when 'add_to_cart' then 4
        when 'purchase' then 5
      end
    ) - users) * 1.0
    /
    lag(users) over(order by 
      case step
        when 'login' then 1
        when 'view' then 2
        when 'click' then 3
        when 'add_to_cart' then 4
        when 'purchase' then 5
      end
    )*100, 2
  ) as drop_off_rate

from counts;