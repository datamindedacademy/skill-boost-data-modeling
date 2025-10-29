-- Question 1: Revenue by Region (One Big Table)
-- Total revenue for each customer region with order count

SELECT
    customer_region,
    SUM(total_price) as total_revenue,
    COUNT(DISTINCT order_key) as order_count,
    COUNT(*) as line_item_count
FROM obt_orders
GROUP BY customer_region
ORDER BY total_revenue DESC;

-- Observations:
-- - No joins required!
-- - Extremely simple and readable
-- - Perfect for self-service analytics
-- - Anyone can write this query
