-- TRUNCATE AND LOAD mart_sales_daily
TRUNCATE TABLE marts.mart_sales_daily;

-- load aggregated daily sales metrics into mart_sales_daily
INSERT INTO marts.mart_sales_daily (
    sales_date,
    is_weekend,
    total_orders,
    total_customers,
    total_discounts,
    total_revenue,
    total_items_sold,
    average_order_value
)
SELECT
    d.full_date                                   AS sales_date,

    d.is_weekend                                  AS is_weekend,

    COUNT(DISTINCT f.order_id)                    AS total_orders,
    COUNT(DISTINCT f.customer_key)                AS total_customers,

    SUM(f.discount_amount)                        AS total_discounts,

    SUM(f.qty_ordered * f.unit_price)
        - SUM(f.discount_amount)                  AS total_revenue,

    SUM(f.qty_ordered)                            AS total_items_sold,

    CASE
        WHEN COUNT(DISTINCT f.order_id) = 0 THEN 0
        ELSE
            (
                SUM(f.qty_ordered * f.unit_price)
                - SUM(f.discount_amount)
            ) / COUNT(DISTINCT f.order_id)
    END                                           AS average_order_value

FROM foundation.fact_sales f
JOIN foundation.dim_date d
    ON f.date_key = d.date_key

GROUP BY
    d.full_date,
    d.is_weekend

ORDER BY
    d.full_date;
