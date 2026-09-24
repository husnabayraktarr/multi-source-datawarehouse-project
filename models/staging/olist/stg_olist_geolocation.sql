with source as (

    select * from {{ source('raw_olist', 'raw_olist_geolocation') }}

),

cleaned as (

    select
        "geolocation_zip_code_prefix"::varchar as geolocation_zip_code_prefix,
        "geolocation_lat"::float as geolocation_lat,
        "geolocation_lng"::float as geolocation_lng,
        initcap("geolocation_city") as geolocation_city,
        "geolocation_state"::varchar as geolocation_state
    from source

)

select * from cleaned
