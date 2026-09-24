with source as (

    select * from {{ source('raw_adventureworks', 'raw_aw_reseller') }}

),

cleaned as (

    select
        "ResellerKey"::number as reseller_key,
        "Business Type"::varchar as business_type,
        "Reseller"::varchar as reseller_name,
        "City"::varchar as city,
        "State-Province"::varchar as state_province,
        "Country-Region"::varchar as country_region
    from source

)

select * from cleaned
