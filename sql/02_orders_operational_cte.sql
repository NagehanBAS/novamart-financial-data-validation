
-- NovaMart Financial Data Validation
-- Task 2: Build an order-level operational dataset using CTEs.
-- Database: SQLite

WITH sales_margin AS (
    SELECT
        s.date_date,
        s.orders_id,
        s.products_id,
        s.qty,
        s.turnover,
        s.qty * p.purchase_price AS purchase_cost,
        s.turnover - (s.qty * p.purchase_price) AS margin
    FROM nova_sales AS s
    LEFT JOIN nova_product AS p
        ON s.products_id = p.products_id
),

orders AS (
    SELECT
        date_date,
        orders_id,
        SUM(qty) AS qty,
        ROUND(SUM(turnover), 2) AS turnover,
        ROUND(SUM(purchase_cost), 2) AS purchase_cost,
        ROUND(SUM(margin), 2) AS margin
    FROM sales_margin
    GROUP BY date_date, orders_id
),

orders_operational AS (
    SELECT
        o.date_date,
        o.orders_id,
        o.qty,
        o.turnover,
        o.purchase_cost,
        o.margin,
        sh.shipping_fee,
        sh.log_cost,
        sh.ship_cost,
        ROUND(
            o.margin + sh.shipping_fee - (sh.log_cost + sh.ship_cost),
            2
        ) AS operational_margin
    FROM orders AS o
    LEFT JOIN nova_shipping AS sh
        ON o.orders_id = sh.orders_id
)

SELECT *
FROM orders_operational
ORDER BY date_date, orders_id;
