-- Business Vault: Denormalized view for order analysis
-- Joins hubs, links, and satellites from both TPC-H and CRM sources
-- Includes geographic hierarchy for customer and supplier
select
    -- Order attributes
    ho.order_key,
    so.order_status,
    so.order_date,
    so.order_priority,
    so.total_price as order_total,

    -- Customer attributes (from TPC-H satellite)
    hc.customer_key,
    sc.customer_name,
    sc.market_segment,
    cn.n_name as customer_nation,
    cr.r_name as customer_region,

    -- Customer CRM attributes (current loyalty tier)
    scc.loyalty_tier as current_loyalty_tier,
    scc.preferred_channel,
    scc.signup_date as crm_signup_date,

    -- Line item attributes
    ll.line_number,
    sl.quantity,
    sl.extended_price,
    sl.discount,
    sl.tax,
    sl.extended_price * (1 - sl.discount) * (1 + sl.tax) as line_total,

    -- Part attributes
    hp.part_key,
    sp.part_name,
    sp.brand,
    sp.part_type,

    -- Supplier attributes
    hs.supplier_key,
    ss.supplier_name,
    sn.n_name as supplier_nation,
    sr.r_name as supplier_region,

    -- Metadata
    ll.load_date as lineitem_load_date

from {{ ref('link_lineitem') }} ll
inner join {{ ref('hub_order') }} ho on ll.order_hashkey = ho.order_hashkey
inner join {{ ref('sat_order') }} so on ho.order_hashkey = so.order_hashkey
inner join {{ ref('sat_lineitem') }} sl on ll.lineitem_hashkey = sl.lineitem_hashkey
inner join {{ ref('link_order_customer') }} loc on ho.order_hashkey = loc.order_hashkey
inner join {{ ref('hub_customer') }} hc on loc.customer_hashkey = hc.customer_hashkey
inner join {{ ref('sat_customer') }} sc on hc.customer_hashkey = sc.customer_hashkey
-- Customer geography
inner join {{ source('tpch', 'nation') }} cn on sc.nation_key = cn.n_nationkey
inner join {{ source('tpch', 'region') }} cr on cn.n_regionkey = cr.r_regionkey
inner join {{ ref('hub_part') }} hp on ll.part_hashkey = hp.part_hashkey
inner join {{ ref('sat_part') }} sp on hp.part_hashkey = sp.part_hashkey
inner join {{ ref('hub_supplier') }} hs on ll.supplier_hashkey = hs.supplier_hashkey
inner join {{ ref('sat_supplier') }} ss on hs.supplier_hashkey = ss.supplier_hashkey
-- Supplier geography
inner join {{ source('tpch', 'nation') }} sn on ss.nation_key = sn.n_nationkey
inner join {{ source('tpch', 'region') }} sr on sn.n_regionkey = sr.r_regionkey
-- CRM satellite: get the current loyalty tier (latest record)
left join (
    select
        customer_hashkey,
        loyalty_tier,
        preferred_channel,
        signup_date,
        load_date,
        row_number() over (partition by customer_hashkey order by load_date desc) as rn
    from {{ ref('sat_customer_crm') }}
) scc on hc.customer_hashkey = scc.customer_hashkey and scc.rn = 1
