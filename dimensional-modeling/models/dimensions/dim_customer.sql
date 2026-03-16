-- Customer dimension (SCD Type 2)
-- Integrates TPC-H customer data with CRM loyalty data
-- Customers with CRM records have one row per validity period (loyalty tier changes)
-- Customers without CRM records have a single row with NULL CRM fields
with customer_enriched as (
    select
        c.customer_key,
        c.customer_name,
        c.address,
        c.phone,
        c.account_balance,
        c.market_segment,
        c.comment,
        n.nation_name,
        r.region_name
    from {{ ref('stg_customer') }} c
    left join {{ ref('stg_nation') }} n on c.nation_key = n.nation_key
    left join {{ ref('stg_region') }} r on n.region_key = r.region_key
),

crm as (
    select * from {{ ref('crm_customers') }}
),

-- Customers with CRM data: one row per validity period
customers_with_crm as (
    select
        ce.customer_key,
        ce.customer_name,
        ce.address,
        ce.phone,
        ce.account_balance,
        ce.market_segment,
        ce.nation_name,
        ce.region_name,
        ce.comment,
        crm.loyalty_tier,
        crm.signup_date,
        crm.last_contact_date,
        crm.preferred_channel,
        cast(crm.valid_from as date) as valid_from,
        cast(crm.valid_to as date) as valid_to
    from customer_enriched ce
    inner join crm on ce.customer_key = crm.customer_key
),

-- Customers without CRM data: single row
customers_without_crm as (
    select
        ce.customer_key,
        ce.customer_name,
        ce.address,
        ce.phone,
        ce.account_balance,
        ce.market_segment,
        ce.nation_name,
        ce.region_name,
        ce.comment,
        null as loyalty_tier,
        null as signup_date,
        null as last_contact_date,
        null as preferred_channel,
        cast('1900-01-01' as date) as valid_from,
        cast('9999-12-31' as date) as valid_to
    from customer_enriched ce
    where ce.customer_key not in (select distinct customer_key from crm)
),

combined as (
    select * from customers_with_crm
    union all
    select * from customers_without_crm
)

select
    row_number() over (order by customer_key, valid_from) as customer_surrogate_key,
    customer_key as customer_id,
    customer_name,
    address,
    phone,
    account_balance,
    market_segment,
    nation_name,
    region_name,
    loyalty_tier,
    signup_date,
    last_contact_date,
    preferred_channel,
    valid_from,
    valid_to,
    valid_to = cast('9999-12-31' as date) as is_current,
    comment
from combined
