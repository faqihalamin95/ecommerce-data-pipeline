INSERT INTO mart.dim_date
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_key,
    d AS full_date,
    EXTRACT(DAY FROM d)::SMALLINT AS day,
    EXTRACT(MONTH FROM d)::SMALLINT AS month,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(QUARTER FROM d)::SMALLINT AS quarter,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(DOW FROM d)::SMALLINT AS day_of_week,
    TO_CHAR(d, 'Day') AS day_name,
    CASE
        WHEN EXTRACT(DOW FROM d) IN (0, 6) THEN TRUE
        ELSE FALSE
    END AS is_weekend
FROM generate_series(
    (SELECT MIN(created_at)::DATE FROM raw.pakistan_ecommerce_raw),
    (SELECT MAX(created_at)::DATE FROM raw.pakistan_ecommerce_raw),
    INTERVAL '1 day'
) AS d
ON CONFLICT (date_key) DO NOTHING;
