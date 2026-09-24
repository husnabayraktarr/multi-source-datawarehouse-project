with source as (

    select * from {{ source('raw_adventureworks', 'raw_aw_sales') }}

),

cleaned as (

    select
        "SalesOrderNumber"::varchar as sales_order_number,
        try_to_date("OrderDate", 'DY, MON DD, YYYY') as order_date,
        "ProductKey"::number as product_key,
        "ResellerKey"::number as reseller_key,
        "EmployeeKey"::number as employee_key,
        "SalesTerritoryKey"::number as sales_territory_key,
        "Quantity"::number as quantity,
        replace(replace("Unit Price", '$', ''), ',', '')::number(18,2) as unit_price,
        replace(replace("Sales", '$', ''), ',', '')::number(18,2) as sales_amount,
        replace(replace("Cost", '$', ''), ',', '')::number(18,2) as cost_amount
    from source

)

select * from cleaned
