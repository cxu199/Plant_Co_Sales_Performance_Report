# Recommended DAX measures

These measures are aligned to the uploaded PBIX logic but rewritten in a cleaner portfolio style.

```DAX
Total Sales =
SUM ( fact_sales[sales_usd] )
```

```DAX
Total COGS =
SUM ( fact_sales[cogs_usd] )
```

```DAX
Gross Profit =
[Total Sales] - [Total COGS]
```

```DAX
GP % =
DIVIDE ( [Gross Profit], [Total Sales] )
```

```DAX
Sales YTD =
TOTALYTD ( [Total Sales], dim_date[date_key] )
```

```DAX
Sales PYTD =
CALCULATE (
    [Total Sales],
    SAMEPERIODLASTYEAR ( DATESYTD ( dim_date[date_key] ) )
)
```

```DAX
YTD vs PYTD =
[Sales YTD] - [Sales PYTD]
```

```DAX
YTD vs PYTD % =
DIVIDE ( [YTD vs PYTD], [Sales PYTD] )
```

```DAX
Gross Profit YTD =
TOTALYTD ( [Gross Profit], dim_date[date_key] )
```

```DAX
Gross Profit PYTD =
CALCULATE (
    [Gross Profit],
    SAMEPERIODLASTYEAR ( DATESYTD ( dim_date[date_key] ) )
)
```

```DAX
Rolling 12M Sales =
CALCULATE (
    [Total Sales],
    DATESINPERIOD ( dim_date[date_key], MAX ( dim_date[date_key] ), -12, MONTH )
)
```

```DAX
Report Title =
"Plant Co Sales Performance | " &
SELECTEDVALUE ( dim_date[year], "All Years" )
```
