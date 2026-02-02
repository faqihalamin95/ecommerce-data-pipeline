-- TRUNCATE AND LOAD dim_date dimension table
TRUNCATE TABLE foundation.dim_date;

-- Seed unknown date record for referential integrity
INSERT INTO foundation.dim_date (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    day_of_week,
    day_name,
    is_weekend
)
VALUES (
    -1,
    DATE '1900-01-01',
    0,
    0,
    'Unknown',
    0,
    0,
    0,
    'Unknown',
    FALSE
);

-- Determine date range from staging transaction timestamps
WITH date_bounds AS (
    SELECT
        MIN(created_at)::DATE AS min_date,
        MAX(created_at)::DATE AS max_date
    FROM staging.stg_pakistan_ecommerce
    WHERE created_at IS NOT NULL
)
INSERT INTO foundation.dim_date (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    day_of_week,
    day_name,
    is_weekend
)
SELECT
    TO_CHAR(d.full_date, 'YYYYMMDD')::INT        AS date_key,
    d.full_date                                  AS full_date,
    EXTRACT(DAY FROM d.full_date)::SMALLINT      AS day,
    EXTRACT(MONTH FROM d.full_date)::SMALLINT    AS month,
    TRIM(TO_CHAR(d.full_date, 'Month'))          AS month_name,
    EXTRACT(QUARTER FROM d.full_date)::SMALLINT  AS quarter,
    EXTRACT(YEAR FROM d.full_date)::INT           AS year,
    EXTRACT(ISODOW FROM d.full_date)::SMALLINT   AS day_of_week, -- 1=Mon, 7=Sun
    TRIM(TO_CHAR(d.full_date, 'Day'))            AS day_name,
    CASE
        WHEN EXTRACT(ISODOW FROM d.full_date) IN (6, 7) THEN TRUE
        ELSE FALSE
    END                                          AS is_weekend
FROM date_bounds,
     generate_series(
         date_bounds.min_date,
         date_bounds.max_date,
         INTERVAL '1 day'
     ) AS d(full_date);
