SELECT 'total_rows'            AS check_name, COUNT(*)                         AS count
FROM staging.stg_pakistan_ecommerce

UNION ALL
SELECT 'null_created_at',       COUNT(*)
FROM staging.stg_pakistan_ecommerce
WHERE created_at IS NULL

UNION ALL
SELECT 'null_sku',              COUNT(*)
FROM staging.stg_pakistan_ecommerce
WHERE sku IS NULL

UNION ALL
SELECT 'null_customer_id',      COUNT(*)
FROM staging.stg_pakistan_ecommerce
WHERE customer_id IS NULL

UNION ALL
SELECT 'negative_price',        COUNT(*)
FROM staging.stg_pakistan_ecommerce
WHERE price < 0

UNION ALL
SELECT 'zero_qty',              COUNT(*)
FROM staging.stg_pakistan_ecommerce
WHERE qty_ordered <= 0

UNION ALL
SELECT 'duplicate_rows',        COUNT(*)
FROM (
    SELECT
        created_at,
        sku,
        customer_id,
        price,
        qty_ordered,
        COUNT(*) OVER (
            PARTITION BY
                created_at,
                sku,
                customer_id,
                price,
                qty_ordered
        ) AS cnt
    FROM staging.stg_pakistan_ecommerce
) t
WHERE cnt > 1;
