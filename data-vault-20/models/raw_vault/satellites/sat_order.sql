-- Satellite: Order descriptive attributes
with source as (
    select
        o_orderkey as order_key,
        o_orderstatus as order_status,
        o_totalprice as total_price,
        o_orderdate as order_date,
        o_orderpriority as order_priority,
        o_clerk as clerk,
        o_shippriority as ship_priority,
        o_comment as comment,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'orders') }}
)

select
    md5(cast(order_key as varchar)) as order_hashkey,
    load_date,
    order_status,
    total_price,
    order_date,
    order_priority,
    clerk,
    ship_priority,
    comment,
    record_source,
    md5(concat(
        coalesce(order_status, ''),
        coalesce(cast(total_price as varchar), ''),
        coalesce(cast(order_date as varchar), ''),
        coalesce(order_priority, ''),
        coalesce(clerk, ''),
        coalesce(cast(ship_priority as varchar), ''),
        coalesce(comment, '')
    )) as hashdiff
from source
