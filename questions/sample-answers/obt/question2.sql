-- Question 2: Multi-Dimensional Slice (One Big Table)
-- Revenue by customer market segment, product brand, and order quarter for 1995
-- Include order count and average discount rate

SELECT
    customer_market_segment as market_segment,
    part_brand as brand,
    'Q' || order_quarter as order_quarter,
    SUM(total_price) as total_revenue,
    COUNT(DISTINCT order_key) as order_count,
    AVG(discount) as avg_discount
FROM obt_orders
WHERE order_year = 1995
GROUP BY customer_market_segment, part_brand, order_quarter
ORDER BY customer_market_segment, part_brand, order_quarter;

-- Observations:
-- - No joins needed even for multi-dimensional analysis
-- - Pre-computed quarter column simplifies grouping
-- - OBT shines for ad-hoc slicing and dicing
