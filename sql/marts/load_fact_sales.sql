INSERT INTO mart.fact_sales (
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
    r.increment_id::TEXT         AS order_id,
    r.item_id::TEXT              AS item_id,
    r.qty_ordered,
    r.price,
    r.discount_amount
FROM raw.pakistan_ecommerce_raw r
LEFT JOIN mart.dim_date d
    ON d.full_date = r.created_at::DATE
LEFT JOIN mart.dim_product p
    ON p.sku = r.sku
LEFT JOIN mart.dim_customer c
    ON c.customer_id = r.customer_id::TEXT
   AND c.is_current = TRUE
WHERE
    r.sku IS NOT NULL
    AND r.customer_id IS NOT NULL
    AND r.status = 'complete'
ON CONFLICT (order_id, item_id) DO NOTHING;
