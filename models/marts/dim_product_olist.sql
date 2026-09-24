with products as (

    select * from {{ ref('stg_olist_products') }}

),

translations as (

    select * from {{ ref('stg_olist_category_translation') }}

)

select
    products.product_id as product_key,
    products.product_category_name,
    translations.product_category_name_english,
    products.product_weight_g,
    products.product_length_cm,
    products.product_height_cm,
    products.product_width_cm
from products
left join translations
    on products.product_category_name = translations.product_category_name
