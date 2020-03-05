CREATE OR REPLACE VIEW EDITH_TRANSPLANT_VW AS
select 
'CR-T'||ORA_HASH(CONCAT(tx.txp_regn,23098),999999) AS tx_id
,extract(year from tx.txp_date)||'-1-1' as tx_date
--,tx.txp_regn, tx.txp_recip, tx.txp_donor
, (select case when count(m.txp_regn) > 0 then 'Y' else 'N' END from ods_et.ods_enis_transplant m where tx.txp_recip = m.txp_recip and tx.txp_donor = m.txp_donor and m.txp_organ_detail_code not in ('LKi','RKi'))   as tx_multi_organ
, 'at0018' as tx_centertype
, 'CR-CTR'||ORA_HASH(CONCAT(tx.txp_center,23098),999999) as tx_center_id
--, tx.txp_center
, 'Edith' tx_center_id_issuer
, 'Edith' tx_center_id_assigner
, 'Local id' tx_center_id_type
, tx.txp_organ_detail_code as tx_graft
, tx.txp_organ_detail_code as tx_graft_val
, 'CR-D'||ORA_HASH(CONCAT(tx.txp_donor,23098),999999) tx_donor_id
, 'Edith' as tx_donor_id_issuer
, 'Edith' as tx_donor_id_assigner
, 'Local id' as tx_donor_id_type
, CASE WHEN fup.cold_ischaemic_period_hrs is null THEN null ELSE 'PT'||fup.cold_ischaemic_period_hrs||'H' END as tx_cold_ischemia_time 
, decode(fup.pre_transplant_dialysis,'Y','at0004','N','at0005') as tx_pre_emptive_transplant --"at0004::Yes"|"at0005::No"
, (select count(DISTINCT n.txp_donor) from ods_et.ods_enis_transplant n where tx.txp_recip = n.txp_recip and tx.txp_donor <> n.txp_donor and n.txp_organ_detail_code in ('LKi','RKi') and n.txp_date < tx.txp_date) as tx_number_previous_kidney
FROM                ods_et.ods_enis_transplant tx
LEFT OUTER JOIN     ods_et.ods_reg_kidney_vw fup
ON tx.txp_regn = fup.transplant_number and fup.occurrence = 'I' and fup.deleted = 'false'
WHERE  
tx.txp_fup_center_code like 'C%'
and tx.txp_date >= to_date ('01.01.2015', 'dd.mm.yyyy')
and tx.txp_date < to_date ('01.01.2020', 'dd.mm.yyyy')
and tx.txp_organ_detail_code in ('LKi','RKi')
--and rownum < 3
ORDER BY tx_id asc
;