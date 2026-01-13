CREATE TABLE IF NOT EXISTS mart.fact_sales (
    sales_key      BIGSERIAL PRIMARY KEY,

    date_key       INT NOT NULL,
    product_key    INT NOT NULL,
    customer_key   INT NOT NULL,

    order_id       TEXT,
    item_id        TEXT,

    qty_ordered    INT,
    price          NUMERIC(12,2),
    discount_amount NUMERIC(12,2),
    grand_total    NUMERIC(12,2),

    CONSTRAINT fk_date
        FOREIGN KEY (date_key) REFERENCES mart.dim_date(date_key),

    CONSTRAINT fk_product
        FOREIGN KEY (product_key) REFERENCES mart.dim_product(product_key),

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_key) REFERENCES mart.dim_customer(customer_key)
);
