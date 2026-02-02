-- TRUNCATE AND LOAD dim_customer dimension table
TRUNCATE TABLE foundation.dim_customer;

-- Seed unknown customer record for referential integrity
INSERT INTO foundation.dim_customer (
    customer_key,
    customer_id,
    customer_since,
    first_order_date,
    last_order_date
)
VALUES (
    -1,
    'UNKNOWN',
    NULL,
    NULL,
    NULL
);

-- Aggregate customer attributes from staging table
WITH customer_base AS (
    SELECT
        "customer_id"::TEXT AS customer_id,
        MIN(created_at)::DATE AS first_order_date, 
        MAX(created_at)::DATE AS last_order_date,
        COALESCE(
            MIN("customer_since")::DATE,
            MIN(created_at)::DATE
        ) AS customer_since
    FROM staging.stg_pakistan_ecommerce
    WHERE "customer_id" IS NOT NULL
    GROUP BY "customer_id"
)
INSERT INTO foundation.dim_customer (
    customer_id,
    customer_since,
    first_order_date,
    last_order_date
)
SELECT
    customer_id,
    customer_since,
    first_order_date,
    last_order_date
FROM customer_base;
