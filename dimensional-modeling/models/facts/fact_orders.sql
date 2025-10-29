-- Fact table for orders (grain: one row per order)
-- This is an aggregated fact table useful for order-level analysis
select
    -- Foreign keys to dimensions
    o.order_key,
    o.customer_key as customer_id,
    o.order_date as order_date_id,

    -- Degenerate dimensions
    o.order_status,
    o.order_priority,
    o.clerk,

    -- Measures (facts)
    o.total_price as order_total,
    count(li.line_number) as line_item_count,
    sum(li.quantity) as total_quantity,
    sum(li.extended_price * (1 - li.discount) * (1 + li.tax)) as calculated_total

from {{ ref('stg_orders') }} o
left join {{ ref('stg_lineitem') }} li on o.order_key = li.order_key
group by
    o.order_key,
    o.customer_key,
    o.order_date,
    o.order_status,
    o.order_priority,
    o.clerk,
    o.total_price
