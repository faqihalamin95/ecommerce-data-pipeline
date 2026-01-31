-- Grain 1 row per customer(customer_id)
-- Aggregated customer summary metrics
CREATE TABLE IF NOT EXISTS mart.mart_customer_summary (
    customer_id         TEXT UNIQUE NOT NULL,
    total_orders        INTEGER NOT NULL DEFAULT 0,
    total_items_sold    INTEGER NOT NULL DEFAULT 0,
    gross_revenue       NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_discounts     NUMERIC(14,2) NOT NULL DEFAULT 0,
    net_revenue         NUMERIC(14,2) NOT NULL DEFAULT 0,
    first_order_date    DATE NOT NULL,
    last_order_date     DATE NOT NULL,
    average_order_value NUMERIC(14,2) NOT NULL DEFAULT 0,

    -- Audit columns
    load_timestamp      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);