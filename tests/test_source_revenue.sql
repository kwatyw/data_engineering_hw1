with paid_orders as (
    select order_id from {{ source('shop', 'payments') }}
    where payment_status = 'success' and amount > 0 group by order_id
),

source_sum as (
    select sum(o.total_amount) as amount from {{ source('shop', 'orders') }} as o join paid_orders as p on p.order_id = o.order_id
    where o.status = 'paid'
),

mart_sum as (
    select sum(order_amount) as amount from {{ ref('fct_orders') }} where is_confirmed
)

select s.amount as source_amount, m.amount as mart_amount from source_sum as s join mart_sum as m on s.amount <> m.amount