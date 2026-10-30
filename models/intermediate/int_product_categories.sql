with recursive category_tree as (
    select
        category_id,
        parent_category_id,
        category_name,
        category_name::text as root_category_name,
        category_name::text as category_path,
        1 as category_level
    from {{ ref('stg_shop__product_categories') }} where parent_category_id is null

    union all

    select
        c.category_id,
        c.parent_category_id,
        c.category_name,
        t.root_category_name,
        t.category_path || ' > ' || c.category_name,
        t.category_level + 1
    from {{ ref('stg_shop__product_categories') }} as c join category_tree as t on c.parent_category_id = t.category_id
)

select
    t.category_id,
    t.category_name,
    t.parent_category_id,
    p.category_name as parent_category_name,
    t.root_category_name,
    t.category_path,
    t.category_level
from category_tree as t left join {{ ref('stg_shop__product_categories') }} as p on p.category_id = t.parent_category_id