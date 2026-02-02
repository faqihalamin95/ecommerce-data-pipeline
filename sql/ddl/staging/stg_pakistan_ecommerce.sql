CREATE TABLE IF NOT EXISTS staging.stg_pakistan_ecommerce (
    item_id                 TEXT,
    status                  TEXT,
    created_at              TIMESTAMP,
    sku                     TEXT,
    price                   NUMERIC(14,2),
    qty_ordered             INTEGER,
    grand_total             NUMERIC(14,2),
    increment_id            TEXT,
    category_name_1         TEXT,
    sales_commission_code   TEXT,
    discount_amount         NUMERIC(14,2),
    payment_method          TEXT,

    working_date            DATE,
    bi_status               TEXT,
    mv                      TEXT,
    year                    INTEGER,
    month                   INTEGER,
    customer_since          DATE,
    m_y                     TEXT,
    fy                      TEXT,
    customer_id             TEXT,

    -- Audit columns
    load_timestamp          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_file             TEXT
);
