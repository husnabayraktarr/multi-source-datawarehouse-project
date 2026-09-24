with source as (

    select * from {{ source('raw_adventureworks', 'raw_aw_product') }}

),

cleaned as (

    select
        "ProductKey"::number as product_key,
        "Product"::varchar as product_name,
        replace(replace("Standard Cost", '$', ''), ',', '')::number(18,2) as standard_cost,
        "Color"::varchar as color,
        "Subcategory"::varchar as subcategory,
        "Category"::varchar as category,
        "Background Color Format"::varchar as background_color_format,
        "Font Color Format"::varchar as font_color_format
    from source

)

select * from cleaned
