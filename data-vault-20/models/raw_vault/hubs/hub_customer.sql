-- Hub: Customer business key
with source as (
    select distinct
        c_custkey as customer_key,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'customer') }}
)

select
    md5(cast(customer_key as varchar)) as customer_hashkey,
    customer_key,
    load_date,
    record_source
from source
