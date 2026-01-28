-- Seed unknown customer record for referential integrity
INSERT INTO mart.dim_customer (
    customer_key,
    customer_id,
    customer_since,
    first_order_date,
    last_order_date,
    effective_start_date,
    effective_end_date,
    is_current
)
VALUES (
    -1,
    'UNKNOWN',
    NULL,
    NULL,
    NULL,
    DATE '1900-01-01',
    NULL,
    TRUE
)
ON CONFLICT (customer_key) DO NOTHING;

-- Aggregate customer attributes from raw transactions
WITH customer_base AS (
    SELECT
        "customer_id"::TEXT AS customer_id,
        MIN(created_at)::DATE AS first_order_date, 
        MAX(created_at)::DATE AS last_order_date,
        COALESCE(
            MIN("customer_since")::DATE,
            MIN(created_at)::DATE
        ) AS customer_since
    FROM raw.pakistan_ecommerce_raw
    WHERE
        "customer_id" IS NOT NULL
    GROUP BY "customer_id"
)
INSERT INTO mart.dim_customer (
    customer_id,
    customer_since,
    first_order_date,
    last_order_date,
    effective_start_date,
    effective_end_date,
    is_current
)
SELECT
    customer_id,
    customer_since,
    first_order_date,
    last_order_date,
    first_order_date AS effective_start_date,
    NULL AS effective_end_date,
    TRUE AS is_current
FROM customer_base
ON CONFLICT (customer_id, effective_start_date) DO NOTHING;
