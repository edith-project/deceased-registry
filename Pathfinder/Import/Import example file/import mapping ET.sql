SELECT
fup.transplant_number           AS tx_id,
 d.d_regn                       AS d_non_anonimesed_id,
 ORA_HASH(CONCAT(d.d_regn, d.d_insert_date),1000000) d_id,
'Eurotransplant'                AS d_id_issuer,
'Eurotransplant'                AS d_id_assigner,
'Annonimsed donor'              AS d_id_type,
d.d_sex                         AS d_gender_birth,
CASE d.d_type_desc WHEN 'Living' THEN 'at0008'                                                 -- at0005::DBD|"at0006::DCD"|"at0008::Living"
                    WHEN 'Cadaver' THEN decode(fup.donor_deceased_type,'Heartbeating','at0005','Non-heartbeating','at0006',null)
                    ELSE null
                    END         AS d_type,
'P'||trunc(months_between(d.d_death_date,d.d_dob) / 12)||'Y'||trunc(months_between(d.d_death_date,d.d_dob) - (trunc(months_between(d.d_death_date,d.d_dob) / 12) * 12))||'M' as d_age,
d.d_abo                         as d_abo,
d.d_rh                          as d_rhesus,
d.d_death_cause                 as d_death_cause,
d.d_weight                      as d_weight,
'kg'                            as d_weight_unit,
d.d_height                      as d_height,
'cm'                            as d_height_unit,
decode(d.d_hivab,'POS','Reactive','Neg','Non Reactive','Unknown') as d_hiv_ab,   -- posiitve echt hetzelfde als reactive?
decode(d.d_hcvab,'POS','Reactive','Neg','Non Reactive','Unknown') as d_hcv_ab,   -- posiitve echt hetzelfde als reactive?
decode(d.d_cmvigg,'POS','Reactive','Neg','Non Reactive','Unknown') as d_cmv_igg, -- posiitve echt hetzelfde als reactive?
'HLA'                           as d_donorhla_testname,
'at0004'                        as d_genefamily_code_1,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_2,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_3,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_4,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_5,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_6,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_7,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_8,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_9,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_10,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_11,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_12,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_13,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_14,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_15,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_16,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_17,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_18,                  --"at0004::HLA"
'at0004'                        as d_genefamily_code_19,                  --"at0004::HLA"
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,1) END as d_hla_code_0,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,2) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,2) END as d_hla_code_1,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,3) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,3) END as d_hla_code_2,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,4) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,4) END as d_hla_code_3,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,5) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,5) END as d_hla_code_4,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,6) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,6) END as d_hla_code_5,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,7) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,7) END as d_hla_code_6,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,8) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,8) END as d_hla_code_7,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,9) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,9) END as d_hla_code_8,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,10) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,10) END as d_hla_code_9,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,11) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,11) END as d_hla_code_10,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,12) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,12) END as d_hla_code_11,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,13) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,13) END as d_hla_code_12,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,14) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,14) END as d_hla_code_13,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,15) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,15) END as d_hla_code_14,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,16) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,16) END as d_hla_code_15,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,17) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,17) END as d_hla_code_16,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,18) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,18) END as d_hla_code_17,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,19) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,19) END as d_hla_code_18,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,20) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,20) END as d_hla_code_19,
REGEXP_COUNT(dhla.dlr_hla_string,'[^ ]+') AS COUNTHLA_ANTIGEN,
dhla.dlr_hla_string as d_hla_string,
d.d_diabetes_mellitus,
decode(d.d_diabetes_mellitus,'1','E10', '2','E11','Y','DIA_UNSPEC') as d_diabetes_code, -- Needs a non-specified diabetes add to ICD10_diabetes,
decode(d.d_diabetes_mellitus,'1','Type 1 diabetes mellitus', '2','Type 2 diabetes mellitus','Y','Unspecified diabetes mellitus') as d_diabetes_desc,
decode(d.d_diabetes_mellitus,'U','No information available about diabetes') as d_diabetes_absence,
decode(d.d_diabetes_mellitus,'N','Patient is not diabetic') as d_diabetes_exclusion,
decode(d.d_malignancy,'Y','Evidence for malignant tumours') as d_malignant_tumour,
decode(d.d_malignancy,null,'No information available about malignant tumors') as d_malignant_tumour_absence,
decode(d.d_malignancy,'N','No evidence for malignant tumours') as d_malignant_tumour_exclusion,
CASE WHEN d.d_hypertension_treated IS NOT NULL THEN 'Anti hypertension drugs' ELSE null END as d_medication_name,
decode(d.d_hypertension_treated,'Y','true','N','false',null) as d_medication_ever_used,

fup.deleted
FROM             ods_et.ods_reg_kidney_vw fup,
                 ods_et.ods_enis_tab_donor d,
                 ods_et.ods_enis_transplant tx,
                 ods_et.ods_enis_don_hla dhla
WHERE
    fup.transplant_number = tx.txp_regn
    AND tx.txp_donor = d.d_regn
    and d.d_regn = dhla.dlr_donor
    and fup.deleted = 'false'
 --   and d.d_type_desc = 'Cadaver'