CREATE TABLE IF NOT EXISTS mart.dim_product (
    product_key        SERIAL PRIMARY KEY,
    sku                TEXT NOT NULL,
    category_name      TEXT,
    price              NUMERIC(10,2),
    is_active          BOOLEAN DEFAULT TRUE,
    created_at         TIMESTAMP,
    UNIQUE (sku)
);
