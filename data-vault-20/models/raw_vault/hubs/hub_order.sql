-- Hub: Order business key
with source as (
    select distinct
        o_orderkey as order_key,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'orders') }}
)

select
    md5(cast(order_key as varchar)) as order_hashkey,
    order_key,
    load_date,
    record_source
from source
