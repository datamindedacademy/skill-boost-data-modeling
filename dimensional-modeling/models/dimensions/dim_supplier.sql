-- Supplier dimension with geographic hierarchy
with supplier_enriched as (
    select
        s.supplier_key,
        s.supplier_name,
        s.address,
        s.phone,
        s.account_balance,
        s.comment,
        n.nation_name,
        r.region_name
    from {{ ref('stg_supplier') }} s
    left join {{ ref('stg_nation') }} n on s.nation_key = n.nation_key
    left join {{ ref('stg_region') }} r on n.region_key = r.region_key
)

select
    supplier_key as supplier_id,
    supplier_name,
    address,
    phone,
    account_balance,
    nation_name,
    region_name,
    comment
from supplier_enriched
