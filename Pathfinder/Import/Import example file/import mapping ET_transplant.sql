select 
tx.txp_regn as tx_id
,extract(year from tx.txp_date)||'-0-0' as tx_date
,tx.txp_regn, tx.txp_recip, tx.txp_donor
, (select case when count(m.txp_regn) > 0 then 'Y' else 'N' END from ods_et.ods_enis_transplant m where tx.txp_recip = m.txp_recip and tx.txp_donor = m.txp_donor and m.txp_organ_detail_code not in ('LKi','RKi'))   as tx_multi_organ
, 'at0018' as tx_centertype
--, ORA_HASH(CONCAT(tx.txp_center,23098),100000) as tx_center_id
, tx.txp_center
, 'Eurotransplant' tx_center_id_issuer
, 'Eurotransplant' tx_center_id_assigner
, 'annonymous tx_center' tx_center_id_type
, tx.txp_organ_detail_code as tx_graft
, tx.txp_donor as tx_donor_id
, 'Eurotransplant' as tx_donor_id_issuer
, 'Eurotransplant' as tx_donor_id_assigner
, 'Txp Donor ID' as tx_donor_id_type
, (select count(DISTINCT n.txp_donor) from ods_et.ods_enis_transplant n where tx.txp_recip = n.txp_recip and tx.txp_donor <> n.txp_donor and n.txp_organ_detail_code in ('LKi','RKi') and n.txp_date < tx.txp_date) as tx_number_previous_kidney
, fup.graft_specification
, fup.occurrence
, fup.deleted
FROM                ods_et.ods_enis_transplant tx   
LEFT OUTER JOIN     ods_et.ods_reg_kidney_vw fup
ON tx.txp_regn = fup.transplant_number and fup.occurrence = 'I' and fup.deleted = 'false'
WHERE  
tx.txp_fup_center_code like 'C%'
ORDER BY txp_recip asc
;