CREATE TABLE IF NOT EXISTS mart.dim_customer (
    customer_key       SERIAL PRIMARY KEY,
    customer_id        TEXT NOT NULL UNIQUE,
    customer_since     DATE,
    first_order_date   DATE,
    last_order_date    DATE
);
