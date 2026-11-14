
-- NovaMart Financial Data Validation
-- Task 5: Compare row counts across data transformations.
-- Database: SQLite
--
-- Expected results:
-- Sales -> Sales Margin: 9 -> 9 (preserved)
-- Sales Margin -> Orders: 9 -> 6 (expected aggregation)
-- Orders -> Operational: 6 -> 6 (preserved)
-- Shipping -> Operational: 6 -> 6 (preserved)

WITH sales_margin AS (
    SELECT
        s.date_date,
        s.orders_id,
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
        o.*,
        sh.shipping_fee,
        sh.log_cost,
        sh.ship_cost,
        ROUND(
            o.margin + sh.shipping_fee
            - (sh.log_cost + sh.ship_cost), 2
        ) AS operational_margin
    FROM orders AS o
    LEFT JOIN nova_shipping AS sh
        ON o.orders_id = sh.orders_id
)

SELECT
    '1. Sales -> Sales Margin' AS comparison,
    (SELECT COUNT(*) FROM nova_sales) AS source_rows,
    (SELECT COUNT(*) FROM sales_margin) AS target_rows

UNION ALL

SELECT
    '2. Sales Margin -> Orders',
    (SELECT COUNT(*) FROM sales_margin),
    (SELECT COUNT(*) FROM orders)

UNION ALL

SELECT
    '3. Orders -> Operational',
    (SELECT COUNT(*) FROM orders),
    (SELECT COUNT(*) FROM orders_operational)

UNION ALL

SELECT
    '4. Shipping -> Operational',
    (SELECT COUNT(*) FROM nova_shipping),
    (SELECT COUNT(*) FROM orders_operational);
