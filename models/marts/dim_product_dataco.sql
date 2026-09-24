with orders as (

    select * from {{ ref('stg_dataco_orders') }}

)

select distinct
    product_id as product_key,
    product_name,
    product_price,
    category_name
from orders
