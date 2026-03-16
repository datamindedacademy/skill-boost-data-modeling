-- Question 5: Revenue by loyalty tier (Multi-Source Integration)
-- Uses current loyalty tier from the SCD2 dimension
select
    dc.loyalty_tier,
    count(distinct f.order_key) as order_count,
    sum(f.total_price) as total_revenue
from fact_line_item f
inner join dim_customer dc
    on f.customer_id = dc.customer_id
    and dc.is_current = true
where dc.loyalty_tier is not null
group by dc.loyalty_tier
order by total_revenue desc;
