with source as (

    select * from {{ source('raw_olist', 'raw_olist_sellers') }}

),

cleaned as (

    select
        "seller_id"::varchar as seller_id,
        "seller_zip_code_prefix"::varchar as seller_zip_code_prefix,
        initcap("seller_city") as seller_city,
        "seller_state"::varchar as seller_state
    from source

)

select * from cleaned
