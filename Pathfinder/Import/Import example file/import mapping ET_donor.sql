CREATE OR REPLACE VIEW EDITH_DONOR_VW AS
SELECT
--r.wdtr_d_regn,
'CR-T'||ORA_HASH(CONCAT(tx.txp_regn,23098),999999) AS tx_id,
-- d.d_regn                       AS d_non_anonimesed_id,
decode (d.d_sex,'F','Female','M','Male','Unknown') AS d_gender_birth,
decode (d.d_sex,'F','Female','M','Male','Unknown') AS d_gender_birth_val,
CASE d.d_type_desc WHEN 'Living' THEN 'at0008'                                                 -- at0005::DBD|"at0006::DCD"|"at0008::Living"
                    WHEN 'Cadaver' THEN decode(fup.donor_deceased_type,'Heartbeating','at0005','Non-heartbeating','at0006',null)
                    ELSE null
                    END         AS d_type,
'CR-D'||ORA_HASH(CONCAT(tx.txp_donor,23098),999999) d_id,
'Edith'                AS d_id_issuer,
'Edith'                AS d_id_assigner,
'Local id'                      AS d_id_type,
CASE WHEN (tx.txp_date=null OR d.d_dob=null) THEN null ELSE 'P'||trunc(months_between(tx.txp_date,d.d_dob) / 12)||'Y'||trunc(months_between(tx.txp_date,d.d_dob) - (trunc(months_between(tx.txp_date,d.d_dob) / 12) * 12))||'M' END as d_age,
d.d_abo                         as d_abo,
d.d_abo                         as d_abo_val,
decode (d.d_rh,'Pos','Positive','Neg','Negative') as d_rhesus, --rhesus needs to be removed but is mandatory, this needs to change!
d.d_rh                          as d_rhesus_val,
d.d_death_cause                 as d_death_cause,
d.d_death_cause_desc            as d_death_cause_val,
trunc(d.d_weight)               as d_weight,
'kg'                            as d_weight_unit,
trunc(d.d_height)                      as d_height,
'cm'                            as d_height_unit,
'Virology' as d_virology,
decode(d.d_hivab,'POS','Reactive','Neg','Non Reactive','Unknown') as d_hiv_ab,   -- positve echt hetzelfde als reactive?
decode(d.d_hivab,'POS','Reactive if IgG >2','Neg','Non Reactive','Unknown') as d_hiv_ab_val,
decode(d.d_hcvab,'POS','Reactive','Neg','Non Reactive','Unknown') as d_hcv_ab,   -- positve echt hetzelfde als reactive?
decode(d.d_hcvab,'POS','Reactive if IgG >2','Neg','Non Reactive','Unknown') as d_hcv_ab_val,   -- positve echt hetzelfde als reactive?
decode(d.d_cmvigg,'POS','Positive','Neg','Non Reactive','Unknown') as d_cmv_igg, -- positve echt hetzelfde als reactive?
decode(d.d_cmvigg,'POS','Positive if titer >2','Neg','Non Reactive','Unknown') as d_cmv_igg_val, -- positve echt hetzelfde als reactive?
'HLA'                           as d_hla_testname,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1) = 0 THEN NULL ELSE 'at0004' END as d_genefamily_code,
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
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,21) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,21) END as d_hla_code_20,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,22) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,22) END as d_hla_code_21,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,23) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,23) END as d_hla_code_22,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,24) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,24) END as d_hla_code_23,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,25) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,25) END as d_hla_code_24,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,26) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,26) END as d_hla_code_25,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,27) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,27) END as d_hla_code_26,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,28) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,28) END as d_hla_code_27,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,29) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,29) END as d_hla_code_28,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,30) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,30) END as d_hla_code_29,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,31) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,31) END as d_hla_code_30,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,32) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,32) END as d_hla_code_31,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,33) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,33) END as d_hla_code_32,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,34) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,34) END as d_hla_code_33,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,35) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,35) END as d_hla_code_34,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,1) END as d_hla_code_0_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,2) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,2) END as d_hla_code_1_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,3) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,3) END as d_hla_code_2_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,4) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,4) END as d_hla_code_3_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,5) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,5) END as d_hla_code_4_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,6) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,6) END as d_hla_code_5_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,7) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,7) END as d_hla_code_6_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,8) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,8) END as d_hla_code_7_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,9) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,9) END as d_hla_code_8_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,10) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,10) END as d_hla_code_9_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,11) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,11) END as d_hla_code_10_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,12) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,12) END as d_hla_code_11_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,13) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,13) END as d_hla_code_12_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,14) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,14) END as d_hla_code_13_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,15) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,15) END as d_hla_code_14_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,16) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,16) END as d_hla_code_15_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,17) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,17) END as d_hla_code_16_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,18) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,18) END as d_hla_code_17_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,19) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,19) END as d_hla_code_18_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,20) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,20) END as d_hla_code_19_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,21) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,21) END as d_hla_code_20_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,22) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,22) END as d_hla_code_21_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,23) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,23) END as d_hla_code_22_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,24) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,24) END as d_hla_code_23_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,25) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,25) END as d_hla_code_24_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,26) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,26) END as d_hla_code_25_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,27) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,27) END as d_hla_code_26_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,28) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,28) END as d_hla_code_27_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,29) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,29) END as d_hla_code_28_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,30) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,30) END as d_hla_code_29_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,31) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,31) END as d_hla_code_30_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,32) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,32) END as d_hla_code_31_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,33) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,33) END as d_hla_code_32_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,34) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,34) END as d_hla_code_33_val,
CASE WHEN REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,35) = 0 THEN NULL ELSE REGEXP_SUBSTR(SUBSTR(dhla.dlr_hla_string,-LENGTH(SUBSTR(dhla.dlr_hla_string,REGEXP_INSTR(dhla.dlr_hla_string,'[^ ]+',1,1)))),'[^ ]+',1,35) END as d_hla_code_34_val,
--REGEXP_COUNT(dhla.dlr_hla_string,'[^ ]+') AS COUNTHLA_ANTIGEN, -- Check if number antigens are not over 35, COLUMN should be deleted before import _val
--dhla.dlr_hla_string as d_hla_string,
--d.d_diabetes_mellitus,
decode(d.d_diabetes_mellitus,'1','E10', '2','E11','Y','DIA_UNSPEC') as d_diabetes_code, -- Needs a non-specified diabetes add to ICD10_diabetes,
decode(d.d_diabetes_mellitus,'1','Type 1 diabetes mellitus', '2','Type 2 diabetes mellitus','Y','Unspecified diabetes mellitus') as d_diabetes_desc,
decode(d.d_diabetes_mellitus,'U','No information available about diabetes') as d_diabetes_absence,
decode(d.d_diabetes_mellitus,'N','Patient is not diabetic') as d_diabetes_exclusion,
decode(d.d_malignancy,'Y','Evidence for malignant tumours') as d_malignant_tumour,
decode(d.d_malignancy,null,'No information available about malignant tumors') as d_malignant_tumour_absence,
decode(d.d_malignancy,'N','No evidence for malignant tumours') as d_malignant_tumour_exclusion,
CASE WHEN d.d_hypertension_treated IS NOT NULL THEN 'Anti hypertension drugs' ELSE null END as d_medication_name,
decode(d.d_hypertension_treated,'Y','true','N','false',null) as d_medication_ever_used
FROM             ods_et.ods_enis_transplant tx
JOIN             ods_et.ods_enis_tab_donor d ON tx.txp_donor = d.d_regn
LEFT OUTER JOIN  ods_et.ods_reg_kidney_vw fup ON tx.txp_regn =  fup.transplant_number and fup.occurrence = 'I' and fup.deleted = 'false'
LEFT OUTER JOIN  ods_et.ods_enis_don_hla dhla JOIN (select max(dlr_labnum) max_dlr_labnum, dlr_donor max_dlr_donor from ODS_ET.ods_enis_don_hla group by dlr_donor) ON dhla.dlr_labnum = max_dlr_labnum 
                 ON tx.txp_donor = dhla.dlr_donor 
 WHERE      
    tx.txp_fup_center_code like 'C%'
    and tx.txp_date >= to_date ('01.01.2015', 'dd.mm.yyyy')
    and tx.txp_date < to_date ('01.01.2020', 'dd.mm.yyyy')
    and tx.txp_organ_detail_code in ('LKi','RKi')
 --   and rownum < 3
    order by tx.txp_regn asc;