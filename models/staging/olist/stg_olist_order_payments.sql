with source as (

    select * from {{ source('raw_olist', 'raw_olist_order_payments') }}

),

cleaned as (

    select
        "order_id"::varchar as order_id,
        "payment_sequential"::number as payment_sequential,
        "payment_type"::varchar as payment_type,
        "payment_installments"::number as payment_installments,
        "payment_value"::number(18,2) as payment_value
    from source

)

select * from cleaned
