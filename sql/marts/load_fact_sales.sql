INSERT INTO mart.fact_sales (
    date_key,
    product_key,
    customer_key,
    order_id,
    item_id,
    qty_ordered,
    price,
    discount_amount,
    grand_total
)
SELECT
    d.date_key,
    p.product_key,
    c.customer_key,
    r.increment_id::TEXT AS order_id,
    r.item_id::TEXT AS item_id,
    r.qty_ordered,
    r.price,
    r.discount_amount,
    r.grand_total
FROM raw.pakistan_ecommerce_raw r
JOIN mart.dim_date d
    ON d.full_date = r.created_at::DATE
JOIN mart.dim_product p
    ON p.sku = r.sku
JOIN mart.dim_customer c
    ON c.customer_id = r.customer_id::TEXT
   AND c.is_current = TRUE
WHERE r.sku IS NOT NULL
  AND r.customer_id IS NOT NULL
ON CONFLICT DO NOTHING;
