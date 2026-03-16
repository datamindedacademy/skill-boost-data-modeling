-- Question 3: Shipping Performance (One Big Table)
-- Percentage of late shipments by ship mode (late = ship_date > commit_date)

SELECT
    ship_mode,
    COUNT(*) as total_shipments,
    SUM(CASE WHEN ship_date > commit_date THEN 1 ELSE 0 END) as late_shipments,
    ROUND(100.0 * SUM(CASE WHEN ship_date > commit_date THEN 1 ELSE 0 END) / COUNT(*), 2) as late_pct
FROM obt_orders
GROUP BY ship_mode
ORDER BY late_pct DESC;

-- Observations:
-- - No joins needed
-- - All date columns are pre-joined in the OBT
-- - Delivery analysis is trivial with the denormalized structure
