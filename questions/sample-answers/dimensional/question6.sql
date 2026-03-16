-- Question 6: Revenue by loyalty tier at time of order (SCD Type 2)
-- Joins fact to dimension using date range to get the correct historical tier
select
    dc.loyalty_tier,
    count(distinct f.order_key) as order_count,
    sum(f.total_price) as total_revenue,
    avg(f.total_price) as avg_line_total
from fact_line_item f
inner join dim_customer dc
    on f.customer_id = dc.customer_id
    and f.order_date_id >= dc.valid_from
    and f.order_date_id < dc.valid_to
where dc.loyalty_tier is not null
group by dc.loyalty_tier
order by total_revenue desc;
