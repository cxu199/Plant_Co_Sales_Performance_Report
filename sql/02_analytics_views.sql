-- 02_analytics_views.sql
-- Purpose: reusable analytics views for BI tools or SQL analysis

CREATE OR REPLACE VIEW vw_sales_monthly AS
SELECT
    d.year,
    d.quarter_label,
    d.month_num,
    d.year_month,
    SUM(f.sales_usd)            AS sales_usd,
    SUM(f.cogs_usd)             AS cogs_usd,
    SUM(f.gross_profit_usd)     AS gross_profit_usd,
    CASE
        WHEN SUM(f.sales_usd) = 0 THEN NULL
        ELSE SUM(f.gross_profit_usd) / SUM(f.sales_usd)
    END                         AS gross_margin_pct
FROM fact_sales f
JOIN dim_date d
  ON f.date_key = d.date_key
GROUP BY 1,2,3,4;

CREATE OR REPLACE VIEW vw_sales_by_country AS
SELECT
    a.country,
    SUM(f.sales_usd)            AS sales_usd,
    SUM(f.gross_profit_usd)     AS gross_profit_usd,
    CASE
        WHEN SUM(f.sales_usd) = 0 THEN NULL
        ELSE SUM(f.gross_profit_usd) / SUM(f.sales_usd)
    END                         AS gross_margin_pct
FROM fact_sales f
JOIN dim_account a
  ON f.account_id = a.account_id
GROUP BY 1;

CREATE OR REPLACE VIEW vw_sales_by_product_type AS
SELECT
    p.product_type,
    SUM(f.sales_usd)            AS sales_usd,
    SUM(f.gross_profit_usd)     AS gross_profit_usd,
    CASE
        WHEN SUM(f.sales_usd) = 0 THEN NULL
        ELSE SUM(f.gross_profit_usd) / SUM(f.sales_usd)
    END                         AS gross_margin_pct
FROM fact_sales f
JOIN dim_product p
  ON f.product_id = p.product_id
GROUP BY 1;

CREATE OR REPLACE VIEW vw_account_profitability AS
SELECT
    a.account_id,
    a.account,
    a.country,
    SUM(f.sales_usd)            AS sales_usd,
    SUM(f.quantity)             AS quantity,
    SUM(f.gross_profit_usd)     AS gross_profit_usd,
    CASE
        WHEN SUM(f.sales_usd) = 0 THEN NULL
        ELSE SUM(f.gross_profit_usd) / SUM(f.sales_usd)
    END                         AS gross_margin_pct
FROM fact_sales f
JOIN dim_account a
  ON f.account_id = a.account_id
GROUP BY 1,2,3;

-- Comparable YTD versus prior-year YTD
CREATE OR REPLACE VIEW vw_ytd_vs_pytd AS
WITH max_fact_date AS (
    SELECT MAX(date_key) AS max_date
    FROM fact_sales
),
current_ytd AS (
    SELECT
        SUM(sales_usd)        AS sales_ytd,
        SUM(gross_profit_usd) AS profit_ytd
    FROM fact_sales, max_fact_date
    WHERE date_key >= DATE_TRUNC('year', max_date)
      AND date_key <= max_date
),
prior_ytd AS (
    SELECT
        SUM(sales_usd)        AS sales_pytd,
        SUM(gross_profit_usd) AS profit_pytd
    FROM fact_sales, max_fact_date
    WHERE date_key >= DATE_TRUNC('year', max_date - INTERVAL '1 year')
      AND date_key <= (max_date - INTERVAL '1 year')
)
SELECT
    c.sales_ytd,
    p.sales_pytd,
    c.sales_ytd - p.sales_pytd                                  AS sales_variance,
    CASE WHEN p.sales_pytd = 0 THEN NULL
         ELSE (c.sales_ytd - p.sales_pytd) / p.sales_pytd END   AS sales_variance_pct,
    c.profit_ytd,
    p.profit_pytd,
    c.profit_ytd - p.profit_pytd                                AS profit_variance,
    CASE WHEN p.profit_pytd = 0 THEN NULL
         ELSE (c.profit_ytd - p.profit_pytd) / p.profit_pytd END AS profit_variance_pct
FROM current_ytd c
CROSS JOIN prior_ytd p;
