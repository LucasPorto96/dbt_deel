{{ config(materialized="view") }}
select
    external_ref,
    status = 'TRUE' as status,
    ref,
    to_timestamp(date_time, 'YYYY-MM-DD"T"HH24:MI:SS.USZ')::timestamp as date_time,
    state,
    cvv_provided,
    amount,
    country,
    currency,
    rates,
    amount * cast(rates::json ->> currency as numeric) as amount_in_dollars
from acceptance
where source = 'GLOBALPAY'
