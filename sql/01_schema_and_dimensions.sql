-- 01_schema_and_dimensions.sql
-- Purpose: build a clean star schema for the Plant Co sales model
-- Note: syntax is written in portable SQL with common warehouse-style functions.
-- Adjust DATE / EXTRACT / GENERATE_SERIES logic to your SQL engine as needed.

-- =========================
-- 1) STAGING CLEANUP VIEWS
-- =========================

-- Fact staging
CREATE OR REPLACE VIEW stg_plant_fact AS
SELECT
    CAST(product_id AS INTEGER)              AS product_id,
    CAST(sales_usd AS NUMERIC(18,2))         AS sales_usd,
    CAST(quantity AS NUMERIC(18,2))          AS quantity,
    CAST(price_usd AS NUMERIC(18,4))         AS price_usd,
    CAST(cogs_usd AS NUMERIC(18,2))          AS cogs_usd,
    CAST(date_time AS DATE)                  AS order_date,
    TRIM(account_id)                         AS account_id
FROM raw_plant_fact
WHERE product_id IS NOT NULL
  AND account_id IS NOT NULL;

-- Account staging
CREATE OR REPLACE VIEW stg_accounts AS
SELECT DISTINCT
    TRIM(account_id)                         AS account_id,
    CAST(master_id AS INTEGER)               AS master_id,
    account,
    country_code,
    country2                                 AS country,
    CAST(latitude2 AS NUMERIC(18,6))         AS latitude,
    CAST(longitude AS NUMERIC(18,6))         AS longitude,
    CAST(postal_code AS VARCHAR(50))         AS postal_code,
    street_name,
    CAST(street_number AS VARCHAR(50))       AS street_number
FROM raw_accounts
WHERE account_id IS NOT NULL;

-- Product staging
CREATE OR REPLACE VIEW stg_products AS
SELECT DISTINCT
    CAST(product_name_id AS INTEGER)         AS product_id,
    product_name,
    product_group,
    CAST(product_group_id AS INTEGER)        AS product_group_id,
    product_family,
    CAST(product_family_id AS INTEGER)       AS product_family_id,
    product_size,
    produt_type                              AS product_type
FROM raw_plant_hierarchy;

-- =========================
-- 2) DIMENSIONS
-- =========================

CREATE OR REPLACE TABLE dim_product AS
SELECT DISTINCT
    product_id,
    product_name,
    product_group,
    product_group_id,
    product_family,
    product_family_id,
    product_size,
    product_type
FROM stg_products;

CREATE OR REPLACE TABLE dim_account AS
SELECT DISTINCT
    account_id,
    master_id,
    account,
    country_code,
    country,
    latitude,
    longitude,
    postal_code,
    street_name,
    street_number
FROM stg_accounts;

-- Example date dimension built from fact range
CREATE OR REPLACE TABLE dim_date AS
WITH bounds AS (
    SELECT MIN(order_date) AS min_date, MAX(order_date) AS max_date
    FROM stg_plant_fact
),
date_spine AS (
    SELECT d::date AS date_day
    FROM bounds,
         GENERATE_SERIES(min_date, max_date, INTERVAL '1 day') AS d
)
SELECT
    date_day                                     AS date_key,
    EXTRACT(YEAR FROM date_day)                  AS year,
    EXTRACT(QUARTER FROM date_day)               AS quarter_num,
    CONCAT('Q', EXTRACT(QUARTER FROM date_day))  AS quarter_label,
    EXTRACT(MONTH FROM date_day)                 AS month_num,
    TO_CHAR(date_day, 'Mon')                     AS month_short,
    TO_CHAR(date_day, 'YYYY-MM')                 AS year_month,
    EXTRACT(DAY FROM date_day)                   AS day_of_month,
    EXTRACT(ISODOW FROM date_day)                AS iso_day_of_week,
    CASE WHEN EXTRACT(ISODOW FROM date_day) IN (6,7) THEN 1 ELSE 0 END AS is_weekend
FROM date_spine;

-- =========================
-- 3) FACT TABLE
-- =========================

CREATE OR REPLACE TABLE fact_sales AS
SELECT
    ROW_NUMBER() OVER (ORDER BY f.order_date, f.account_id, f.product_id) AS sales_key,
    f.order_date                                                          AS date_key,
    f.account_id,
    f.product_id,
    f.quantity,
    f.price_usd,
    f.sales_usd,
    f.cogs_usd,
    (f.sales_usd - f.cogs_usd)                                            AS gross_profit_usd,
    CASE
        WHEN f.sales_usd = 0 THEN NULL
        ELSE (f.sales_usd - f.cogs_usd) / f.sales_usd
    END                                                                   AS gross_margin_pct
FROM stg_plant_fact f;
