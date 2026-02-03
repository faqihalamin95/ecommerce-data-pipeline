-- FOUNDATION QUALITY GATE
-- Mode   : FAIL HARD (enforced by Python)

-- 1. No NULL foreign keys (UNKNOWN = -1 is allowed)

SELECT 'null_date_key' AS check_name, COUNT(*) AS count
FROM foundation.fact_sales
WHERE date_key IS NULL

UNION ALL
SELECT 'null_product_key', COUNT(*)
FROM foundation.fact_sales
WHERE product_key IS NULL

UNION ALL
SELECT 'null_customer_key', COUNT(*)
FROM foundation.fact_sales
WHERE customer_key IS NULL


-- 2. No invalid measures

UNION ALL
SELECT 'invalid_qty', COUNT(*)
FROM foundation.fact_sales
WHERE qty_ordered <= 0

UNION ALL
SELECT 'invalid_price', COUNT(*)
FROM foundation.fact_sales
WHERE price < 0

UNION ALL
SELECT 'invalid_discount', COUNT(*)
FROM foundation.fact_sales
WHERE discount_amount < 0
   OR discount_amount > (qty_ordered * price)


-- 3. No orphan foreign keys (including UNKNOWN seed)

UNION ALL
SELECT 'orphan_date_key', COUNT(*)
FROM foundation.fact_sales f
LEFT JOIN foundation.dim_date d
  ON f.date_key = d.date_key
WHERE d.date_key IS NULL

UNION ALL
SELECT 'orphan_product_key', COUNT(*)
FROM foundation.fact_sales f
LEFT JOIN foundation.dim_product p
  ON f.product_key = p.product_key
WHERE p.product_key IS NULL

UNION ALL
SELECT 'orphan_customer_key', COUNT(*)
FROM foundation.fact_sales f
LEFT JOIN foundation.dim_customer c
  ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;
