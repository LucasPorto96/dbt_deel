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
from {{ ref("stg_globepay__acceptance") }} acceptance

left join {{ ref("stg_globepay__chargeback") }} chargeback using (external_ref)

{% if is_incremental() %}
    where date_time > (select max(date_time) from {{ this }})
{% endif %}
