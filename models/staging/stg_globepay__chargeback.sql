{{ config(materialized="view") }}
select external_ref, status = 'TRUE' as status, chargeback = 'TRUE' as chargeback
from chargeback
where source = 'GLOBALPAY'
