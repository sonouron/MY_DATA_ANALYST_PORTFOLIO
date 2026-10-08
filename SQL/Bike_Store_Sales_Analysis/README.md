# 🚲 Bike Store Sales Analysis | SQL Project

[SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
[T-SQL](https://img.shields.io/badge/T--SQL-Advanced-blue?style=for-the-badge)
[Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

End-to-end SQL analysis of a global bike store's sales, customers, and products. Built on a 3-table star schema in **SQL Server**, this project covers time-series analysis, product performance, customer segmentation, and executive KPI reporting.

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Database Schema](#%EF%B8%8F-database-schema)
- [SQL Techniques Used](#%EF%B8%8F-sql-techniques-used)
- [Executive Summary](#-executive-summary)
- [Detailed Analysis](#-detailed-analysis)
- [Business Recommendations](#-business-recommendations)
- [Data Quality & Limitations](#%EF%B8%8F-data-quality--limitations)
- [Repository Structure](#-repository-structure)
- [Author](#-author)

---

## 📖 Project Overview

This project explores a retail dataset from a bike store operating across **6 countries**, with orders from **December 2010 to January 2014**. The raw data was delivered as 3 CSV files, loaded into SQL Server, and modeled as a star schema.

The analysis answers **16 business questions** across 4 analytical dimensions:

| Dimension | Focus |
|-----------|-------|
| ⏱️ **Time** | Yearly and monthly trends, running totals, moving averages |
| 📦 **Products** | Category contribution, cost segmentation, top and worst performers |
| 👥 **Customers** | Behavioral segmentation (VIP / Regular / New), age groups, geography, gender |
| 📊 **Executive Report** | Consolidated KPI summary for leadership |

---

## 🗂️ Database Schema

The project uses a **star schema** with one fact table and two dimension tables:

```
fact_sales
├── order_number   → Order identifier
├── product_key    → FK → dim_products
├── customer_key   → FK → dim_customers
├── order_date / shipping_date / due_date
├── sales_amount
├── quantity
└── price

dim_customers
├── customer_key   → PK
├── customer_id / customer_number
├── first_name / last_name
├── country / gender / marital_status
├── birthdate
└── create_date

dim_products
├── product_key    → PK
├── product_id / product_number
├── product_name
├── category / subcategory
├── cost
├── product_line
└── start_date
```

---

## 🛠️ SQL Techniques Used

| Technique | Applied To |
|-----------|-----------|
| Aggregates (`SUM`, `COUNT DISTINCT`, `AVG`) | Yearly and monthly sales, category revenue |
| Date functions (`YEAR`, `MONTH`, `FORMAT`, `DATEDIFF`) | Time trends, lifespan, recency, age |
| Window functions (`SUM() OVER()`, `AVG() OVER()`, `LAG()`) | Running totals, moving averages, % of total, YoY |
| CTEs (`WITH ...`) | Multi-step customer aggregation and segmentation |
| `CASE WHEN` | VIP / Regular / New segments, age groups, cost ranges |
| `NULLIF` + `COALESCE` | Safe division for AOV and monthly spend |
| `LEFT JOIN` | Linking facts to dimensions |
| `UNION ALL` | Consolidated executive KPI report |
| `TOP N` | Best and worst performers |

---

## 🎯 Executive Summary

| Metric | Value |
|--------|-------|
| Total Revenue | **$29,356,250** |
| Total Orders | 27,659 |
| Total Quantity Sold | 60,423 |
| Average Price | $486 |
| Total Customers | 18,484 |
| Total Products | 295 |
| Period Covered | Dec 2010 to Jan 2014 |
| Countries | United States, Australia, United Kingdom, France, Germany, Canada |

**Top 5 takeaways:**

1. **Bikes generate 96.46%** of total revenue.
2. **2013 is the peak year** with $16.3M (56% of all-time sales).
3. **79% of customers are New**: strong acquisition, weak retention.
4. **VIP customers** (9% of the base) have an average order value ~4x higher than New customers.
5. **US + Australia** account for ~56% of units sold.

---

## 🔍 Detailed Analysis

### ⏱️ Part 1: Time Analysis

#### 1. Overall Sales per Year

[Sales per year](images/1-sales_per_year.png)

| Year | Revenue | Unique Customers |
|------|---------|------------------|
| 2010 | $43,419 | 14 |
| 2011 | $7,075,088 | 2,216 |
| 2012 | $5,842,231 | 3,255 |
| 2013 | **$16,344,878** | **17,427** |
| 2014 | $45,642 | 834 |

- **2013 is the peak year**, with revenue nearly 3x higher than 2012.
- **2012 dipped 17% vs 2011** while the customer base grew 47%, pointing to lower-value purchases.
- 2010 (December only) and 2014 (January only) are **partial years**.

#### 2. Sales Drill-Down by Month and Year

[Sales per month and year](images/2-sales_per_month_and_year.png)

- In 2011, monthly revenue grew from **~$470K in January** to a **peak of ~$738K in June**.
- The second half of 2011 stayed strong, between ~$597K and $708K per month.

#### 3. Running Total & Moving Average

[Running total and moving average](images/3-running_total_moving_average.png)

- The running total shows how revenue accumulates over time, with a clear acceleration in 2013.
- The moving average smooths short-term volatility and highlights the long-term trend.

---

### 📦 Part 2: Product Analysis

#### 4. Yearly Product Performance

[Product performance](images/4-product_performance.png)

- Each product's yearly sales are compared to its own average and to the previous year, flagging **Above / Below Average** and **Increase / Decrease**.

#### 5. Category Contribution to Overall Sales

[Best categories](images/5-best_categories.png)

| Category | Revenue | Share |
|----------|---------|-------|
| Bikes | $28,316,272 | **96.46%** |
| Accessories | $700,262 | 2.39% |
| Clothing | $339,716 | 1.16% |

- The business is heavily dependent on a single category: Accessories and Clothing together weigh under 4%.

#### 6. Product Cost Segmentation

[Cost segment](images/6-cost_segment.png)

- **110 products** cost under $100, the largest cost band.
- **39 products** cost over $1,000, almost all in the Bikes category.

#### 11. Products & Average Cost by Category

[Products by category](images/11-product_by_category.png)

| Category | Products | Avg Cost |
|----------|----------|----------|
| Components | 127 | $264 |
| Bikes | 97 | $949 |
| Clothing | 35 | $24 |
| Accessories | 29 | $13 |
| NULL | 7 | $28 |

- **Components is the largest catalog category (127 products) but generates zero sales.**
- **7 products have no category** and should be fixed at the source.

#### 12. Revenue by Category & by Customer

[Revenue by category](images/12-revenue_by_category.png)

- Confirms the Bikes dominance.
- The highest-spending customers each generate **over $10,000** in revenue, a profile matching the VIP segment.

#### 14. Top 5 Subcategories & 5 Worst-Performing Products

[Top 5 best subcategories and worst products](images/14-top5_best_categories.png)

| Top 5 Subcategories | Revenue |
|---------------------|---------|
| Road Bikes | $14,519,438 |
| Mountain Bikes | $9,952,254 |
| Touring Bikes | $3,844,580 |
| Tires and Tubes | $244,634 |
| Helmets | $225,435 |

| Worst 5 Products | Revenue |
|------------------|---------|
| Racing Socks-L | $2,430 |
| Racing Socks-M | $2,682 |
| Patch Kit/8 Patches | $6,382 |
| Bike Wash-Dissolver | $7,272 |
| Touring Tire Tube | $7,440 |

- **Road Bikes alone generate ~49% of total revenue.**
- **Top 3 products:** Mountain-200 Black-46 ($1.37M), Mountain-200 Black-42 ($1.36M), Mountain-200 Silver-38 ($1.34M).

---

### 👥 Part 3: Customer Analysis

#### 7. Customer Segmentation by Spending Behavior

[Customer segment](images/7-customer_segment.png)

| Segment | Customers | Share | Definition |
|---------|-----------|-------|------------|
| New | 14,631 | 79.2% | Lifespan < 12 months |
| Regular | 2,198 | 11.9% | Lifespan ≥ 12 months, sales ≤ $5,000 |
| VIP | 1,655 | 9.0% | Lifespan ≥ 12 months, sales > $5,000 |

- **Nearly 4 out of 5 customers are New** and never reach a 12-month relationship.

#### 8. Customer Profile Report

[Customer segmentation report](images/8-customer_segmentation.png)

- One row per customer with 15 KPIs: orders, sales, quantity, products, recency, segment, age group, AOV, and monthly spend.
- Ready to feed a BI dashboard (Power BI / Tableau) or a CRM campaign.

#### 10. Customers by Country and Gender

[Customers by countries and genders](images/10-customers_by_countries_and_genres.png)

- The **United States** leads with **7,482 customers** (40.5% of the base).
- Gender split is nearly even: **Male 50.5% / Female 49.4%**.

#### 13. Units Sold by Country

[Units sold by country](images/13-units_sold_by_country.png)

| Country | Customers | Units Sold | Units per Customer |
|---------|-----------|-----------|--------------------|
| United States | 7,482 | 20,481 | 2.7 |
| Australia | 3,591 | 13,346 | 3.7 |
| Canada | 1,571 | 7,630 | **4.9** |
| United Kingdom | 1,913 | 6,910 | 3.6 |
| Germany | 1,780 | 5,626 | 3.2 |
| France | 1,810 | 5,559 | 3.1 |

- **US + Australia** account for **~56% of units sold**.
- **Canada** has the highest units per customer, making it a high-engagement market.

#### 15. Revenue by Customer Segment

[Average revenue by segment](images/15-avg_revenue_by_segment.png)

| Segment | Customers | AOV per Customer* |
|---------|-----------|-------------------|
| New | 14,631 | ~$331 |
| Regular | 2,198 | ~$992 |
| VIP | 1,655 | **~$1,417** |

*\*Sum of average order value ÷ number of customers in the segment.*

- **A VIP customer's average order is ~4x larger than a New customer's.**

#### 16. Revenue by Age Segment

[Average revenue by age segment](images/16-avg_revenue_by_age_segment.png)

| Age Group | Sum of Avg Monthly Spend | Sum of Avg Order Value |
|-----------|--------------------------|------------------------|
| Older (40-59) | $5,540,958 | $6,263,083 |
| 60 and Over | $2,827,232 | $3,105,364 |

- The **40-59 age group** contributes about 2x more value than the 60+ group.

---

### 📊 Part 4: Executive Report

#### 9. Key Business Metrics Report

[Executive KPI report](images/9-analyse_report.png)

- **100% of registered customers placed at least one order.**
- Each order contains **~2.2 items** on average (60,423 / 27,659).

---

## 💡 Business Recommendations

1. **Double down on Bikes.** They generate 96% of revenue. Protect and expand the **Mountain-200** line.
2. **Use Accessories & Clothing as cross-sell drivers.** Bundle helmets, tires, and tubes with bike purchases to lift order value.
3. **Launch a retention program for New customers.** Converting even 5% of them to Regular or VIP would have a major revenue impact.
4. **Reward VIP customers.** 9% of the base with the highest order value: a loyalty program here has the best ROI.
5. **Target the 40-59 age segment** in marketing campaigns.
6. **Defend the US and Australia, grow Canada.** Canada's high units-per-customer ratio signals untapped potential.
7. **Review the bottom performers.** Racing Socks (L and M) generate under $5,200 combined.
8. **Investigate the Components category.** 127 listed products with no sales: catalog cleanup or a missed sales channel.

---

## ⚠️ Data Quality & Limitations

- **Partial years:** 2010 contains only December and 2014 only January.
- **NULL categories:** 7 products have no category assigned.
- **Quantity metric:** Q1 and Q2 use `COUNT(quantity)`, which counts order lines rather than units.
- **Recency:** computed with `CURRENT_DATE`, so values reflect time since the dataset ended.
- **Segment aggregates:** Q15 and Q16 sum per-customer averages; per-customer figures were derived by dividing by segment size.

---

## 📁 Repository Structure

```
bike-store-sql-analysis/
├── datasets/
│   ├── fact_sales.csv
│   ├── dim_customers.csv
│   └── dim_products.csv
├── scripts/
│   └── analysis.sql
├── images/
│   └── *.png            → Query result screenshots (1 to 16)
└── README.md
```

---

## 👤 Author

**Ronald Bienvenu SONOU**
Data Analyst | SQL · Data Modeling · Business Intelligence

📧 ronald.sonou1@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/your-profile) · [GitHub](https://github.com/your-username)

---

⭐ *If you found this project useful, feel free to give it a star!*
