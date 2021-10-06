{% set payment_methods = ['credit_card','coupon','bank_transfer','gift_card']%}

with payment as (
    select * from {{ ref ('stg_payments')}}
),

pivoted_payment as (

    select order_id,
    {% for payment_method in payment_methods %}  
    sum(case when payment_method = {{'payment_method'}} then amount else 0 end) as {{'payment_method'}}_method
    {%- if not loop.last -%}
    ,
    {% endif %}
    {%- endfor %}

    from payment
    group by 1
)

select * from pivoted_payment

