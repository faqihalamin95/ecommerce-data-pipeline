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
    qty_ordered::NUMERIC::INTEGER,
    grand_total::NUMERIC(14,2),
    increment_id,
    category_name_1,
    sales_commission_code,
    discount_amount::NUMERIC(14,2),
    payment_method,

    -- data cleansing for working_date field
    CASE
        -- format: YYYY-M or YYYY-MM → normalize to first day of month
        WHEN working_date::TEXT ~ '^\d{4}-\d{1,2}$'
            THEN TO_DATE(working_date::TEXT || '-01', 'YYYY-MM-DD')

        -- format: M/D/YYYY or MM/DD/YYYY → convert to date
        WHEN working_date::TEXT ~ '^\d{1,2}/\d{1,2}/\d{4}$'
            THEN TO_DATE(working_date::TEXT, 'MM/DD/YYYY')

        ELSE NULL
    END AS working_date,
    
    bi_status,
    mv,
    year::NUMERIC::INTEGER,
    month::NUMERIC::INTEGER,

    -- data cleansing for working_date field
    CASE
        -- format: YYYY-M or YYYY-MM → normalize to first day of month
        WHEN customer_since::TEXT ~ '^\d{4}-\d{1,2}$'
            THEN TO_DATE(customer_since::TEXT || '-01', 'YYYY-MM-DD')

        -- format: M/D/YYYY or MM/DD/YYYY → convert to date
        WHEN customer_since::TEXT ~ '^\d{1,2}/\d{1,2}/\d{4}$'
            THEN TO_DATE(customer_since::TEXT, 'MM/DD/YYYY')

        ELSE NULL
    END AS customer_since,

    m_y,
    fy,
    customer_id
FROM raw.pakistan_ecommerce_raw

-- Filter out blank rows based on created_at
WHERE created_at IS NOT NULL;
