CREATE TABLE IF NOT EXISTS raw.pakistan_ecommerce_raw (
    item_id                  TEXT,
    status                   TEXT,
    created_at               TEXT,
    sku                      TEXT,
    price                    TEXT,
    qty_ordered              TEXT,
    grand_total              TEXT,
    increment_id             TEXT,
    category_name_1          TEXT,
    sales_commission_code    TEXT,
    discount_amount          TEXT,
    payment_method           TEXT,

    working_date             TEXT,
    bi_status                TEXT,
    mv                       TEXT,
    year                     TEXT,
    month                    TEXT,
    customer_since           TEXT,
    m_y                      TEXT,
    fy                       TEXT,
    customer_id              TEXT,

    -- Audit columns
    ingestion_time           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_file              TEXT
);
