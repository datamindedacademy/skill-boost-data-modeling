-- Question 2: Multi-Dimensional Slice (Dimensional Model)
-- Revenue by customer market segment, product brand, and order quarter for 1995
-- Include order count and average discount rate

SELECT
    dc.market_segment,
    dp.brand,
    dd.quarter_name as order_quarter,
    SUM(f.total_price) as total_revenue,
    COUNT(DISTINCT f.order_key) as order_count,
    AVG(f.discount) as avg_discount
FROM fact_line_item f
JOIN dim_customer dc ON f.customer_id = dc.customer_id AND dc.is_current = true
JOIN dim_part dp ON f.part_id = dp.part_id
JOIN dim_date dd ON f.order_date_id = dd.date_day
WHERE dd.year = 1995
GROUP BY dc.market_segment, dp.brand, dd.quarter_name
ORDER BY dc.market_segment, dp.brand, dd.quarter_name;

-- Observations:
-- - 3 dimension joins required for the multi-dimensional slice
-- - SCD2 filter on dim_customer is essential
-- - Star schema handles multi-dimensional analysis naturally
