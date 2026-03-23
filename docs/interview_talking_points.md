# Interview talking points

## 1) How to introduce the project
I built this as an end-to-end analytics project using Python, SQL, and Power BI.  
The goal was to avoid a dashboard-only portfolio piece and instead show the full workflow from raw source data through semantic modeling to executive reporting.

## 2) Data engineering / modeling angle
The raw source came as an Excel workbook with a fact sheet, an accounts table, and a product hierarchy table.  
I profiled the data first, identified that the accounts sheet contained extra rows with missing account IDs, then filtered those out before building a clean dimensional model.

## 3) Why star schema
I modeled the data into:
- fact_sales
- dim_product
- dim_account
- dim_date

This structure makes DAX simpler, improves model performance, and is the standard design pattern for scalable BI reporting.

## 4) What business problem the dashboard solves
The report helps leadership understand:
- current YTD sales performance
- comparable YTD versus prior year
- country contribution
- account profitability
- product type mix
- margin health

## 5) Examples of insights from the actual dataset
- 2024 YTD sales are slightly behind comparable prior-year YTD
- China is the largest market by revenue
- Outdoor is the largest product type
- Gross margin is relatively stable at around 39–40%

## 6) How Python adds value
I used Python for:
- column standardization
- type enforcement
- invalid dimension-row removal
- quality checks
- exporting clean analytical datasets

That demonstrates I can do more than drag-and-drop BI; I can prepare data programmatically when needed.

## 7) How SQL adds value
I used SQL to:
- separate staging from dimensions and facts
- calculate gross profit and margin in the warehouse layer
- create reusable analytics views for time, geography, and customer analysis

This shows strong data modeling fundamentals and makes the BI layer cleaner.

## 8) How to describe dashboard improvements
If I were taking this into production, I would:
- split the dashboard into multiple pages by audience
- add drillthrough and tooltips
- include dynamic commentary cards
- add map analysis and variance decomposition
- validate the semantic model with row-level business definitions

## 9) Strong closing line
This project shows that I can own the analytics lifecycle end to end: data cleaning, dimensional modeling, metric design, dashboard development, and stakeholder-ready storytelling.
