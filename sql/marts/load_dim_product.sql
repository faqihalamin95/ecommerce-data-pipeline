-- step 1: unknown row
INSERT INTO mart.dim_product (
    product_key,
    sku,
    category_name,
    is_active
)
VALUES (
    -1,
    'UNKNOWN',
    'Unknown',
    FALSE
)
ON CONFLICT (product_key) DO NOTHING;

-- step 2: actual products
INSERT INTO mart.dim_product (
    sku,
    category_name
)
SELECT DISTINCT
    TRIM(sku) AS sku,
    TRIM(category_name_1) AS category_name
FROM raw.pakistan_ecommerce_raw
WHERE
    sku IS NOT NULL
    AND TRIM(sku) <> ''
ON CONFLICT (sku) DO NOTHING;
