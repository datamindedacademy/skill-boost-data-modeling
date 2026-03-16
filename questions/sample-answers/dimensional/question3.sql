-- Question 3: Shipping Performance (Dimensional Model)
-- Percentage of late shipments by ship mode (late = ship_date > commit_date)
-- Note: commit_date was not included in the fact table design, so we join to the raw lineitem table

SELECT
    f.ship_mode,
    COUNT(*) as total_shipments,
    SUM(CASE WHEN f.ship_date_id > li.l_commitdate THEN 1 ELSE 0 END) as late_shipments,
    ROUND(100.0 * SUM(CASE WHEN f.ship_date_id > li.l_commitdate THEN 1 ELSE 0 END) / COUNT(*), 2) as late_pct
FROM fact_line_item f
JOIN lineitem li ON f.order_key = li.l_orderkey AND f.line_number = li.l_linenumber
GROUP BY f.ship_mode
ORDER BY late_pct DESC;

-- Observations:
-- - commit_date was not included in the dimensional model's fact table
-- - Must fall back to the raw lineitem table to get commit_date
-- - This reveals a design gap: shipping performance analysis wasn't anticipated
-- - A better design would include commit_date as a degenerate dimension or additional date key
