-- Satellite: Line item descriptive attributes and measures
with source as (
    select
        l_orderkey as order_key,
        l_partkey as part_key,
        l_suppkey as supplier_key,
        l_linenumber as line_number,
        l_quantity as quantity,
        l_extendedprice as extended_price,
        l_discount as discount,
        l_tax as tax,
        l_returnflag as return_flag,
        l_linestatus as line_status,
        l_shipdate as ship_date,
        l_commitdate as commit_date,
        l_receiptdate as receipt_date,
        l_shipinstruct as ship_instruct,
        l_shipmode as ship_mode,
        l_comment as 'comment',
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'lineitem') }}
)

select
    -- Simple column references first
    load_date,
    quantity,
    extended_price,
    discount,
    tax,
    return_flag,
    line_status,
    ship_date,
    commit_date,
    receipt_date,
    ship_instruct,
    ship_mode,
    comment,
    record_source,
    -- Calculations and aggregates last
    md5(concat(
        md5(cast(order_key as varchar)),
        md5(cast(part_key as varchar)),
        md5(cast(supplier_key as varchar)),
        cast(line_number as varchar)
    )) as lineitem_hashkey,
    md5(concat(
        coalesce(cast(quantity as varchar), ''),
        coalesce(cast(extended_price as varchar), ''),
        coalesce(cast(discount as varchar), ''),
        coalesce(cast(tax as varchar), ''),
        coalesce(return_flag, ''),
        coalesce(line_status, ''),
        coalesce(cast(ship_date as varchar), ''),
        coalesce(cast(commit_date as varchar), ''),
        coalesce(cast(receipt_date as varchar), ''),
        coalesce(ship_instruct, ''),
        coalesce(ship_mode, ''),
        coalesce(comment, '')
    )) as hashdiff
from source
