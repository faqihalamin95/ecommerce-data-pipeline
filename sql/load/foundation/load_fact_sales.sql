-- TRUNCATE AND LOAD fact_sales fact table
TRUNCATE TABLE foundation.fact_sales;

-- Grain: one row per order item
INSERT INTO foundation.fact_sales (
    date_key,
    product_key,
    customer_key,
    order_id,
    item_id,
    qty_ordered,
    price,
    discount_amount
)
SELECT
    COALESCE(d.date_key, -1)     AS date_key,
    COALESCE(p.product_key, -1)  AS product_key,
    COALESCE(c.customer_key, -1) AS customer_key,
    s.increment_id::TEXT         AS order_id,
    s.item_id::TEXT              AS item_id,
    s.qty_ordered,
    s.price,
    s.discount_amount
FROM staging.stg_pakistan_ecommerce s
LEFT JOIN foundation.dim_date d
    ON d.full_date = s.created_at::DATE
LEFT JOIN foundation.dim_product p
    ON p.sku = s.sku
LEFT JOIN foundation.dim_customer c
    ON c.customer_id = s.customer_id::TEXT
WHERE
    s.status = 'complete'
    AND s.qty_ordered > 0
    AND s.price >= 0;
