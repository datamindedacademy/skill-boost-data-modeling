-- Link: Line item relationships (order-part-supplier)
with source as (
    select
        l_orderkey as order_key,
        l_partkey as part_key,
        l_suppkey as supplier_key,
        l_linenumber as line_number,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'lineitem') }}
)

select
    hex(sha256(concat(
        hex(sha256(cast(order_key as varchar))),
        hex(sha256(cast(part_key as varchar))),
        hex(sha256(cast(supplier_key as varchar))),
        cast(line_number as varchar)
    ))) as lineitem_hashkey,
    hex(sha256(cast(order_key as varchar))) as order_hashkey,
    hex(sha256(cast(part_key as varchar))) as part_hashkey,
    hex(sha256(cast(supplier_key as varchar))) as supplier_hashkey,
    line_number,
    load_date,
    record_source
from source
