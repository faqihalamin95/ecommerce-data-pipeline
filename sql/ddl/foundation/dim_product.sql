CREATE TABLE IF NOT EXISTS foundation.dim_product (
    product_key    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku            TEXT NOT NULL UNIQUE,
    category_name  TEXT
);
