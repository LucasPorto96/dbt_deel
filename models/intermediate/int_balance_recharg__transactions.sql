{{
    config(
        materialized="incremental",
        incremental_strategy="append",
        indexes=[{"columns": ["external_ref"], "unique": True, "type": "btree"}],
    )
}}
select
    acceptance.external_ref,
    acceptance.status,
    acceptance.ref,
    acceptance.date_time,
    acceptance.state,
    acceptance.cvv_provided,
    acceptance.amount,
    acceptance.country,
    acceptance.currency,
    acceptance.amount_in_dollars,
    chargeback.chargeback
from
    {{ ref("stg_globepay__acceptance") }} acceptance,
    {{ ref("stg_globepay__chargeback") }} chargeback

where
    acceptance.external_ref = chargeback.external_ref
    {% if is_incremental() %}
        and date_time > (select max(date_time) from {{ this }})
    {% endif %}
