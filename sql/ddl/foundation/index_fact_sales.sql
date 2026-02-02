-- Filter by date 
CREATE INDEX IF NOT EXISTS idx_fact_sales_date
ON foundation.fact_sales(date_key);

-- Join product
CREATE INDEX IF NOT EXISTS idx_fact_sales_product
ON foundation.fact_sales(product_key);

-- Join customer
CREATE INDEX IF NOT EXISTS idx_fact_sales_customer
ON foundation.fact_sales(customer_key);