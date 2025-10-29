-- Hub: Supplier business key
with source as (
    select distinct
        s_suppkey as supplier_key,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'supplier') }}
)

select
    md5(cast(supplier_key as varchar)) as supplier_hashkey,
    supplier_key,
    load_date,
    record_source
from source
