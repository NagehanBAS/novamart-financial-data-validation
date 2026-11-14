
-- NovaMart Financial Data Validation
-- Task 1: Create and populate the three source tables.
-- Database: SQLite

DROP TABLE IF EXISTS nova_shipping;
DROP TABLE IF EXISTS nova_sales;
DROP TABLE IF EXISTS nova_product;

CREATE TABLE nova_product (
    products_id INTEGER,
    purchase_price FLOAT
);

INSERT INTO nova_product (products_id, purchase_price)
VALUES
    (101, 12.50),
    (102, 20.00),
    (103, 7.75),
    (104, 15.00),
    (105, 30.00);

CREATE TABLE nova_sales (
    date_date DATE,
    orders_id INTEGER,
    products_id INTEGER,
    turnover FLOAT,
    qty INTEGER
);

INSERT INTO nova_sales (date_date, orders_id, products_id, turnover, qty)
VALUES
    ('2024-01-10', 5001, 101, 40.00, 2),
    ('2024-01-10', 5001, 103, 23.25, 3),
    ('2024-01-10', 5002, 102, 60.00, 2),
    ('2024-01-11', 5003, 104, 45.00, 3),
    ('2024-01-11', 5003, 101, 20.00, 1),
    ('2024-01-11', 5004, 105, 90.00, 3),
    ('2024-01-12', 5005, 103, 31.00, 4),
    ('2024-01-12', 5005, 104, 30.00, 2),
    ('2024-01-12', 5006, 102, 40.00, 1);

CREATE TABLE nova_shipping (
    orders_id INTEGER,
    shipping_fee FLOAT,
    log_cost FLOAT,
    ship_cost FLOAT
);

INSERT INTO nova_shipping (orders_id, shipping_fee, log_cost, ship_cost)
VALUES
    (5001, 8.00, 2.50, 3.00),
    (5002, 6.00, 2.00, 2.50),
    (5003, 7.50, 2.50, 3.50),
    (5004, 9.00, 3.00, 4.00),
    (5005, 6.50, 2.00, 3.00),
    (5006, 5.00, 1.50, 2.00);

-- Verify the number of records in each source table.
SELECT 'nova_product' AS table_name, COUNT(*) AS row_count
FROM nova_product
UNION ALL
SELECT 'nova_sales', COUNT(*) FROM nova_sales
UNION ALL
SELECT 'nova_shipping', COUNT(*) FROM nova_shipping;
