with source as (

    select * from {{ source('raw_dataco', 'raw_supplychain_dataco') }}

),

cleaned as (

    select
        "TYPE"::varchar as payment_type,
        "DAYS_FOR_SHIPPING"::number as days_for_shipping,
        "DAYS_FOR_SHIPMENT"::number as days_for_shipment,
        "BENEFIT_PER_ORDER"::number(18,2) as benefit_per_order,
        "SALES_PER_CUSTOMER"::number(18,2) as sales_per_customer,
        "DELIVERY_STATUS"::varchar as delivery_status,
        "LATE_DELIVERY_RISK"::number as late_delivery_risk,
        "CATEGORY_ID"::number as category_id,
        "CATEGORY_NAME"::varchar as category_name,
        "CUSTOMER_ID"::number as customer_id,
        "CUSTOMER_CITY"::varchar as customer_city,
        "CUSTOMER_COUNTRY"::varchar as customer_country,
        "CUSTOMER_STATE"::varchar as customer_state,
        "CUSTOMER_SEGMENT"::varchar as customer_segment,
        "MARKET"::varchar as market,
        "ORDER_CITY"::varchar as order_city,
        "ORDER_COUNTRY"::varchar as order_country,
        "ORDER_CUSTOMER_ID"::number as order_customer_id,
        dateadd(year, 2000, "ORDER_DATE") as order_date,
        "ORDER_ID"::number as order_id,
        "ORDER_ITEM_CARDPROD_ID"::number as product_id,
        "ORDER_ITEM_DISCOUNT"::number(18,2) as order_item_discount,
        "ORDER_ITEM_DISCOUNT_RATE"::number(10,4) as order_item_discount_rate,
        "ORDER_ITEM_ID"::number as order_item_id,
        "ORDER_ITEM_PRODUCT_PRICE"::number(18,2) as order_item_product_price,
        "ORDER_ITEM_QUANTITY"::number as order_item_quantity,
        "SALES"::number(18,2) as sales_amount,
        "ORDER_ITEM_TOTAL"::number(18,2) as order_item_total,
        "ORDER_PROFIT_PER_ORDER"::number(18,2) as order_profit_per_order,
        "ORDER_REGION"::varchar as order_region,
        "ORDER_STATE"::varchar as order_state,
        "ORDER_STATUS"::varchar as order_status,
        "PRODUCT_CARD_ID"::number as product_card_id,
        "PRODUCT_NAME"::varchar as product_name,
        "PRODUCT_PRICE"::number(18,2) as product_price,
        dateadd(year, 2000, "SHIPPING_DATE") as shipping_date,
        "SHIPPING_MODE"::varchar as shipping_mode
    from source

)

select * from cleaned
