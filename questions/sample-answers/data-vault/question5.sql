-- Question 5: Revenue by loyalty tier (Data Vault - Raw Vault)
-- Joins through hub_customer to sat_customer_crm, taking the latest record

SELECT
    scc.loyalty_tier,
    COUNT(DISTINCT ho.order_key) as order_count,
    SUM(sl.extended_price * (1 - sl.discount) * (1 + sl.tax)) as total_revenue
FROM link_lineitem ll
INNER JOIN hub_order ho ON ll.order_hashkey = ho.order_hashkey
INNER JOIN sat_lineitem sl ON ll.lineitem_hashkey = sl.lineitem_hashkey
INNER JOIN link_order_customer loc ON ho.order_hashkey = loc.order_hashkey
INNER JOIN hub_customer hc ON loc.customer_hashkey = hc.customer_hashkey
INNER JOIN (
    SELECT
        customer_hashkey,
        loyalty_tier,
        ROW_NUMBER() OVER (PARTITION BY customer_hashkey ORDER BY load_date DESC) as rn
    FROM sat_customer_crm
) scc ON hc.customer_hashkey = scc.customer_hashkey AND scc.rn = 1
WHERE scc.loyalty_tier IS NOT NULL
GROUP BY scc.loyalty_tier
ORDER BY total_revenue DESC;

-- Observations:
-- - Notice how hub_customer integrates keys from both TPC-H and CRM sources
-- - Each source has its own satellite (sat_customer for TPC-H, sat_customer_crm for CRM)
-- - ROW_NUMBER window function needed to get the latest CRM record per customer
