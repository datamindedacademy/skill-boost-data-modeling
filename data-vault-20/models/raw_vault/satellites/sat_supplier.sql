-- Satellite: Supplier descriptive attributes
with source as (
    select
        s_suppkey as supplier_key,
        s_name as supplier_name,
        s_address as address,
        s_nationkey as nation_key,
        s_phone as phone,
        s_acctbal as account_balance,
        s_comment as comment,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'supplier') }}
)

select
    hex(sha256(cast(supplier_key as varchar))) as supplier_hashkey,
    load_date,
    supplier_name,
    address,
    nation_key,
    phone,
    account_balance,
    comment,
    record_source,
    hex(sha256(concat(
        coalesce(supplier_name, ''),
        coalesce(address, ''),
        coalesce(cast(nation_key as varchar), ''),
        coalesce(phone, ''),
        coalesce(cast(account_balance as varchar), ''),
        coalesce(comment, '')
    ))) as hashdiff
from source
