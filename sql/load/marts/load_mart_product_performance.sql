-- TRUNCATE AND LOAD mart_product_performance
TRUNCATE TABLE marts.mart_product_performance;

-- load aggregated product performance metrics into mart_product_performance
INSERT INTO marts.mart_product_performance (
    sku,
    category_name,
    total_orders,
    total_items_sold,
    gross_revenue,
    total_discounts,
    net_revenue,
    average_price,
    total_customers
)
SELECT
    p.sku                                           AS sku,
    p.category_name                                 AS category_name,

    COUNT(DISTINCT f.order_id)                      AS total_orders,
    SUM(f.qty_ordered)                              AS total_items_sold,

    SUM(f.qty_ordered * f.unit_price)               AS gross_revenue,
    SUM(f.discount_amount)                          AS total_discounts,

    SUM(f.qty_ordered * f.unit_price)
        - SUM(f.discount_amount)                    AS net_revenue,

    CASE
        WHEN SUM(f.qty_ordered) = 0 THEN 0
        ELSE
            SUM(f.qty_ordered * f.unit_price)
            / SUM(f.qty_ordered)
    END                                             AS average_price,

    COUNT(DISTINCT f.customer_key)                  AS total_customers

FROM foundation.fact_sales f
JOIN foundation.dim_product p
    ON f.product_key = p.product_key

GROUP BY
    p.sku,
    p.category_name;
