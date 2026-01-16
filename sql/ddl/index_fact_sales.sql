-- Filter by date 
CREATE INDEX IF NOT EXISTS idx_fact_sales_date
ON mart.fact_sales(date_key);

-- Join product
CREATE INDEX IF NOT EXISTS idx_fact_sales_product
ON mart.fact_sales(product_key);

-- Join customer
CREATE INDEX IF NOT EXISTS idx_fact_sales_customer
ON mart.fact_sales(customer_key);
