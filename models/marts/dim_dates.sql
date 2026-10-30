{{ config(distributed_replicated=true) }}

with bounds as (
    select
        min(order_date) as start_date,
        max(order_date) as end_date
    from {{ ref('stg_shop__orders') }} where not is_test_order
),

days as (
    select generate_series(start_date, end_date, interval '1 day')::date as date_day from bounds
)

select
    date_day,
    extract(year from date_day)::int as year_number,
    extract(quarter from date_day)::int as quarter_number,
    extract(month from date_day)::int as month_number,
    extract(isodow from date_day)::int as day_of_week,
    extract(isodow from date_day) in (6, 7) as is_weekend
from days