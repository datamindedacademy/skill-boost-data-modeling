-- Part/Product dimension
select
    part_key as part_id,
    part_name,
    manufacturer,
    brand,
    part_type,
    size,
    container,
    retail_price,
    comment
from {{ ref('stg_part') }}
