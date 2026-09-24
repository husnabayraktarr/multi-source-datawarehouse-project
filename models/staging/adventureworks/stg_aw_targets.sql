with source as (

    select * from {{ source('raw_adventureworks', 'raw_aw_targets') }}

),

cleaned as (

    select
        "EmployeeID"::varchar as employee_id,
        replace(replace("Target", '$', ''), ',', '')::number(18,2) as target_amount,
        try_to_date("TargetMonth", 'DY, MON DD, YYYY') as target_month
    from source

)

select * from cleaned
