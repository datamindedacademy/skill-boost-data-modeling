-- Date dimension - generated from order dates in TPC-H data
with date_spine as (
    select distinct order_date as date_day
    from {{ ref('stg_orders') }}

    union

    select distinct ship_date as date_day
    from {{ ref('stg_lineitem') }}
)

select
    date_day,
    extract(year from date_day) as year,
    extract(quarter from date_day) as quarter,
    extract(month from date_day) as month,
    extract(day from date_day) as day,
    extract(dayofweek from date_day) as day_of_week,
    extract(dayofyear from date_day) as day_of_year,
    extract(week from date_day) as week_of_year,
    case
        when extract(month from date_day) in (1,2,3) then 'Q1'
        when extract(month from date_day) in (4,5,6) then 'Q2'
        when extract(month from date_day) in (7,8,9) then 'Q3'
        else 'Q4'
    end as quarter_name,
    strftime(date_day, '%B') as month_name,
    strftime(date_day, '%A') as day_name
from date_spine
