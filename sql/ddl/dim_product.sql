CREATE TABLE IF NOT EXISTS mart.dim_product (
    product_key        SERIAL PRIMARY KEY,
    sku                TEXT NOT NULL,
    category_name      TEXT,
    is_active          BOOLEAN DEFAULT TRUE,
    UNIQUE (sku)
);
