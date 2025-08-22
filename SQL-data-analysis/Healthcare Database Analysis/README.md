Healthcare Database Analysis

📌 Project Overview

This project analyzes a healthcare database containing patient records, hospital admissions, treatments, and resource usage.
The goal is to extract insights that support decision-making in healthcare management, such as identifying common treatments, understanding patient demographics, and analyzing hospital occupancy trends.

🛠️ Tools & Technologies

PostgreSQL / MySQL / SQLite (SQL queries and database management)

DB Browser / pgAdmin (database exploration)

Excel / Power BI (optional for visualization)




Title: CMS Hospital General Information — SQL Analytics

Tech: PostgreSQL 17, pgAdmin, SQL (CTEs, CASE, regex), basic indexing

Dataset

Hospital registry from U.S. Centers for Medicare & Medicaid Services (CMS): facility metadata, ownership, emergency services, birthing-friendly flag, and star ratings.

Project Goals

Clean and standardize raw CSV into a relational model.

Produce analysis-ready views.

Derive KPIs and state/ownership/type insights for decision-making.

Pipeline

Ingest

Saved Excel to CSV (UTF-8), restricted to 38 fields.

Imported into cms.hospital_general_information_raw via \copy.

Modeling

Clean table: cms.hospitals (typed columns, booleans, numeric casts).

Analysis view: cms.v_hospitals_clean (grouped ownership/type labels, normalized text).

Cleaning highlights

Trim/normalize text; state upper-cased; city title-case.

ZIP normalized to 5 digits; phone formatted (###) ###-####.

Booleans mapped from Yes/No variants.

Ratings cast only when numeric (1–5).

Performance

Indexes on state, overall_rating, emergency_services.

Key Queries

National KPIs, hospitals by state, top states by average rating (n≥30), ratings by ownership/type, emergency coverage matrices, five-star showcase.
(See /sql/analysis.sql for full list.)

Results (sample — fill with your numbers)

Hospitals: X

Emergency services coverage: Y%

Share with rating: Z%

Avg rating (1–5): R

Top-rated states (n≥30): ST1 (r1), ST2 (r2), ST3 (r3)

Ownership with highest avg rating: Group G (rG)

Type with highest avg rating: Type T (rT)

Reproducibility
-- Ingest
\copy cms.hospital_general_information_raw FROM '.../Hospital_General_Information_CLEAN.csv'
WITH (FORMAT csv, HEADER true);

-- Load & clean (see /sql/setup.sql)
-- Creates cms.hospitals, formats ZIP/phone, builds view v_hospitals_clean
