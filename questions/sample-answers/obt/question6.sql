-- Question 6: Revenue by loyalty tier at time of order (SCD Type 2)
-- The OBT already resolved the correct tier at order time during ETL
-- Uses customer_loyalty_tier (historical) not customer_current_loyalty_tier
select
    customer_loyalty_tier as loyalty_tier,
    count(distinct order_key) as order_count,
    sum(total_price) as total_revenue
from obt_orders
where customer_loyalty_tier is not null
group by customer_loyalty_tier
order by total_revenue desc;
