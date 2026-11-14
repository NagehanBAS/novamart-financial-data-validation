
-- NovaMart Financial Data Validation
-- Task 4: Validate order retention after JOIN operations.
-- Database: SQLite
-- Expected: 6 source rows, 6 target rows, no missing orders.

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
),
missing_orders AS (
    SELECT sh.orders_id
    FROM nova_shipping AS sh
    WHERE NOT EXISTS (
        SELECT 1
        FROM orders_operational AS oo
        WHERE oo.orders_id = sh.orders_id
    )
)
SELECT
    (SELECT COUNT(*) FROM nova_shipping) AS source_row_count,
    (SELECT COUNT(*) FROM orders_operational) AS target_row_count,
    COALESCE(
        (SELECT GROUP_CONCAT(orders_id, ', ')
         FROM missing_orders),
        'None'
    ) AS missing_order_ids;
