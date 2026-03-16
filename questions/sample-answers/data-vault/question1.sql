-- Question 1: Revenue by Region (Data Vault - Raw Vault)
-- Joins through hubs, links, and satellites to customer geography

SELECT
    cr.r_name as customer_region,
    SUM(sl.extended_price * (1 - sl.discount) * (1 + sl.tax)) as total_revenue,
    COUNT(DISTINCT ho.order_key) as order_count,
    COUNT(*) as line_item_count
FROM link_lineitem ll
INNER JOIN hub_order ho ON ll.order_hashkey = ho.order_hashkey
INNER JOIN sat_lineitem sl ON ll.lineitem_hashkey = sl.lineitem_hashkey
INNER JOIN link_order_customer loc ON ho.order_hashkey = loc.order_hashkey
INNER JOIN hub_customer hc ON loc.customer_hashkey = hc.customer_hashkey
INNER JOIN sat_customer sc ON hc.customer_hashkey = sc.customer_hashkey
INNER JOIN nation cn ON sc.nation_key = cn.n_nationkey
INNER JOIN region cr ON cn.n_regionkey = cr.r_regionkey
GROUP BY cr.r_name
ORDER BY total_revenue DESC;

-- Observations:
-- - 7 joins required to reach customer region from line items
-- - Navigating hub-link-satellite structure is verbose
-- - A business vault view would simplify this significantly
