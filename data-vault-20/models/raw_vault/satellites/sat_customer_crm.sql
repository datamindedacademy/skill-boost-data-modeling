-- Satellite: Customer CRM attributes (from CRM source system)
-- Multiple rows per customer track loyalty tier changes over time
with source as (
    select
        customer_key,
        loyalty_tier,
        signup_date,
        last_contact_date,
        preferred_channel,
        cast(valid_from as date) as load_date,
        cast(valid_to as date) as valid_to,
        'CRM' as record_source
    from {{ ref('crm_customers') }}
)

select
    hex(sha256(cast(customer_key as varchar))) as customer_hashkey,
    load_date,
    valid_to,
    loyalty_tier,
    signup_date,
    last_contact_date,
    preferred_channel,
    record_source,
    hex(sha256(concat(
        coalesce(loyalty_tier, ''),
        coalesce(cast(signup_date as varchar), ''),
        coalesce(cast(last_contact_date as varchar), ''),
        coalesce(preferred_channel, '')
    ))) as hashdiff
from source
