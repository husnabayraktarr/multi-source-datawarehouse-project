{{
    config(
        materialized='incremental',
        unique_key='sales_order_number'
    )
}}

with sales as (

    select * from {{ ref('stg_aw_sales') }}

),

dates as (

    select * from {{ ref('dim_date') }}

)

select
    sales.sales_order_number,
    sales.order_date,
    dates.date_day as date_key,
    sales.product_key,
    sales.reseller_key as customer_key,
    sales.employee_key,
    sales.sales_territory_key,
    sales.quantity,
    sales.unit_price,
    sales.sales_amount,
    sales.cost_amount,
    (sales.sales_amount - sales.cost_amount) as profit_amount
from sales
left join dates
    on sales.order_date = dates.date_day

{% if is_incremental() %}
where sales.order_date > (select max(order_date) from {{ this }})
{% endif %}
