with orders as (

    select * from {{ ref('stg_dataco_orders') }}

),

dates as (

    select * from {{ ref('dim_date') }}

)

select
    orders.order_id,
    orders.order_item_id,
    orders.customer_id as customer_key,
    orders.product_id as product_key,
    orders.order_date,
    dates.date_day as date_key,
    orders.order_status,
    orders.delivery_status,
    orders.late_delivery_risk,
    orders.order_item_quantity as quantity,
    orders.sales_amount,
    orders.order_profit_per_order as profit_amount,
    orders.shipping_mode,
    orders.market,
    orders.order_region
from orders
left join dates
    on orders.order_date = dates.date_day
