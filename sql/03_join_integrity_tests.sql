
-- NovaMart Financial Data Validation
-- Task 3: Duplicate and missing-match validation
-- Database: SQLite
-- Both tests should return zero rows.

-- Test 1: Detect duplicate order IDs in the operational result.

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
    orders_id,
    COUNT(*) AS duplicate_count
FROM orders_operational
GROUP BY orders_id
HAVING COUNT(*) > 1;

-- Test 2: Identify shipping orders missing from the operational result.

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
    sh.orders_id
FROM nova_shipping AS sh
LEFT JOIN orders_operational AS oo
    ON sh.orders_id = oo.orders_id
WHERE oo.orders_id IS NULL;
