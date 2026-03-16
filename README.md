# Plant Co. Sales Performance Report
Interactive Power BI dashboard analyzing Plant Co sales using YTD vs PYTD time intelligence. Includes dynamic KPI switching (sales, gross profit, and quantity), waterfall growth analysis, product and country performance monitoring, and customer segmentation using scatter plot quadrant analysis.


# Project Highlights

* **Interactive Power BI dashboard** analyzing Plant Co sales performance across countries, products, and customer accounts.
* Implements **dynamic measure switching** to analyze Sales, Gross Profit, and Quantity using the same visuals.
* Uses **advanced time-intelligence calculations (YTD vs PYTD)** to track business performance against the previous year.
* Includes **waterfall analysis with hierarchical drill-down** to identify drivers of growth or decline by month, country, product type, and product.
* Applies **customer profitability segmentation** using a scatter plot with quadrant analysis to identify high-value and growth opportunity accounts.
* Built on a **SQL star schema data model** with Fact_Sales and dimension tables for Date, Product, and Accounts.
* Demonstrates key analytics skills including **Power Query data preparation, DAX calculations, business KPI design, and interactive dashboard development.**


# Dashboard Screenshots & Visual Explanation

The following visuals demonstrate how the dashboard answers key business questions related to revenue growth, profitability, and market performance.

---

## Full Dashboard Overview

![Plant Co Dashboard](https://github.com/user-attachments/assets/faa960ec-9be6-403b-a3a5-5a36cf437ab7)

This interactive Power BI dashboard provides a comprehensive view of Plant Co’s sales performance using **YTD vs PYTD analysis**, dynamic metric switching, and multi-dimensional drill-down capabilities.

---

## KPI Performance Overview

![image alt](https://github.com/cxu199/PlantCo_Sales_Performance_Report/blob/9c5ecfd4efad46b785d00f1be92853514fa75be7/KPI%20Cards.PNG)

**Purpose**

The dashboard begins with KPI cards that provide a high-level summary of performance.

Metrics displayed include:

* Year-to-Date (YTD) Sales
* Previous Year-to-Date (PYTD) Sales
* Gross Profit %
* YTD vs PYTD variance

**Business Question**

Is the company performing better than the same period last year?

**Insight**

Executives can immediately assess overall business performance and detect whether revenue and profitability are improving or declining.

---

## Country Performance Analysis

![image alt](https://github.com/cxu199/PlantCo_Sales_Performance_Report/blob/9c5ecfd4efad46b785d00f1be92853514fa75be7/Bottom%2010%20countries%20YTD%20vs%20PYTD.PNG)

**Visual Type:** Tree Map

**Purpose**

The Tree Map highlights the **bottom performing countries** based on the selected metric (Sales, Quantity, or Gross Profit).

**Business Question**

Which geographic markets require attention?

**Insight**

Management can quickly identify underperforming regions and evaluate whether changes in marketing strategy, pricing, or distribution are required.

---

## Growth Driver Analysis

![image alt](https://github.com/cxu199/PlantCo_Sales_Performance_Report/blob/9c5ecfd4efad46b785d00f1be92853514fa75be7/Waterfall%20month.PNG)
![image alt](https://github.com/cxu199/PlantCo_Sales_Performance_Report/blob/9c5ecfd4efad46b785d00f1be92853514fa75be7/Waterfall%20month%20-%20country.PNG)
![image alt](https://github.com/cxu199/PlantCo_Sales_Performance_Report/blob/9c5ecfd4efad46b785d00f1be92853514fa75be7/Waterfall%20month%20-%20country%20-%20Product%20Type.PNG)
![image alt](https://github.com/cxu199/PlantCo_Sales_Performance_Report/blob/9c5ecfd4efad46b785d00f1be92853514fa75be7/Waterfall%20month%20-%20country%20-%20Product%20Type%20-%20%20Product%20Name.PNG)


**Visual Type:** Waterfall Chart

**Purpose**

The waterfall chart explains how different factors contribute to the difference between **YTD and PYTD performance**.

The visual supports hierarchical drill-down:

* Month
* Country
* Product Type
* Product Name

**Business Question**

What factors are driving revenue growth or decline?

**Insight**

Analysts can quickly identify the months, markets, or products responsible for performance changes.

---

## Product Category Performance

![image alt](https://github.com/cxu199/PlantCo_Sales_Performance_Report/blob/9c5ecfd4efad46b785d00f1be92853514fa75be7/stacked%20bar%20and%20line%20chart%20for%20product%20type%20YTD%20vs%20PYTD.PNG)

**Visual Type:** Stacked Bar + Line Chart

**Purpose**

This visual compares **current year performance (YTD)** against **previous year performance (PYTD)** by product category.

* Bars represent current YTD values
* Line represents PYTD values

**Business Question**

Which product categories are growing or declining?

**Insight**

Management can detect product trends and identify categories that contribute most to business growth.

---

## Customer Profitability Segmentation

![image alt](https://github.com/cxu199/PlantCo_Sales_Performance_Report/blob/9c5ecfd4efad46b785d00f1be92853514fa75be7/Scatter%20plot%20for%20accounts%20GP%25%20vs%20Selected%20Measure.PNG)

**Visual Type:** Scatter Plot

**Purpose**

Customer accounts are analyzed using:

* X-axis → YTD Sales
* Y-axis → Gross Profit %

Reference lines divide the chart into four strategic quadrants.

| Quadrant                 | Interpretation                        |
| ------------------------ | ------------------------------------- |
| High Sales / High Margin | High-value strategic accounts         |
| High Sales / Low Margin  | Strong revenue but weak profitability |
| Low Sales / High Margin  | Potential growth opportunities        |
| Low Sales / Low Margin   | Lower priority accounts               |

**Business Question**

Which customers contribute most to both revenue and profitability?

**Insight**

This segmentation helps prioritize account management strategies and identify opportunities for margin improvement.

---

## Interactive Features

The dashboard includes several interactive capabilities:

* **Dynamic metric switching** between Sales, Quantity, and Gross Profit
* **Hierarchical drill-down** in the waterfall chart
* **Cross-filtering** across all visuals
* **Time-based analysis** using YTD vs PYTD comparisons

These features allow users to explore performance across multiple business dimensions and quickly identify actionable insights.
