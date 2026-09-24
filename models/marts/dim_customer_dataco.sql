with orders as (

    select * from {{ ref('stg_dataco_orders') }}

)

select distinct
    customer_id as customer_key,
    customer_city,
    customer_country,
    customer_state,
    customer_segment
from orders
