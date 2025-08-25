CREATE SCHEMA IF NOT EXISTS cms;

CREATE TABLE IF NOT EXISTS cms._etl_log (
  step  text PRIMARY KEY,
  ran_at timestamptz DEFAULT now(),
  notes text
);

SET client_encoding = 'UTF8';
SET search_path TO cms, public;

-- 1) (re)crear tabla RAW con columnas de texto para ingesta segura
DROP TABLE IF EXISTS cms.hospital_general_information_raw;

CREATE TABLE cms.hospital_general_information_raw ( 
provider_id                         TEXT,
    facility_name                       TEXT,
    address                             TEXT,
    city                                TEXT,
    state                               TEXT,
    zip_code                            TEXT,
    county_name                         TEXT,
    phone_number                        TEXT,
    hospital_type                       TEXT,
    hospital_ownership                  TEXT,
    emergency_services                  TEXT,
    birthing_friendly                   TEXT,
    overall_rating                      TEXT,
    overall_rating_footnote             TEXT,
    mort_group_measure_count            TEXT,
    count_facility_mort_measures        TEXT,
    count_mort_better                   TEXT,
    count_mort_no_different             TEXT,
    count_mort_worse                    TEXT,
    mort_group_footnote                 TEXT,
    safety_group_measure_count          TEXT,
    count_facility_safety_measures      TEXT,
    count_safety_better                 TEXT,
    count_safety_no_different           TEXT,
    count_safety_worse                  TEXT,
    safety_group_footnote               TEXT,
    readm_group_measure_count           TEXT,
    count_facility_readm_measures       TEXT,
    count_readm_better                  TEXT,
    count_readm_no_different            TEXT,
    count_readm_worse                   TEXT,
    readm_group_footnote                TEXT,
    pt_exp_group_measure_count          TEXT,
    count_facility_pt_exp_measures      TEXT,
    pt_exp_group_footnote               TEXT,
    te_group_measure_count              TEXT,
    count_facility_te_measures          TEXT,
    te_group_footnote                   TEXT,

    _ingested_at                        TIMESTAMPTZ DEFAULT now()
);

COPY cms.hospital_general_information_raw (
    provider_id, facility_name, address, city, state, zip_code, county_name, phone_number,
    hospital_type, hospital_ownership, emergency_services, birthing_friendly,
    overall_rating, overall_rating_footnote,
    mort_group_measure_count, count_facility_mort_measures, count_mort_better,
    count_mort_no_different, count_mort_worse, mort_group_footnote,
    safety_group_measure_count, count_facility_safety_measures, count_safety_better,
    count_safety_no_different, count_safety_worse, safety_group_footnote,
    readm_group_measure_count, count_facility_readm_measures, count_readm_better,
    count_readm_no_different, count_readm_worse, readm_group_footnote,
    pt_exp_group_measure_count, count_facility_pt_exp_measures, pt_exp_group_footnote,
    te_group_measure_count, count_facility_te_measures, te_group_footnote
)
FROM 'C:\pgcopy\Hospital_General_Information_CLEAN.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', NULL '');

SELECT COUNT(*) FROM cms.hospital_general_information_raw;

SELECT * FROM cms.hospital_general_information_raw LIMIT 20;

INSERT INTO cms._etl_log(step, notes) VALUES ('01_ingest_raw', 'CSV cargado a tabla staging');


