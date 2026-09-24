with source as (

    select * from {{ source('raw_adventureworks', 'raw_aw_salespersonregion') }}

),

cleaned as (

    select
        "EmployeeKey"::number as employee_key,
        "SalesTerritoryKey"::number as sales_territory_key
    from source

)

select * from cleaned
