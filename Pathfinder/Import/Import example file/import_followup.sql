CREATE OR REPLACE VIEW DM.EDITH_FOLLOWUP_VW AS
select 
'CR-R'||tx.txp_recip as SubjectId,
'en' as language,
'HR' as teritory,
'Wouter Zanen' as composer,
'EUROTRANSPLANT' as id_namespace,
'NCA CROATIA' as id_scheme,
--fup.followup_center,
'CR-T'||ORA_HASH(CONCAT(tx.txp_regn,23098),999999) AS tx_id
-- fup_status (creating entries of follow-up event for combined status): "at0012::Patient Deceased"|"at0013::In Follow-up|"at0014::Lost to Follow-up"|"at0015::Graft Failed"
,case when fup.needs_followup_reason = 'Deceased' then 'at0012' END as fup_status_deceased --at0012::Patient Deceased 
,fup.death_date as fup_d_days_since_tx
,fup.death_cause as fup_cause_of_death_local
,case when fup.needs_followup_reason = 'Graft Failure' then 'at0015' END as fup_status_failed --at0012::Patient Deceased
,case when fup.needs_followup_reason not in ('Deceased','Graft Failure','Lost to followup') then 'at0013' END as fup_status_infup --at0013::In Follow-up
,case when fup.needs_followup_reason not in ('Deceased','Graft Failure','Lost to followup') then fup.date_seen ELSE null END as fup_in_days_since_tx
, tx.txp_organ_detail_code as fup_graft_name_code
, decode(tx.txp_organ_detail_code,'RKi','Right Kidney','LKi','Left Kidney') as fup_graft_name
FROM                ods_et.ods_enis_transplant tx
LEFT OUTER JOIN     ods_et.ods_reg_kidney_vw fup
ON tx.txp_regn = fup.transplant_number and fup.occurrence = 'R' and fup.deleted = 'false'
WHERE  
tx.txp_fup_center_code like 'C%'
and tx.txp_date >= to_date ('01.01.2015', 'dd.mm.yyyy')
and tx.txp_date < to_date ('01.01.2020', 'dd.mm.yyyy')
and tx.txp_organ_detail_code in ('LKi','RKi')
--and rownum < 3
ORDER BY tx_id asc
;