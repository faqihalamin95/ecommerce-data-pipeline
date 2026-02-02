-- TRUNCATE AND LOAD staging table for Pakistan e-commerce data
TRUNCATE TABLE staging.stg_pakistan_ecommerce;

-- Load raw Pakistan e-commerce data into staging table
INSERT INTO staging.stg_pakistan_ecommerce (
    item_id,
    status,
    created_at,
    sku,
    price,
    qty_ordered,
    grand_total,
    increment_id,
    category_name_1,
    sales_commission_code,
    discount_amount,
    payment_method,

    working_date,
    bi_status,
    mv,
    year,
    month,
    customer_since,
    m_y,
    fy,
    customer_id
)
SELECT
    item_id,
    status,
    created_at::TIMESTAMP,
    sku,
    price::NUMERIC(14,2),
    qty_ordered::INTEGER,
    grand_total::NUMERIC(14,2),
    increment_id,
    category_name_1,
    sales_commission_code,
    discount_amount::NUMERIC(14,2),
    payment_method,

    working_date::DATE,
    bi_status,
    mv,
    year::INTEGER,
    month::INTEGER,
    customer_since::DATE,
    m_y,
    fy,
    customer_id
FROM raw.pakistan_ecommerce_raw
