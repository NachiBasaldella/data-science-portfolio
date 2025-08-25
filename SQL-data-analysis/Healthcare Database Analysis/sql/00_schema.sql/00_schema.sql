CREATE SCHEMA IF NOT EXISTS cms;

CREATE TABLE IF NOT EXISTS cms._etl_log (
  step  text PRIMARY KEY,
  ran_at timestamptz DEFAULT now(),
  notes text
);

