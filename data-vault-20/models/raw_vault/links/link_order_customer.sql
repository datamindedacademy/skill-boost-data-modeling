-- Link: Order to Customer relationship
with source as (
    select
        o_orderkey as order_key,
        o_custkey as customer_key,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'orders') }}
)

select
    md5(concat(
        md5(cast(order_key as varchar)),
        md5(cast(customer_key as varchar))
    )) as order_customer_hashkey,
    md5(cast(order_key as varchar)) as order_hashkey,
    md5(cast(customer_key as varchar)) as customer_hashkey,
    load_date,
    record_source
from source
