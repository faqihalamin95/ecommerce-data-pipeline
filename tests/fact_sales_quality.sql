-- 1. Null foreign keys

SELECT COUNT(*) AS null_date_key
FROM mart.fact_sales
WHERE date_key IS NULL;

SELECT COUNT(*) AS null_product_key
FROM mart.fact_sales
WHERE product_key IS NULL;

SELECT COUNT(*) AS null_customer_key
FROM mart.fact_sales
WHERE customer_key IS NULL;

-- 2. No negative quantities or amounts

SELECT COUNT(*) AS negative_sales
FROM mart.fact_sales
WHERE sales_amount < 0;

-- 3. Orphan foreign keys 

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

