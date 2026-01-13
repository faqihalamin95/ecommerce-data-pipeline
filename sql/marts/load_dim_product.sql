INSERT INTO mart.dim_product (
    sku,
    category_name,
    price,
    created_at
)
SELECT DISTINCT
    sku,
    category_name_1 AS category_name,
    price,
    MIN(created_at) OVER (PARTITION BY sku) AS created_at
FROM raw.pakistan_ecommerce_raw
WHERE
    sku IS NOT NULL
    AND TRIM(sku) <> ''
ON CONFLICT (sku) DO NOTHING;
