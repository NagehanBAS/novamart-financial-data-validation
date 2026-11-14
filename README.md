# NovaMart | Financial Data Validation

### SQL Data Quality, JOIN Integrity & Retention Testing

A SQL-based data validation project focused on ensuring the reliability of e-commerce financial reporting.

Built with **SQLite**, this project uses Common Table Expressions (CTEs), relational JOINs, and validation queries to detect duplicate orders, missing records, and unexpected changes in row counts.

## Project Overview

Reliable financial reporting requires more than accurate calculations. Data transformations must also preserve records, maintain the intended level of detail, and prevent unintended duplication.

This project reconstructs an order-level operational financial dataset and validates the integrity of its underlying transformations.

**Key business questions:**

- Are all sales records preserved after joining product data?
- Does each order appear exactly once in the operational output?
- Are any shipping orders missing from the final dataset?
- Are source records preserved throughout the transformation process?
- Can changes in row counts be explained by legitimate aggregation rather than data loss?

## Technology Stack

- **SQLite** — Relational database
- **SQL** — Data preparation, transformation, and validation
- **Common Table Expressions (CTEs)** — Modular query development
- **LEFT JOIN** — Relational data integration
- **GROUP BY and aggregate functions** — Order-level aggregation
- **NOT EXISTS** — Missing-record detection
- **GitHub** — Version control and project documentation

## Dataset Overview

The project uses three educational source tables.

| Table | Description | Records |
|---|---|---:|
| `nova_product` | Product acquisition prices | 5 |
| `nova_sales` | Product-level sales transactions | 9 |
| `nova_shipping` | Order-level shipping and logistics expenses | 6 |

**Reporting period:** January 10–12, 2024

The repository includes SQL statements to recreate the source tables and insert the sample records.

## Financial Data Model

The analytical workflow transforms product-level sales records into order-level operational financial data.

**Source tables:**

- `nova_sales` contains order IDs, product IDs, dates, quantities, and turnover.
- `nova_product` contains product purchase prices.
- `nova_shipping` contains shipping fees, logistics costs, and shipping costs.

**Transformation process:**

`nova_sales` + `nova_product` → `sales_margin`

`sales_margin` → `orders`

`orders` + `nova_shipping` → `orders_operational`

All three analytical stages are implemented using CTEs rather than permanent output tables.

## Financial Calculations

The project reconstructs the financial calculations used in the preceding analytical workflow.

**Purchase Cost**

`purchase_cost = qty * purchase_price`

**Gross Margin**

`margin = turnover - purchase_cost`

**Operational Margin**

`operational_margin = margin + shipping_fee - log_cost - ship_cost`

The final `orders_operational` result contains:

- `date_date`
- `orders_id`
- `qty`
- `turnover`
- `purchase_cost`
- `margin`
- `shipping_fee`
- `log_cost`
- `ship_cost`
- `operational_margin`

The validated output contains **6 order-level records**.

## Validation Framework

### 1. Duplicate Order Detection

**Objective:** Verify that each order appears exactly once in the final operational dataset.

**Method:** Group records by `orders_id` and identify counts greater than one.

**Expected result:** Zero rows.

**Actual result:** Passed — no duplicate order IDs detected.

### 2. Missing Order Detection

**Objective:** Verify that all shipping order IDs are represented in the operational output.

**Method:** Compare `nova_shipping` against `orders_operational` using a LEFT JOIN and a NULL check.

**Expected result:** Zero rows.

**Actual result:** Passed — no missing shipping orders detected.

### 3. Order Retention Testing

**Objective:** Confirm that the operational transformation preserves the expected number of order records.

| Validation Metric | Result |
|---|---:|
| Source Shipping Records | 6 |
| Operational Output Records | 6 |
| Missing Order IDs | None |

**Result:** Passed — all 6 source shipping orders were represented in the final output.

### 4. Source-to-Target Row Count Validation

**Objective:** Identify unexpected row loss or duplication across the transformation pipeline.

| Transformation | Source Rows | Target Rows | Interpretation |
|---|---:|---:|---|
| Sales → Sales Margin | 9 | 9 | Records preserved |
| Sales Margin → Orders | 9 | 6 | Expected aggregation |
| Orders → Operational | 6 | 6 | Records preserved |
| Shipping → Operational | 6 | 6 | Record counts match |

**Result:** All comparisons matched the expected transformation behavior.

The reduction from 9 sales rows to 6 order rows was intentional because multiple product transactions belonging to the same order were aggregated.

## Key Findings

### Finding 1 — Sales Records Were Preserved

The product LEFT JOIN retained all 9 sales rows, demonstrating that the transformation did not unexpectedly reduce transaction-level record counts.

### Finding 2 — Order Aggregation Was Consistent

The dataset contained 9 product-level sales records associated with 6 unique orders.

Aggregating transactions at the order level reduced the number of rows as intended.

### Finding 3 — No Duplicate Orders Were Detected

The duplicate validation query returned zero rows, confirming that the tested operational output contained one record per order.

### Finding 4 — All Shipping Orders Were Matched

Every order ID present in the shipping dataset was represented in the final operational result.

The missing-record test returned zero rows.

### Finding 5 — Retention Controls Supported Reporting Reliability

Both source-to-target row count comparisons and order ID matching checks passed.

Together, these results provide evidence that the tested transformations preserved the expected records without introducing duplicate orders.

These checks validate the specified data integrity conditions; they do not constitute a comprehensive financial audit.

## Business Implications

The validation framework supports more reliable financial reporting by helping analysts:

- Identify unintended record loss during JOIN operations
- Detect duplicate orders before KPI aggregation
- Validate shipping and operational data coverage
- Distinguish expected aggregation from data integrity problems
- Build greater confidence in downstream financial reporting

These controls are especially relevant to commercial analytics, financial reporting, and operational performance monitoring.

## Repository Structure

```text
novamart-financial-data-validation/
├── README.md
└── sql/
    ├── 01_database_setup.sql
    ├── 02_orders_operational_cte.sql
    ├── 03_join_integrity_tests.sql
    ├── 04_order_retention_test.sql
    └── 05_row_count_validation.sql
```

## SQL Scripts

| File | Description |
|---|---|
| `01_database_setup.sql` | Creates and populates the three source tables |
| `02_orders_operational_cte.sql` | Reconstructs the operational financial dataset |
| `03_join_integrity_tests.sql` | Tests duplicate orders and missing matches |
| `04_order_retention_test.sql` | Compares source and target order counts |
| `05_row_count_validation.sql` | Analyzes row counts across transformations |

## How to Run

1. Open a SQLite-compatible SQL environment, such as SQLite Online.
2. Run `01_database_setup.sql` to create and populate the source tables.
3. Execute `02_orders_operational_cte.sql` to generate the order-level result.
4. Run `03_join_integrity_tests.sql` to check duplicates and missing matches.
5. Execute `04_order_retention_test.sql` to validate order preservation.
6. Run `05_row_count_validation.sql` to compare row counts across transformation stages.

**Note:** The analytical dataset is defined within CTEs, so each validation script independently reconstructs the required intermediate results.

The database setup script drops and recreates the three NovaMart source tables. Run it in a suitable test environment rather than a production database.

## Skills Demonstrated

- SQL data quality testing
- Common Table Expressions (CTEs)
- Relational JOIN integrity
- Duplicate record detection
- Missing-record identification
- Source-to-target reconciliation
- Data retention validation
- Aggregation-level analysis
- Financial data modeling
- Business-oriented SQL documentation

## Potential Extensions

Future enhancements could include automated assertion-based SQL tests, monetary reconciliation checks, additional referential integrity checks, and a repeatable data quality scorecard.

## Project Context

This project was completed as part of a practical SQL and data analytics training program and documented as a financial data validation portfolio case study.

It demonstrates how SQL can be used not only to calculate business metrics, but also to evaluate the integrity and reliability of the data transformations supporting those metrics.

---

**Tools:** SQLite · SQL · GitHub

**Focus Areas:** Data Quality · Financial Analytics · JOIN Validation · Data Integrity · Retention Testing

## Author

**Nagehan Bas**
