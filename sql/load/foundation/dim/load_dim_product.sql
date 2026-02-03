-- TRUNCATE AND LOAD dim_product dimension table
TRUNCATE TABLE foundation.dim_product CASCADE;

-- Seed unknown product record for referential integrity
INSERT INTO foundation.dim_product (
    product_key,
    sku,
    category_name
)
VALUES (
    -1,
    'UNKNOWN',
    'Unknown'
);

-- Load distinct products from raw transactions
INSERT INTO foundation.dim_product (
    sku,
    category_name
)
SELECT
    TRIM(sku) AS sku,
    MAX(TRIM(category_name_1)) AS category_name
FROM staging.stg_pakistan_ecommerce
WHERE
    sku IS NOT NULL
    AND TRIM(sku) <> ''
GROUP BY TRIM(sku);
; 
