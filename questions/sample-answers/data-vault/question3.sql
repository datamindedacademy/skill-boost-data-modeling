-- Question 3: Shipping Performance (Data Vault - Raw Vault)
-- Percentage of late shipments by ship mode (late = ship_date > commit_date)

SELECT
    sl.ship_mode,
    COUNT(*) as total_shipments,
    SUM(CASE WHEN sl.ship_date > sl.commit_date THEN 1 ELSE 0 END) as late_shipments,
    ROUND(100.0 * SUM(CASE WHEN sl.ship_date > sl.commit_date THEN 1 ELSE 0 END) / COUNT(*), 2) as late_pct
FROM sat_lineitem sl
GROUP BY sl.ship_mode
ORDER BY late_pct DESC;

-- Observations:
-- - All shipping data lives in a single satellite (sat_lineitem)
-- - No joins needed since ship_date, commit_date, and ship_mode are all in the same satellite
-- - Raw vault preserves all source attributes, making this analysis straightforward
