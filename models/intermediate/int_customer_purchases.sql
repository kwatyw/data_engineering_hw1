with confirmed_orders as (
    select
        customer_id,
        order_id,
        order_amount,
        first_paid_at,
        row_number() over (partition by customer_id order by first_paid_at, order_id) as purchase_number
    from {{ ref('int_orders_with_payments') }} where is_confirmed and not is_test_order
),

totals as (
    select customer_id, count(*) as confirmed_orders_count, sum(order_amount) as confirmed_revenue
    from confirmed_orders group by customer_id
)

select
    t.customer_id,
    c.order_id as first_confirmed_order_id,
    c.first_paid_at as first_confirmed_at,
    t.confirmed_orders_count,
    t.confirmed_revenue
from totals as t join confirmed_orders as c on c.customer_id = t.customer_id and c.purchase_number = 1