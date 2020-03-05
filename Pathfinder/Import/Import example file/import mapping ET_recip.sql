CREATE OR REPLACE VIEW EDITH_RECIP_VW AS
SELECT
--r.wdtr_d_regn,
'CR-R'||r.wdtr_r_regn as SubjectId,
'en' as language,
'HR' as teritory,
'Wouter Zanen' as composer,
'EUROTRANSPLANT' as id_namespace,
'NCA CROATIA' as id_scheme,
--fup.followup_center,
'CR-T'||ORA_HASH(CONCAT(tx.txp_regn,23098),999999) AS tx_id,
'Virology' as r_virology,
decode(r.wdtr_r_hivab,'POS','Reactive','Neg','Non Reactive','Unknown') as r_hiv_ab,   -- positve echt hetzelfde als reactive?
decode(r.wdtr_r_hivab,'POS','Reactive if IgG >2','Neg','Non Reactive','Unknown') as r_hiv_ab_value,   -- positve echt hetzelfde als reactive?
decode(r.wdtr_r_hcvab,'POS','Reactive','Neg','Non Reactive','Unknown') as r_hcv_ab,   -- positve echt hetzelfde als reactive?
decode(r.wdtr_r_hcvab,'POS','Reactive if IgG >2','Neg','Non Reactive','Unknown') as r_hcv_ab_value,   -- positve echt hetzelfde als reactive?
decode(r.wdtr_r_hbsab,'POS','Reactive','Neg','Non Reactive','Unknown') as r_hbv,      -- We only have HBsAb in our dataaset, but anti-HBc, anti-HBe, anti-HBs exist, HBV is not very precise?
decode(r.wdtr_r_hbsab,'POS','Reactive if IgG >2','Neg','Non Reactive','Unknown') as r_hbv_value,      -- We only have HBsAb in our dataaset, but anti-HBc, anti-HBe, anti-HBs exist, HBV is not very precise?
decode(r.wdtr_r_cmvigg,'POS','Positive','Neg','Non Reactive','Unknown') as r_cmv_igg, -- positve echt hetzelfde als reactive?
decode(r.wdtr_r_cmvigg,'POS','Positive if titer >2','Neg','Non Reactive','Unknown') as r_cmv_igg_value, -- positve echt hetzelfde als reactive?
CASE WHEN r.wdtr_wl_dia_tech = 'Recipient not on dialysis' then null else 'Dialysis' END as r_dial_name,
CASE WHEN r.wdtr_wl_dia_tech like '%Haemodialysis%' then 'at0004'
     WHEN  r.wdtr_wl_dia_tech like '%Peritoneal%' Then 'at0007'
     ELSE null END as r_dial_tech, -- "at0004::HD"|"at0007::PD",
--CASE WHEN (r.wdtr_r_dob is null OR r.wdtr_wl_date_first_dial is null) THEN null else 'P'||trunc(months_between(r.wdtr_wl_date_first_dial,r.wdtr_r_dob) / 12)||'Y'||trunc(months_between(r.wdtr_wl_date_first_dial,r.wdtr_r_dob) - (trunc(months_between(r.wdtr_wl_date_first_dial,r.wdtr_r_dob) / 12) * 12))||'M' END as r_dial_age_at_first,
CASE WHEN (r.wdtr_r_dob is null OR r.wdtr_wl_date_first_dial is null) THEN null else trunc(months_between(r.wdtr_wl_date_first_dial,r.wdtr_r_dob) / 12) END as r_dial_age_at_first,
'yr' as r_dial_age_at_first_unit,
CASE WHEN ((tx.TXP_ON_WL_SINCE-r.wdtr_wl_date_first_dial) < 0) OR (tx.TXP_ON_WL_SINCE is null OR r.wdtr_wl_date_first_dial is null) THEN null else 'P'||trunc(tx.TXP_ON_WL_SINCE-r.wdtr_wl_date_first_dial)||'D' END as r_dial_time_from_listing,
CASE  WHEN r.WDTR_R_MAX_PRA >4 THEN 'True' else 'False' END as r_sensitised, -- Highest PRA before transplant >=5%
null as r_current_pra_technique, -- not available in wd_txp_recipients_mv should be added later.
r.wdtr_r_txp_pra as r_current_pra,
'%' as r_current_pra_unit,
null as r_highest_pra_technique, -- not available in wd_txp_recipients_mv should be added later.
r.wdtr_r_max_pra as r_highest_pra,
'%' as r_highest_pra_unit,
'HLA'                           as r_hla_testname,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1) = 0 THEN NULL ELSE 'at0004' END as r_genefamily_code_0,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,1) END as r_hla_code_0,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,2) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,2) END as r_hla_code_1,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,3) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,3) END as r_hla_code_2,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,4) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,4) END as r_hla_code_3,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,5) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,5) END as r_hla_code_4,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,6) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,6) END as r_hla_code_5,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,7) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,7) END as r_hla_code_6,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,8) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,8) END as r_hla_code_7,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,9) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,9) END as r_hla_code_8,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,10) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,10) END as r_hla_code_9,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,11) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,11) END as r_hla_code_10,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,12) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,12) END as r_hla_code_11,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,13) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,13) END as r_hla_code_12,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,14) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,14) END as r_hla_code_13,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,15) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,15) END as r_hla_code_14,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,16) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,16) END as r_hla_code_15,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,17) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,17) END as r_hla_code_16,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,18) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,18) END as r_hla_code_17,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,19) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,19) END as r_hla_code_18,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,20) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,20) END as r_hla_code_19,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,21) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,21) END as r_hla_code_20,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,22) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,22) END as r_hla_code_21,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,23) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,23) END as r_hla_code_22,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,24) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,24) END as r_hla_code_23,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,25) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,25) END as r_hla_code_24,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,26) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,26) END as r_hla_code_25,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,27) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,27) END as r_hla_code_26,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,28) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,28) END as r_hla_code_27,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,29) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,29) END as r_hla_code_28,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,30) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,30) END as r_hla_code_29,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,31) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,31) END as r_hla_code_30,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,32) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,32) END as r_hla_code_31,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,33) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,33) END as r_hla_code_32,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,34) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,34) END as r_hla_code_33,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,35) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,35) END as r_hla_code_34,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,1) END as r_hla_code_0_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,2) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,2) END as r_hla_code_1_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,3) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,3) END as r_hla_code_2_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,4) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,4) END as r_hla_code_3_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,5) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,5) END as r_hla_code_4_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,6) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,6) END as r_hla_code_5_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,7) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,7) END as r_hla_code_6_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,8) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,8) END as r_hla_code_7_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,9) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,9) END as r_hla_code_8_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,10) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,10) END as r_hla_code_9_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,11) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,11) END as r_hla_code_10_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,12) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,12) END as r_hla_code_11_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,13) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,13) END as r_hla_code_12_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,14) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,14) END as r_hla_code_13_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,15) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,15) END as r_hla_code_14_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,16) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,16) END as r_hla_code_15_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,17) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,17) END as r_hla_code_16_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,18) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,18) END as r_hla_code_17_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,19) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,19) END as r_hla_code_18_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,20) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,20) END as r_hla_code_19_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,21) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,21) END as r_hla_code_20_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,22) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,22) END as r_hla_code_21_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,23) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,23) END as r_hla_code_22_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,24) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,24) END as r_hla_code_23_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,25) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,25) END as r_hla_code_24_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,26) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,26) END as r_hla_code_25_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,27) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,27) END as r_hla_code_26_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,28) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,28) END as r_hla_code_27_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,29) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,29) END as r_hla_code_28_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,30) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,30) END as r_hla_code_29_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,31) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,31) END as r_hla_code_30_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,32) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,32) END as r_hla_code_31_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,33) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,33) END as r_hla_code_32_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,34) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,34) END as r_hla_code_33_val,
CASE WHEN REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,35) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(rhla.rlr_hla_string,-LENGTH(SUBSTR(rhla.rlr_hla_string,REGEXP_INSTR(rhla.rlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,35) END as r_hla_code_34_val,
--REGEXP_COUNT(rhla.rlr_hla_string,'[^ ]+') AS COUNTHLA_ANTIGEN, -- Check if number antigens are not over 35, COLUMN should be deleted before import 
--rhla.rlr_hla_string as r_hla_string,
fup.primary_renal_disease_code as r_prim_diag_local,
r.wdtr_r_abo as r_blood_group,
r.wdtr_r_abo as r_blood_group_value,
decode (SUBSTR( r.wdtr_r_abo_rh, -3),'Pos','Positive','Neg','Negative') as r_rhesus, --rhesus needs to be removed but is mandatory, this needs to change!
SUBSTR( r.wdtr_r_abo_rh, -3) as r_rhesus_value, --rhesus needs to be removed but is mandatory, this needs to change!
CASE WHEN ((r.wdtr_r_dob is null OR tx.TXP_ON_WL_SINCE is null)) THEN null else 'P'||trunc(months_between(tx.TXP_ON_WL_SINCE,r.wdtr_r_dob) / 12)||'Y'||trunc(months_between(tx.TXP_ON_WL_SINCE,r.wdtr_r_dob) - (trunc(months_between(tx.TXP_ON_WL_SINCE,r.wdtr_r_dob) / 12) * 12))||'M' END as r_age_at_listing,
CASE WHEN ((r.wdtr_r_dob is null OR tx.TXP_DATE is null)) THEN null else 'P'||trunc(months_between(tx.TXP_DATE,r.wdtr_r_dob) / 12)||'Y'||trunc(months_between(tx.TXP_DATE,r.wdtr_r_dob) - (trunc(months_between(tx.TXP_DATE,r.wdtr_r_dob) / 12) * 12))||'M' END as r_age_at_transplant,
CASE WHEN (tx.txp_date is null OR r.wdtr_wl_date_first_dial is null) THEN null else 'P'||(trunc(tx.txp_date)-trunc(wdtr_wl_date_first_dial))||'D' END as tx_time_dial_and_transplant
--fup.deleted
FROM                ods_et.ods_enis_transplant tx
JOIN                dwh.wd_txp_recipients_mv r   ON    tx.txp_recip = r.wdtr_r_regn and tx.txp_donor = r.wdtr_d_regn
LEFT OUTER JOIN     ods_et.ods_reg_kidney_vw fup ON tx.txp_regn = fup.transplant_number and fup.occurrence = 'I' and fup.deleted = 'false'
LEFT OUTER JOIN     ods_et.ods_enis_rec_hla rhla JOIN (select max(rlr_labnum) max_rlr_labnum, rlr_recip max_rlr_recip from ods_et.ods_enis_rec_hla where rlr_result_type_desc = 'HLA' group by rlr_recip) ON rhla.rlr_labnum = max_rlr_labnum 
                    ON tx.txp_recip = rhla.rlr_recip 
WHERE
tx.txp_fup_center_code like 'C%'
and tx.txp_date >= to_date ('01.01.2015', 'dd.mm.yyyy')
and tx.txp_date < to_date ('01.01.2020', 'dd.mm.yyyy')
and tx.txp_organ_detail_code in ('LKi','RKi')
ORDER BY tx_id asc;

