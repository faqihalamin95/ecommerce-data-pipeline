-- Seed unknown product record for referential integrity
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

-- Load distinct products from raw transactions
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

-- Flag products as active if sold in the last 90 days
UPDATE mart.dim_product p 
SET is_active = TRUE
FROM (
    SELECT DISTINCT product_key
    FROM mart.fact_orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '90 days' 
) active_products
WHERE p.product_key = active_products.product_key;

-- Flag remaining products as inactive (excluding unknown)
UPDATE mart.dim_product
SET is_active = FALSE 
WHERE product_key NOT IN (
    SELECT DISTINCT product_key
    FROM mart.fact_orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'
)
AND product_key <> -1;
