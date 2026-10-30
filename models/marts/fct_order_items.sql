{{ config(materialized='incremental', unique_key='order_item_id', distributed_by='order_id', orientation='column') }}

with items as (
    select * from {{ ref('stg_shop__order_items') }}
),

orders as (
    select * from {{ ref('int_orders_with_payments') }}
    where not is_test_order
)

select
    i.order_item_id,
    i.order_id,
    i.product_id,
    o.customer_id,
    o.order_date,
    o.ordered_at,
    o.order_status,
    i.quantity,
    i.unit_price,
    i.discount_amount,
    i.gross_amount,
    i.line_amount,
    o.is_confirmed
from items as i join orders as o on o.order_id = i.order_id


{% if is_incremental() %}
where o.ordered_at > (select max(ordered_at) from {{ this }})
{% endif %}