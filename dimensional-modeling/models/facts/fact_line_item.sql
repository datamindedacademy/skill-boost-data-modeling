-- Fact table for line items (grain: one row per line item)
select
    -- Foreign keys to dimensions
    li.order_key,
    li.part_key as part_id,
    li.supplier_key as supplier_id,
    o.customer_key as customer_id,
    o.order_date as order_date_id,
    li.ship_date as ship_date_id,

    -- Degenerate dimensions (attributes that don't warrant their own dimension)
    li.line_number,
    o.order_status,
    o.order_priority,
    li.line_status,
    li.return_flag,
    li.ship_mode,

    -- Measures (facts)
    li.quantity,
    li.extended_price,
    li.discount,
    li.tax,
    li.extended_price * (1 - li.discount) as discounted_price,
    li.extended_price * (1 - li.discount) * (1 + li.tax) as total_price

from {{ ref('stg_lineitem') }} li
inner join {{ ref('stg_orders') }} o on li.order_key = o.order_key
