-- Customer dimension with geographic hierarchy
with customer_enriched as (
    select
        c.customer_key,
        c.customer_name,
        c.address,
        c.phone,
        c.account_balance,
        c.market_segment,
        c.comment,
        n.nation_name,
        r.region_name
    from {{ ref('stg_customer') }} c
    left join {{ ref('stg_nation') }} n on c.nation_key = n.nation_key
    left join {{ ref('stg_region') }} r on n.region_key = r.region_key
)

select
    customer_key as customer_id,
    customer_name,
    address,
    phone,
    account_balance,
    market_segment,
    nation_name,
    region_name,
    comment
from customer_enriched
