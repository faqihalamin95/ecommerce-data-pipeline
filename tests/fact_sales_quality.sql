-- 1. No NULL foreign keys (UNKNOWN allowed as -1)

SELECT COUNT(*) AS null_date_key
FROM mart.fact_sales
WHERE date_key IS NULL;

SELECT COUNT(*) AS null_product_key
FROM mart.fact_sales
WHERE product_key IS NULL;

SELECT COUNT(*) AS null_customer_key
FROM mart.fact_sales
WHERE customer_key IS NULL;

-- 2. No invalid measures

SELECT COUNT(*) AS invalid_qty
FROM mart.fact_sales
WHERE qty_ordered <= 0;

SELECT COUNT(*) AS invalid_price
FROM mart.fact_sales
WHERE price < 0;

-- 3. No orphan foreign keys (including UNKNOWN seed)

SELECT COUNT(*) AS orphan_date_key
FROM mart.fact_sales f
LEFT JOIN mart.dim_date d
  ON f.date_key = d.date_key
WHERE d.date_key IS NULL;

SELECT COUNT(*) AS orphan_product_key
FROM mart.fact_sales f
LEFT JOIN mart.dim_product p
  ON f.product_key = p.product_key
WHERE p.product_key IS NULL;

SELECT COUNT(*) AS orphan_customer_key
FROM mart.fact_sales f
LEFT JOIN mart.dim_customer c
  ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;
