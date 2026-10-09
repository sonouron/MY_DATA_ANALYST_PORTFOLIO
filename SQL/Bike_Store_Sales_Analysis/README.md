# 🚲 Bike Store Sales Analysis | SQL Project


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

![Sales per year](images/1-sales_per_year.png)

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

![Sales per month and year](images/2-sales_per_month_and_year.png)

- In 2011, monthly revenue grew from **~$470K in January** to a **peak of ~$738K in June**.
- The second half of 2011 stayed strong, between ~$597K and $708K per month.

#### 3. Running Total & Moving Average

![Running total and moving average](images/3-running_total_moving_average.png)

- The running total shows how revenue accumulates over time, with a clear acceleration in 2013.
- The moving average smooths short-term volatility and highlights the long-term trend.

---

### 📦 Part 2: Product Analysis

#### 4. Yearly Product Performance

![Product performance](images/4-yearly_performance.png)

- Each product's yearly sales are compared to its own average and to the previous year, flagging **Above / Below Average** and **Increase / Decrease**.

#### 5. Category Contribution to Overall Sales

![Best categories](images/5-best_categories.png)


- The business is heavily dependent on a single category: Accessories and Clothing together weigh under 4%.

#### 6. Product Cost Segmentation

![Cost segment](images/6-product_segment.png)

- **110 products** cost under $100, the largest cost band.
- **39 products** cost over $1,000, almost all in the Bikes category.

#### 7. Products & Average Cost by Category

![Products by category](images/11-product_by_category.png)

- **Components is the largest catalog category (127 products) but generates zero sales.**
- **7 products have no category** and should be fixed at the source.

#### 8. Revenue by Category & by Customer

![Revenue by category](images/12-revenue_by_category.png)

- Confirms the Bikes dominance.
- The highest-spending customers each generate **over $10,000** in revenue, a profile matching the VIP segment.

#### 9. Top 5 Subcategories & 5 Worst-Performing Products

![Top 5 best subcategories and worst products](images/14-top5_best_categories.png)

- **Road Bikes alone generate ~49% of total revenue.**
- **Top 3 products:** Mountain-200 Black-46 ($1.37M), Mountain-200 Black-42 ($1.36M), Mountain-200 Silver-38 ($1.34M).

---

### 👥 Part 3: Customer Analysis

#### 10. Customer Segmentation by Spending Behavior

![Customer segment](images/7-customer_segment.png)

| Segment | Customers | Share | Definition |
|---------|-----------|-------|------------|
| New | 14,631 | 79.2% | Lifespan < 12 months |
| Regular | 2,198 | 11.9% | Lifespan ≥ 12 months, sales ≤ $5,000 |
| VIP | 1,655 | 9.0% | Lifespan ≥ 12 months, sales > $5,000 |

- **Nearly 4 out of 5 customers are New** and never reach a 12-month relationship.

#### 11. Customer Profile Report

![Customer segmentation report](images/8-customer_segmentation.png)

- One row per customer with 15 KPIs: orders, sales, quantity, products, recency, segment, age group, AOV, and monthly spend.
- Ready to feed a BI dashboard (Power BI / Tableau) or a CRM campaign.

#### 12. Customers by Country and Gender

![Customers by countries and genders](images/10-customer_by_countries_and_genres.png)

- The **United States** leads with **7,482 customers** (40.5% of the base).
- Gender split is nearly even: **Male 50.5% / Female 49.4%**.

#### 13. Units Sold by Country

![Units sold by country](images/13-distribution.png)


- **US + Australia** account for **~56% of units sold**.
- **Canada** has the highest units per customer, making it a high-engagement market.

#### 14. Revenue by Customer Segment

![Average revenue by segment](images/15-avg_revenue_by_segment.png)

*\*Sum of average order value ÷ number of customers in the segment.*

- **A VIP customer's average order is ~4x larger than a New customer's.**

#### 15. Revenue by Age Segment

![Average revenue by age segment](images/16-avg_revenue_by_age_segment.png)


- The **40-59 age group** contributes about 2x more value than the 60+ group.

---

### 📊 Part 4: Executive Report

#### 16. Key Business Metrics Report

![Executive KPI report](images/9-analyse_report.png)

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

## 👤 Author

**Ronald Bienvenu SONOU**
Data Analyst | SQL • Data Modeling • Business Intelligence • Python • Excel • Power BI
📧 ronald.sonou1@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/ronald-sonou) · [GitHub](https://github.com/sonouron)

---

⭐ *If you found this project useful, feel free to give it a star!*
