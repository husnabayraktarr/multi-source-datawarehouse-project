with orders as (

    select * from {{ ref('stg_olist_orders') }}

),

order_items as (

    select * from {{ ref('stg_olist_order_items') }}

),

dates as (

    select * from {{ ref('dim_date') }}

)

select
    orders.order_id,
    orders.customer_id as customer_key,
    order_items.product_id as product_key,
    orders.order_purchase_timestamp::date as order_date,
    dates.date_day as date_key,
    orders.order_status,
    order_items.order_item_id,
    1 as quantity,
    order_items.price as sales_amount,
    order_items.freight_value
from orders
inner join order_items
    on orders.order_id = order_items.order_id
left join dates
    on orders.order_purchase_timestamp::date = dates.date_day
