with source as (

    select * from {{ source('raw_adventureworks', 'raw_aw_region') }}

),

cleaned as (

    select
        "SalesTerritoryKey"::number as sales_territory_key,
        "Region"::varchar as region,
        "Country"::varchar as country,
        "Group"::varchar as region_group
    from source

)

select * from cleaned
