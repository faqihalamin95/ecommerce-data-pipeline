-- Grain 1 row per product(sku)
-- Aggregated product performance metrics
CREATE TABLE IF NOT EXISTS mart.mart_product_performance (
    sku                  TEXT UNIQUE NOT NULL,
    category_name        TEXT,
    total_orders         INTEGER NOT NULL DEFAULT 0,
    total_items_sold     INTEGER NOT NULL DEFAULT 0,
    gross_revenue        NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_discounts      NUMERIC(14,2) NOT NULL DEFAULT 0,
    net_revenue          NUMERIC(14,2) NOT NULL DEFAULT 0,
    average_price        NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_customers      INTEGER NOT NULL DEFAULT 0,

    -- Audit columns
    load_timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);