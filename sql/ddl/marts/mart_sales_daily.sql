-- Grain 1 row per sales_date
-- Daily aggregated sales metrics
CREATE TABLE IF NOT EXISTS marts.mart_sales_daily (
    sales_date          DATE UNIQUE NOT NULL,
    is_weekend          BOOLEAN NOT NULL,
    total_orders        INTEGER NOT NULL DEFAULT 0,
    total_customers     INTEGER NOT NULL DEFAULT 0,
    total_discounts     NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_revenue       NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_items_sold    INTEGER NOT NULL DEFAULT 0,
    average_order_value NUMERIC(14,2) NOT NULL DEFAULT 0,

    -- Audit columns
    load_timestamp      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);