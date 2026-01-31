CREATE TABLE IF NOT EXISTS mart.dim_product (
    product_key    SERIAL PRIMARY KEY,
    sku            TEXT NOT NULL UNIQUE,
    category_name  TEXT
);
