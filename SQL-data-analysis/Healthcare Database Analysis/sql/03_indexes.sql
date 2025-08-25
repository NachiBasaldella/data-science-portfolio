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

-- Asegura que exista el esquema y que estés usándolo
CREATE SCHEMA IF NOT EXISTS cms;
SET search_path TO cms, public;

-- (opcional) comprueba que la tabla staging exista en cms
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_schema='cms' AND table_name='hospital_general_information_raw';


-- Falla si falta la tabla staging (para evitar sorpresas)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema='cms' AND table_name='hospital_general_information_raw'
  ) THEN
    RAISE EXCEPTION 'Falta cms.hospital_general_information_raw. Ejecuta 01_ingest_raw.sql primero.';
  END IF;
END$$;

DROP VIEW  IF EXISTS cms.v_hospitals_clean;
DROP TABLE IF EXISTS cms.hospitals;

CREATE TABLE cms.hospitals AS
WITH s AS (
  SELECT
    TRIM(provider_id) AS provider_id,
    INITCAP(TRIM(facility_name)) AS facility_name,
    INITCAP(TRIM(address)) AS address,
    INITCAP(TRIM(city)) AS city,
    UPPER(TRIM(state)) AS state,
    LPAD(SUBSTRING(REGEXP_REPLACE(COALESCE(zip_code,''), '\D', '', 'g') FROM 1 FOR 5), 5, '0')::CHAR(5) AS zip_code,
    INITCAP(TRIM(county_name)) AS county_name,

    -- Teléfono (###) ###-####
    CASE
      WHEN REGEXP_REPLACE(COALESCE(phone_number,''), '\D', '', 'g') ~ '^\d{10}$'
        THEN '(' || SUBSTRING(REGEXP_REPLACE(phone_number, '\D', '', 'g') FROM 1 FOR 3)
             || ') ' || SUBSTRING(REGEXP_REPLACE(phone_number, '\D', '', 'g') FROM 4 FOR 3)
             || '-' || SUBSTRING(REGEXP_REPLACE(phone_number, '\D', '', 'g') FROM 7 FOR 4)
      WHEN REGEXP_REPLACE(COALESCE(phone_number,''), '\D', '', 'g') ~ '^1\d{10}$'
        THEN '(' || SUBSTRING(REGEXP_REPLACE(phone_number, '\D', '', 'g') FROM 2 FOR 3)
             || ') ' || SUBSTRING(REGEXP_REPLACE(phone_number, '\D', '', 'g') FROM 5 FOR 3)
             || '-' || SUBSTRING(REGEXP_REPLACE(phone_number, '\D', '', 'g') FROM 8 FOR 4)
      ELSE NULL
    END AS phone_number,

    INITCAP(TRIM(hospital_type))      AS hospital_type,
    INITCAP(TRIM(hospital_ownership)) AS hospital_ownership,

    CASE
      WHEN emergency_services ~* '^(y|yes|true|t|1)' THEN TRUE
      WHEN emergency_services ~* '^(n|no|false|f|0)' THEN FALSE
      ELSE NULL
    END::BOOLEAN AS emergency_services,

    CASE
      WHEN birthing_friendly ~* '^(y|yes|true|t|1|meets)' THEN TRUE
      WHEN birthing_friendly ~* '^(n|no|false|f|0|does\s*not)' THEN FALSE
      ELSE NULL
    END::BOOLEAN AS birthing_friendly,

    CASE
      WHEN overall_rating ~ '^\s*[1-5]\s*$' THEN overall_rating::INT
      ELSE NULL
    END AS overall_rating,

    TRIM(overall_rating_footnote) AS overall_rating_footnote,

    CASE WHEN mort_group_measure_count           ~ '^\d+$' THEN mort_group_measure_count::INT           END AS mort_group_measure_count,
    CASE WHEN count_facility_mort_measures       ~ '^\d+$' THEN count_facility_mort_measures::INT       END AS count_facility_mort_measures,
    CASE WHEN count_mort_better                  ~ '^\d+$' THEN count_mort_better::INT                  END AS count_mort_better,
    CASE WHEN count_mort_no_different            ~ '^\d+$' THEN count_mort_no_different::INT            END AS count_mort_no_different,
    CASE WHEN count_mort_worse                   ~ '^\d+$' THEN count_mort_worse::INT                   END AS count_mort_worse,
    TRIM(mort_group_footnote) AS mort_group_footnote,

    CASE WHEN safety_group_measure_count         ~ '^\d+$' THEN safety_group_measure_count::INT         END AS safety_group_measure_count,
    CASE WHEN count_facility_safety_measures     ~ '^\d+$' THEN count_facility_safety_measures::INT     END AS count_facility_safety_measures,
    CASE WHEN count_safety_better                ~ '^\d+$' THEN count_safety_better::INT                END AS count_safety_better,
    CASE WHEN count_safety_no_different          ~ '^\d+$' THEN count_safety_no_different::INT          END AS count_safety_no_different,
    CASE WHEN count_safety_worse                 ~ '^\d+$' THEN count_safety_worse::INT                 END AS count_safety_worse,
    TRIM(safety_group_footnote) AS safety_group_footnote,

    CASE WHEN readm_group_measure_count          ~ '^\d+$' THEN readm_group_measure_count::INT          END AS readm_group_measure_count,
    CASE WHEN count_facility_readm_measures      ~ '^\d+$' THEN count_facility_readm_measures::INT      END AS count_facility_readm_measures,
    CASE WHEN count_readm_better                 ~ '^\d+$' THEN count_readm_better::INT                 END AS count_readm_better,
    CASE WHEN count_readm_no_different           ~ '^\d+$' THEN count_readm_no_different::INT           END AS count_readm_no_different,
    CASE WHEN count_readm_worse                  ~ '^\d+$' THEN count_readm_worse::INT                  END AS count_readm_worse,
    TRIM(readm_group_footnote) AS readm_group_footnote,

    CASE WHEN pt_exp_group_measure_count         ~ '^\d+$' THEN pt_exp_group_measure_count::INT         END AS pt_exp_group_measure_count,
    CASE WHEN count_facility_pt_exp_measures     ~ '^\d+$' THEN count_facility_pt_exp_measures::INT     END AS count_facility_pt_exp_measures,
    TRIM(pt_exp_group_footnote) AS pt_exp_group_footnote,

    CASE WHEN te_group_measure_count             ~ '^\d+$' THEN te_group_measure_count::INT             END AS te_group_measure_count,
    CASE WHEN count_facility_te_measures         ~ '^\d+$' THEN count_facility_te_measures::INT         END AS count_facility_te_measures,
    TRIM(te_group_footnote) AS te_group_footnote
  FROM cms.hospital_general_information_raw
)
SELECT s.*,
       (s.overall_rating IS NOT NULL) AS has_numeric_rating,
       (s.overall_rating = 5)         AS is_five_star,
       now() AS _cleaned_at
FROM s;

CREATE OR REPLACE VIEW cms.v_hospitals_clean AS
SELECT provider_id, facility_name, address, city, state, zip_code, county_name, phone_number,
       hospital_type, hospital_ownership, emergency_services, birthing_friendly,
       overall_rating, has_numeric_rating, is_five_star
FROM cms.hospitals;

-- Índices para acelerar filtros y agregaciones frecuentes
SET search_path TO cms, public;

-- Verificación mínima
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema='cms' AND table_name='hospitals'
  ) THEN
    RAISE EXCEPTION 'Falta cms.hospitals. Ejecuta 02_clean_model.sql primero.';
  END IF;
END$$;

-- Índices BTREE estándar
-- =========================

-- Por estado 
CREATE INDEX IF NOT EXISTS ix_hospitals_state
  ON cms.hospitals (state);

-- Por rating general (1–5)
CREATE INDEX IF NOT EXISTS ix_hospitals_rating
  ON cms.hospitals (overall_rating);

-- Compuesto: estado + rating 
CREATE INDEX IF NOT EXISTS ix_hospitals_state_rating
  ON cms.hospitals (state, overall_rating)
  WHERE overall_rating IS NOT NULL; 

-- Cobertura de emergencias (boolean)
CREATE INDEX IF NOT EXISTS ix_hospitals_emergency
  ON cms.hospitals (emergency_services);

-- Propiedad y tipo (para breakdowns por categoría)
CREATE INDEX IF NOT EXISTS ix_hospitals_ownership
  ON cms.hospitals (hospital_ownership);

CREATE INDEX IF NOT EXISTS ix_hospitals_type
  ON cms.hospitals (hospital_type);

-- Búsqueda case-insensitive por nombre (para ILIKE '...%')
CREATE INDEX IF NOT EXISTS ix_hospitals_facility_ilower
  ON cms.hospitals (LOWER(facility_name));


CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS ix_hospitals_facility_trgm
  ON cms.hospitals
  USING gin (facility_name gin_trgm_ops);

ANALYZE cms.hospitals;


EXPLAIN ANALYZE
SELECT state, COUNT(*) AS n, ROUND(AVG(overall_rating)::numeric,2) AS avg_rating
FROM cms.v_hospitals_clean
WHERE overall_rating IS NOT NULL
GROUP BY state
ORDER BY avg_rating DESC
LIMIT 10;

EXPLAIN ANALYZE
SELECT *
FROM cms.v_hospitals_clean
WHERE emergency_services = TRUE
  AND state = 'CA'
  AND overall_rating >= 4;

EXPLAIN ANALYZE
SELECT *
FROM cms.hospitals
WHERE LOWER(facility_name) LIKE 'saint%';

EXPLAIN ANALYZE
SELECT *
FROM cms.hospitals
WHERE facility_name % 'St Joseph'; 


