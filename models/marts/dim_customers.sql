{{ config(distributed_replicated=true) }}

with customers as (
    select * from {{ ref('stg_shop__customers') }}
),

purchases as (
    select * from {{ ref('int_customer_purchases') }}
)

select
    c.customer_id,
    c.registered_at,
    c.registration_date,
    c.city,
    c.acquisition_channel,
    p.first_confirmed_order_id,
    p.first_confirmed_at,
    coalesce(p.confirmed_orders_count, 0) as confirmed_orders_count,
    coalesce(p.confirmed_revenue, 0) as confirmed_revenue,
    p.customer_id is not null as is_buyer
from customers as c left join purchases as p on p.customer_id = c.customer_id