-- Question 4: Trade Flows (Ad-Hoc) - Data Vault - Raw Vault
-- Revenue by customer region and supplier region

SELECT
    cr.r_name as customer_region,
    sr.r_name as supplier_region,
    SUM(sl.extended_price * (1 - sl.discount) * (1 + sl.tax)) as total_revenue,
    COUNT(DISTINCT ho.order_key) as order_count,
    SUM(sl.quantity) as total_quantity
FROM link_lineitem ll
INNER JOIN hub_order ho ON ll.order_hashkey = ho.order_hashkey
INNER JOIN sat_lineitem sl ON ll.lineitem_hashkey = sl.lineitem_hashkey
INNER JOIN link_order_customer loc ON ho.order_hashkey = loc.order_hashkey
INNER JOIN hub_customer hc ON loc.customer_hashkey = hc.customer_hashkey
INNER JOIN sat_customer sc ON hc.customer_hashkey = sc.customer_hashkey
INNER JOIN nation cn ON sc.nation_key = cn.n_nationkey
INNER JOIN region cr ON cn.n_regionkey = cr.r_regionkey
INNER JOIN hub_supplier hs ON ll.supplier_hashkey = hs.supplier_hashkey
INNER JOIN sat_supplier ss ON hs.supplier_hashkey = ss.supplier_hashkey
INNER JOIN nation sn ON ss.nation_key = sn.n_nationkey
INNER JOIN region sr ON sn.n_regionkey = sr.r_regionkey
GROUP BY cr.r_name, sr.r_name
ORDER BY total_revenue DESC;

-- Observations:
-- - 11 joins needed! Adding supplier geography adds 4 more joins
-- - This really motivates the need for a business vault layer
-- - The query is correct but hard to maintain
