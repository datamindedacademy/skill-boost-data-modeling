-- Question 8: Trade Flows (Ad-Hoc) - One Big Table
-- NEW requirement: Revenue by customer region and supplier region

SELECT
    customer_region,
    supplier_region,
    SUM(total_price) as total_revenue,
    COUNT(DISTINCT order_key) as order_count,
    SUM(quantity) as total_quantity
FROM obt_orders
GROUP BY customer_region, supplier_region
ORDER BY total_revenue DESC;

-- Observations:
-- - Trivially easy! No changes needed
-- - All attributes already present
-- - This is where OBT shines - any attribute combination works
-- - BUT... what if OBT didn't include supplier_region?
--   Then you'd need to rebuild the entire table!
