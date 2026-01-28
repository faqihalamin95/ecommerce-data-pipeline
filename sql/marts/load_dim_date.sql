-- Seed unknown date record for referential integrity
INSERT INTO mart.dim_date (
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
)
ON CONFLICT (date_key) DO NOTHING;

-- Determine date range from raw transaction timestamps
WITH date_bounds AS (
    SELECT
        MIN(created_at)::DATE AS min_date,
        MAX(created_at)::DATE AS max_date
    FROM raw.pakistan_ecommerce_raw
    WHERE created_at IS NOT NULL
)

INSERT INTO mart.dim_date (
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
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_key,
    d AS full_date,
    EXTRACT(DAY FROM d)::SMALLINT AS day,
    EXTRACT(MONTH FROM d)::SMALLINT AS month,
    TRIM(TO_CHAR(d, 'Month')) AS month_name,
    EXTRACT(QUARTER FROM d)::SMALLINT AS quarter,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(DOW FROM d)::SMALLINT AS day_of_week, -- PostgreSQL: 0=Sunday
    TRIM(TO_CHAR(d, 'Day')) AS day_name,
    CASE
        WHEN EXTRACT(DOW FROM d) IN (0, 6) THEN TRUE
        ELSE FALSE
    END AS is_weekend
FROM date_bounds,
     generate_series(
         date_bounds.min_date,
         date_bounds.max_date,
         INTERVAL '1 day'
     ) AS d
ON CONFLICT (date_key) DO NOTHING;
