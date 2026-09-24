with raw_counts as (

    select 'adventureworks' as source_system, count(*) as raw_row_count
    from {{ source('raw_adventureworks', 'raw_aw_sales') }}

    union all

    select 'olist' as source_system, count(*) as raw_row_count
    from {{ source('raw_olist', 'raw_olist_order_items') }}

    union all

    select 'dataco' as source_system, count(*) as raw_row_count
    from {{ source('raw_dataco', 'raw_supplychain_dataco') }}

),

fact_counts as (

    select 'adventureworks' as source_system, count(*) as fact_row_count
    from {{ ref('fact_orders_aw') }}

    union all

    select 'olist' as source_system, count(*) as fact_row_count
    from {{ ref('fact_orders_olist') }}

    union all

    select 'dataco' as source_system, count(*) as fact_row_count
    from {{ ref('fact_orders_dataco') }}

)

select
    raw_counts.source_system,
    raw_counts.raw_row_count,
    fact_counts.fact_row_count,
    (raw_counts.raw_row_count - fact_counts.fact_row_count) as row_difference,
    case
        when raw_counts.raw_row_count = fact_counts.fact_row_count then 'MATCH'
        else 'MISMATCH - investigate'
    end as reconciliation_status
from raw_counts
join fact_counts
    on raw_counts.source_system = fact_counts.source_system
