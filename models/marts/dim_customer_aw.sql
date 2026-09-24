with reseller as (

    select * from {{ ref('stg_aw_reseller') }}

)

select
    reseller_key as customer_key,
    reseller_name as customer_name,
    business_type,
    city,
    state_province,
    country_region
from reseller
