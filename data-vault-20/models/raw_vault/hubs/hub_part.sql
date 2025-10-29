-- Hub: Part business key
with source as (
    select distinct
        p_partkey as part_key,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'part') }}
)

select
    md5(cast(part_key as varchar)) as part_hashkey,
    part_key,
    load_date,
    record_source
from source
