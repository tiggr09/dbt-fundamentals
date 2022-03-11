with payments as (
    select * from {{ ref('stg_payments')}}
),
orders as (
    select * from {{ ref('stg_orders')}}
),
cust_payments as (
    select 
        order_id,
        sum(case when status = 'success' then amount end) as amount 
    from payments
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(cust_payments.amount, 0) as amount

    from orders

    left join cust_payments using (order_id)

)

select * from final