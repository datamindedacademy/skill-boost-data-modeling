-- Business Vault: Denormalized view for order analysis
-- This joins hubs, links, and satellites for easier querying
select
    -- Order attributes
    ho.order_key,
    so.order_status,
    so.order_date,
    so.order_priority,
    so.total_price as order_total,

    -- Customer attributes
    hc.customer_key,
    sc.customer_name,
    sc.market_segment,

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
    -- Note: we would add supplier satellite here if needed

    -- Metadata
    ll.load_date as lineitem_load_date

from {{ ref('link_lineitem') }} ll
inner join {{ ref('hub_order') }} ho on ll.order_hashkey = ho.order_hashkey
inner join {{ ref('sat_order') }} so on ho.order_hashkey = so.order_hashkey
inner join {{ ref('sat_lineitem') }} sl on ll.lineitem_hashkey = sl.lineitem_hashkey
inner join {{ ref('link_order_customer') }} loc on ho.order_hashkey = loc.order_hashkey
inner join {{ ref('hub_customer') }} hc on loc.customer_hashkey = hc.customer_hashkey
inner join {{ ref('sat_customer') }} sc on hc.customer_hashkey = sc.customer_hashkey
inner join {{ ref('hub_part') }} hp on ll.part_hashkey = hp.part_hashkey
inner join {{ ref('sat_part') }} sp on hp.part_hashkey = sp.part_hashkey
inner join {{ ref('hub_supplier') }} hs on ll.supplier_hashkey = hs.supplier_hashkey
