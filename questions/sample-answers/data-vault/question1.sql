-- Question 1: Revenue by Region (Data Vault Model)
-- Using the business vault view (simplified)

SELECT
    customer_nation,  -- Could aggregate further to region if needed
    SUM(line_total) as total_revenue,
    COUNT(DISTINCT order_key) as order_count,
    COUNT(*) as line_item_count
FROM bv_order_details
GROUP BY customer_nation
ORDER BY total_revenue DESC;

-- Alternative: Querying raw vault directly (more complex)
/*
SELECT
    -- Would need to join through multiple satellites and hubs
    -- This demonstrates why business vault views are important
    sr.region_name,
    SUM(sl.extended_price * (1 - sl.discount) * (1 + sl.tax)) as total_revenue,
    COUNT(DISTINCT ho.order_key) as order_count
FROM link_lineitem ll
JOIN hub_order ho ON ll.order_hashkey = ho.order_hashkey
JOIN sat_lineitem sl ON ll.lineitem_hashkey = sl.lineitem_hashkey
JOIN link_order_customer loc ON ho.order_hashkey = loc.order_hashkey
JOIN hub_customer hc ON loc.customer_hashkey = hc.customer_hashkey
JOIN sat_customer sc ON hc.customer_hashkey = sc.customer_hashkey
-- ... more joins for nation and region
GROUP BY sr.region_name;
*/

-- Observations:
-- - Business vault makes this manageable
-- - Raw vault query would require many more joins
-- - Need to understand hub-link-satellite structure
