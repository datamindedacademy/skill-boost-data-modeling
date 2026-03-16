-- Question 2: Multi-Dimensional Slice (Data Vault - Raw Vault)
-- Revenue by customer market segment, product brand, and order quarter for 1995
-- Include order count and average discount rate

SELECT
    sc.market_segment,
    sp.brand,
    'Q' || EXTRACT(QUARTER FROM so.order_date) as order_quarter,
    SUM(sl.extended_price * (1 - sl.discount) * (1 + sl.tax)) as total_revenue,
    COUNT(DISTINCT ho.order_key) as order_count,
    AVG(sl.discount) as avg_discount
FROM link_lineitem ll
INNER JOIN sat_lineitem sl ON ll.lineitem_hashkey = sl.lineitem_hashkey
INNER JOIN hub_order ho ON ll.order_hashkey = ho.order_hashkey
INNER JOIN sat_order so ON ho.order_hashkey = so.order_hashkey
INNER JOIN link_order_customer loc ON ho.order_hashkey = loc.order_hashkey
INNER JOIN hub_customer hc ON loc.customer_hashkey = hc.customer_hashkey
INNER JOIN sat_customer sc ON hc.customer_hashkey = sc.customer_hashkey
INNER JOIN hub_part hp ON ll.part_hashkey = hp.part_hashkey
INNER JOIN sat_part sp ON hp.part_hashkey = sp.part_hashkey
WHERE EXTRACT(YEAR FROM so.order_date) = 1995
GROUP BY sc.market_segment, sp.brand, 'Q' || EXTRACT(QUARTER FROM so.order_date)
ORDER BY sc.market_segment, sp.brand, order_quarter;

-- Observations:
-- - 8 joins needed to bring together customer, part, and order dimensions
-- - The most complex query so far, illustrating Data Vault verbosity
-- - A business vault or information mart would greatly simplify this
