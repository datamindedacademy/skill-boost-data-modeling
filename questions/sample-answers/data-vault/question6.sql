-- Question 6: Revenue by loyalty tier at time of order (Data Vault - Raw Vault)
-- Point-in-time join: match each order to the CRM satellite record valid at order time

SELECT
    scc.loyalty_tier,
    COUNT(DISTINCT ho.order_key) as order_count,
    SUM(sl.extended_price * (1 - sl.discount) * (1 + sl.tax)) as total_revenue
FROM link_lineitem ll
INNER JOIN hub_order ho ON ll.order_hashkey = ho.order_hashkey
INNER JOIN sat_order so ON ho.order_hashkey = so.order_hashkey
INNER JOIN sat_lineitem sl ON ll.lineitem_hashkey = sl.lineitem_hashkey
INNER JOIN link_order_customer loc ON ho.order_hashkey = loc.order_hashkey
INNER JOIN hub_customer hc ON loc.customer_hashkey = hc.customer_hashkey
INNER JOIN sat_customer_crm scc
    ON hc.customer_hashkey = scc.customer_hashkey
    AND so.order_date >= scc.load_date
    AND so.order_date < scc.valid_to
GROUP BY scc.loyalty_tier
ORDER BY total_revenue DESC;

-- Observations:
-- - Point-in-time join uses load_date/valid_to from the satellite
-- - Data Vault naturally preserves history in satellites, making this query possible
-- - Compare: sat_order needed just for order_date, adding another join
-- - This is where Data Vault's historical tracking pays off
