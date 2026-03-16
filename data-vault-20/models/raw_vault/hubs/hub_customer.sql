-- Hub: Customer business key
-- Integrates customer keys from both TPC-H and CRM sources
with tpch_source as (
    select distinct
        c_custkey as customer_key,
        current_timestamp as load_date,
        'TPCH' as record_source
    from {{ source('tpch', 'customer') }}
),

crm_source as (
    select distinct
        customer_key,
        current_timestamp as load_date,
        'CRM' as record_source
    from {{ ref('crm_customers') }}
),

all_customers as (
    select * from tpch_source
    union all
    select * from crm_source
),

-- Keep earliest load per business key (first source wins)
deduplicated as (
    select
        customer_key,
        load_date,
        record_source,
        row_number() over (partition by customer_key order by record_source) as rn
    from all_customers
)

select
    hex(sha256(cast(customer_key as varchar))) as customer_hashkey,
    customer_key,
    load_date,
    record_source
from deduplicated
where rn = 1
