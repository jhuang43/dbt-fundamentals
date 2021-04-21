{%- set payment_methods = ['bank_transfer', 'credit_card', 'gift_card', 'coupon'] -%}

with payments as (
    select * from {{ ref ('stg_payments')}}
),

pivoted as (
    select
        order_id,
        {% for payment_method in payment_methods -%}
        sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) AS {{ payment_method }}_amt
        {%- if not loop.last -%}
            ,
        {% endif -%}
        {%- endfor %}
    from payments
    where status = 'success'
    group by 1
)

select * from pivoted