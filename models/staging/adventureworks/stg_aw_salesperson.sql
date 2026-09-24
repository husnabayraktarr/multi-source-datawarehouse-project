with source as (

    select * from {{ source('raw_adventureworks', 'raw_aw_salesperson') }}

),

cleaned as (

    select
        "EmployeeKey"::number as employee_key,
        "EmployeeID"::varchar as employee_id,
        "Salesperson"::varchar as salesperson_name,
        "Title"::varchar as title,
        "UPN"::varchar as email
    from source

)

select * from cleaned
