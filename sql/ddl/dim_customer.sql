CREATE TABLE IF NOT EXISTS mart.dim_customer (
    customer_key            SERIAL PRIMARY KEY,
    customer_id             TEXT NOT NULL,
    customer_since          DATE,
    first_order_date        DATE,
    last_order_date         DATE,
    effective_start_date    DATE NOT NULL,
    effective_end_date      DATE,
    is_current              BOOLEAN NOT NULL,
    UNIQUE (customer_id, effective_start_date)
);
