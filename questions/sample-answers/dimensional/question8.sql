-- Question 8: Trade Flows (Ad-Hoc) - Dimensional Model
-- NEW requirement: Revenue by customer region and supplier region

SELECT
    dc.region_name as customer_region,
    ds.region_name as supplier_region,
    SUM(f.total_price) as total_revenue,
    COUNT(DISTINCT f.order_key) as order_count,
    SUM(f.quantity) as total_quantity
FROM fact_line_item f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
JOIN dim_supplier ds ON f.supplier_id = ds.supplier_id
GROUP BY dc.region_name, ds.region_name
ORDER BY total_revenue DESC;

-- Observations:
-- - Easy to add! Just add another join
-- - Dimensional model is flexible for this type of analysis
-- - All dimensions readily available
-- - Clear what each join contributes
