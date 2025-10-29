-- One Big Table: All order and line item data fully denormalized
-- Every row represents a line item with all related dimensional attributes pre-joined
select
    -- Line Item Identifiers
    li.l_orderkey as order_key,
    li.l_linenumber as line_number,

    -- Order Attributes
    o.o_orderdate as order_date,
    o.o_orderstatus as order_status,
    o.o_orderpriority as order_priority,
    o.o_clerk as order_clerk,
    o.o_shippriority as order_ship_priority,
    o.o_totalprice as order_total_price,
    extract(year from o.o_orderdate) as order_year,
    extract(quarter from o.o_orderdate) as order_quarter,
    extract(month from o.o_orderdate) as order_month,
    extract(day from o.o_orderdate) as order_day,
    extract(dayofweek from o.o_orderdate) as order_day_of_week,

    -- Customer Attributes
    c.c_custkey as customer_key,
    c.c_name as customer_name,
    c.c_address as customer_address,
    c.c_phone as customer_phone,
    c.c_acctbal as customer_account_balance,
    c.c_mktsegment as customer_market_segment,

    -- Customer Geography
    cn.n_name as customer_nation,
    cr.r_name as customer_region,

    -- Part/Product Attributes
    p.p_partkey as part_key,
    p.p_name as part_name,
    p.p_mfgr as part_manufacturer,
    p.p_brand as part_brand,
    p.p_type as part_type,
    p.p_size as part_size,
    p.p_container as part_container,
    p.p_retailprice as part_retail_price,

    -- Supplier Attributes
    s.s_suppkey as supplier_key,
    s.s_name as supplier_name,
    s.s_address as supplier_address,
    s.s_phone as supplier_phone,
    s.s_acctbal as supplier_account_balance,

    -- Supplier Geography
    sn.n_name as supplier_nation,
    sr.r_name as supplier_region,

    -- Line Item Attributes
    li.l_quantity as quantity,
    li.l_extendedprice as extended_price,
    li.l_discount as discount,
    li.l_tax as tax,
    li.l_returnflag as return_flag,
    li.l_linestatus as line_status,
    li.l_shipdate as ship_date,
    li.l_commitdate as commit_date,
    li.l_receiptdate as receipt_date,
    li.l_shipinstruct as ship_instructions,
    li.l_shipmode as ship_mode,

    -- Calculated Measures
    li.l_extendedprice * (1 - li.l_discount) as discounted_price,
    li.l_extendedprice * (1 - li.l_discount) * (1 + li.l_tax) as total_price,
    li.l_extendedprice * li.l_discount as discount_amount,
    li.l_extendedprice * (1 - li.l_discount) * li.l_tax as tax_amount,

    -- Shipping Time Metrics
    datediff('day', li.l_shipdate, li.l_receiptdate) as days_to_receipt,
    datediff('day', li.l_commitdate, li.l_shipdate) as days_early_late,
    case
        when li.l_shipdate > li.l_commitdate then 'Late'
        when li.l_shipdate = li.l_commitdate then 'On Time'
        else 'Early'
    end as delivery_status

from {{ source('tpch', 'lineitem') }} li
inner join {{ source('tpch', 'orders') }} o on li.l_orderkey = o.o_orderkey
inner join {{ source('tpch', 'customer') }} c on o.o_custkey = c.c_custkey
inner join {{ source('tpch', 'nation') }} cn on c.c_nationkey = cn.n_nationkey
inner join {{ source('tpch', 'region') }} cr on cn.n_regionkey = cr.r_regionkey
inner join {{ source('tpch', 'part') }} p on li.l_partkey = p.p_partkey
inner join {{ source('tpch', 'supplier') }} s on li.l_suppkey = s.s_suppkey
inner join {{ source('tpch', 'nation') }} sn on s.s_nationkey = sn.n_nationkey
inner join {{ source('tpch', 'region') }} sr on sn.n_regionkey = sr.r_regionkey
