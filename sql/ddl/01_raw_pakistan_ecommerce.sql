CREATE TABLE IF NOT EXISTS raw.pakistan_ecommerce_raw (
    item_id                  VARCHAR,
    status                   VARCHAR,
    created_at               TIMESTAMP,
    sku                      VARCHAR,
    price                    NUMERIC(14,2),
    qty_ordered              INTEGER,
    grand_total              NUMERIC(14,2),
    increment_id             VARCHAR,
    category_name_1          VARCHAR,
    sales_commission_code    VARCHAR,
    discount_amount          NUMERIC(14,2),
    payment_method           VARCHAR,

    working_date             DATE,
    bi_status                VARCHAR,
    mv                       VARCHAR,
    year                     INTEGER,
    month                    INTEGER,
    customer_since           DATE,
    m_y                      VARCHAR,
    fy                       VARCHAR,
    customer_id              VARCHAR,

    -- audit columns
    ingestion_time           TIMESTAMP,
    source_file              VARCHAR
);
