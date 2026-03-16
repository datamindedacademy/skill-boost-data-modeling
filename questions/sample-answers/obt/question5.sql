-- Question 5: Revenue by loyalty tier (Multi-Source Integration)
-- Uses the current loyalty tier (latest CRM record)
select
    customer_current_loyalty_tier as loyalty_tier,
    count(distinct order_key) as order_count,
    sum(total_price) as total_revenue
from obt_orders
where customer_current_loyalty_tier is not null
group by customer_current_loyalty_tier
order by total_revenue desc;
