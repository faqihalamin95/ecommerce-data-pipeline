-- TRUNCATE AND LOAD mart_customer_summary
TRUNCATE TABLE marts.mart_customer_summary;

-- load aggregated customer summary metrics into mart_customer_summary
INSERT INTO marts.mart_customer_summary (
    customer_id,
    total_orders,
    total_items_sold,
    gross_revenue,
    total_discounts,
    net_revenue,
    first_order_date,
    last_order_date,
    average_order_value
)
SELECT
    c.customer_id                                      AS customer_id,

    COUNT(DISTINCT f.order_id)                         AS total_orders,
    SUM(f.qty_ordered)                                 AS total_items_sold,

    SUM(f.qty_ordered * f.unit_price)                  AS gross_revenue,
    SUM(f.discount_amount)                             AS total_discounts,

    SUM(f.qty_ordered * f.unit_price)
        - SUM(f.discount_amount)                       AS net_revenue,

    c.first_order_date                                 AS first_order_date,
    c.last_order_date                                  AS last_order_date,

    CASE
        WHEN COUNT(DISTINCT f.order_id) = 0 THEN 0
        ELSE
            (
                SUM(f.qty_ordered * f.unit_price)
                - SUM(f.discount_amount)
            ) / COUNT(DISTINCT f.order_id)
    END                                                 AS average_order_value

FROM foundation.fact_sales f
JOIN foundation.dim_customer c
    ON f.customer_key = c.customer_key
JOIN foundation.dim_date d
    ON f.date_key = d.date_key

GROUP BY
    c.customer_id,
    c.first_order_date,
    c.last_order_date

ORDER BY
    c.customer_id;
