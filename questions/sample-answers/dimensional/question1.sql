-- Question 1: Revenue by Region (Dimensional Model)
-- Total revenue for each customer region with order count

SELECT
    dc.region_name,
    SUM(f.total_price) as total_revenue,
    COUNT(DISTINCT f.order_key) as order_count,
    COUNT(*) as line_item_count
FROM fact_line_item f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
GROUP BY dc.region_name
ORDER BY total_revenue DESC;

-- Observations:
-- - Requires 1 join (fact to dimension)
-- - Clear and intuitive
-- - Business logic is obvious
