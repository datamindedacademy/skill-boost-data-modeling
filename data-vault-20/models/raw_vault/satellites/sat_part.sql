-- Satellite: Part descriptive attributes
with source as (
    select
        p_partkey as part_key,
        p_name as part_name,
        p_mfgr as manufacturer,
        p_brand as brand,
        p_type as part_type,
        p_size as size,
        p_container as container,
        p_retailprice as retail_price,
        p_comment as comment,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'part') }}
)

select
    md5(cast(part_key as varchar)) as part_hashkey,
    load_date,
    part_name,
    manufacturer,
    brand,
    part_type,
    size,
    container,
    retail_price,
    comment,
    record_source,
    md5(concat(
        coalesce(part_name, ''),
        coalesce(manufacturer, ''),
        coalesce(brand, ''),
        coalesce(part_type, ''),
        coalesce(cast(size as varchar), ''),
        coalesce(container, ''),
        coalesce(cast(retail_price as varchar), ''),
        coalesce(comment, '')
    )) as hashdiff
from source
