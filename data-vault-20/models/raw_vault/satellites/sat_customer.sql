-- Satellite: Customer descriptive attributes
with source as (
    select
        c_custkey as customer_key,
        c_name as customer_name,
        c_address as address,
        c_nationkey as nation_key,
        c_phone as phone,
        c_acctbal as account_balance,
        c_mktsegment as market_segment,
        c_comment as comment,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'customer') }}
)

select
    md5(cast(customer_key as varchar)) as customer_hashkey,
    load_date,
    customer_name,
    address,
    nation_key,
    phone,
    account_balance,
    market_segment,
    comment,
    record_source,
    md5(concat(
        coalesce(customer_name, ''),
        coalesce(address, ''),
        coalesce(cast(nation_key as varchar), ''),
        coalesce(phone, ''),
        coalesce(cast(account_balance as varchar), ''),
        coalesce(market_segment, ''),
        coalesce(comment, '')
    )) as hashdiff
from source
