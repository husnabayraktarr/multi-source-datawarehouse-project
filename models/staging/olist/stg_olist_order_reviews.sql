with source as (

    select * from {{ source('raw_olist', 'raw_olist_order_reviews') }}

),

cleaned as (

    select
        "review_id"::varchar as review_id,
        "order_id"::varchar as order_id,
        "review_score"::number as review_score,
        "review_comment_title"::varchar as review_comment_title,
        "review_comment_message"::varchar as review_comment_message,
        "review_creation_date"::timestamp as review_creation_date,
        "review_answer_timestamp"::timestamp as review_answer_timestamp
    from source

)

select * from cleaned
