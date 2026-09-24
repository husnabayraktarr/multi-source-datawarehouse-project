with source as (

    select * from {{ source('raw_olist', 'raw_olist_category_translation') }}

),

cleaned as (

    select
        "product_category_name"::varchar as product_category_name,
        "product_category_name_english"::varchar as product_category_name_english
    from source

)

select * from cleaned
