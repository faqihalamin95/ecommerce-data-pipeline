CREATE TABLE IF NOT EXISTS foundation.fact_sales (
    sales_key        BIGSERIAL PRIMARY KEY,

    date_key         INT NOT NULL,
    product_key      INT NOT NULL,
    customer_key     INT NOT NULL,

    order_id         TEXT NOT NULL,
    item_id          TEXT NOT NULL,

    qty_ordered      INT NOT NULL,
    unit_price       NUMERIC(12,2) NOT NULL,
    discount_amount  NUMERIC(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_fact_date
        FOREIGN KEY (date_key) REFERENCES foundation.dim_date(date_key),

    CONSTRAINT fk_fact_product
        FOREIGN KEY (product_key) REFERENCES foundation.dim_product(product_key),

    CONSTRAINT fk_fact_customer
        FOREIGN KEY (customer_key) REFERENCES foundation.dim_customer(customer_key)
);
