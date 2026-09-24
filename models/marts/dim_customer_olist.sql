with customers as (

    select * from {{ ref('stg_olist_customers') }}

)

select
    customer_id as customer_key,
    customer_unique_id,
    customer_city,
    customer_state,
    customer_zip_code_prefix
from customers
