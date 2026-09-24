with product as (

    select * from {{ ref('stg_aw_product') }}

)

select
    product_key,
    product_name,
    standard_cost,
    color,
    subcategory,
    category
from product
