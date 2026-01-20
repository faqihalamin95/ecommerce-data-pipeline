INSERT INTO mart.dim_product (
    sku,
    category_name
)
SELECT DISTINCT
    sku,
    category_name_1 AS category_name
FROM raw.pakistan_ecommerce_raw
WHERE
    sku IS NOT NULL
    AND TRIM(sku) <> ''
ON CONFLICT (sku) DO NOTHING;
