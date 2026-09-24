with date_spine as (

    select
        dateadd(day, seq4(), '2015-01-01'::date) as date_day
    from table(generator(rowcount => 2200))

),

enriched as (

    select
        date_day,
        year(date_day) as year,
        month(date_day) as month,
        monthname(date_day) as month_name,
        day(date_day) as day_of_month,
        dayofweek(date_day) as day_of_week,
        dayname(date_day) as day_name,
        quarter(date_day) as quarter,
        weekofyear(date_day) as week_of_year
    from date_spine

)

select * from enriched
where date_day <= '2020-05-31'
