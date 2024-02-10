 {{
    config(
        materialized="incremental",
        incremental_strategy="merge",
        unique_key="primary_key",
        indexes=[{"columns": ["day"], "unique": False, "type": "btree"}],
        merge_update_columns = ["amount", "amount_in_dollars", "quantity_of_transactions"]
    )
}}

with
    base as (
        select
            date_time::date as day,
            state,
            cvv_provided,
            country,
            currency,
            chargeback,
            sum(amount) as amount,
            sum(amount_in_dollars) as amount_in_dollars,
            count(*) as quantity_of_transactions
        from {{ ref("int_balance_recharg__transactions") }}
        {% if is_incremental() %}
            where date_time::date >= (select max(day) from {{ this }})
        {% endif %}
        group by day, state, cvv_provided, country, currency, chargeback
    )

select
    md5(
        cast(day as varchar)
        || state
        || cast(cvv_provided as varchar)
        || country
        || currency
        || cast(chargeback as varchar)
    ) as primary_key,
    *
from base
