# Bike Store Sales Analysis — SQL Project

End-to-end SQL analysis of a global bike store's sales, customers, and products. Built on a 3-table star schema using SQL Server — covering time-series analysis, customer segmentation, product performance, and executive reporting.

---

## Project Overview
 
This project explores a real-world retail dataset from a bike store operating across 6 countries between 2010 and 2014. Using advanced SQL techniques — CTEs, window functions, CASE WHEN segmentation, and UNION-based reporting — the analysis answers 16 business questions structured around 4 analytical dimensions:
 
- **Time** — Sales trends by year, month, running totals, moving averages
- **Products** — Category performance, cost segmentation, top/worst performers
- **Customers** — Behavioral segmentation (VIP / Regular / New), age groups, geography
- **Executive Report** — Consolidated KPI summary for leadership

---

## Database Schema
 
The project uses a **star schema** with 3 tables:
 
```
fact_sales
├── order_number      → Unique order identifier
├── product_key       → FK → dim_products
├── customer_key      → FK → dim_customers
├── order_date
├── shipping_date
├── due_date
├── sales_amount
├── quantity
└── price
 
dim_customers
├── customer_key      → PK
├── customer_id
├── customer_number
├── first_name / last_name
├── country
├── gender
├── marital_status
├── birthdate
└── create_date
 
dim_products
├── product_key       → PK
├── product_id
├── product_number
├── product_name
├── category / subcategory
├── cost
├── product_line
└── start_date
```
---

## Dataset at a Glance
 
| Metric | Value |
|--------|-------|
| Total rows (fact_sales) | 60,398 |
| Total Revenue | $29,356,250 |
| Total Orders | 27,659 |
| Total Quantity Sold | 60,423 |
| Average Price | $486 |
| Total Customers | 18,484 |
| Total Products | 295 |
| Period Covered | 2010 – 2014 |
| Countries | United States, Australia, UK, France, Germany, Canada |
 

---

## 🔑 Key Business Insights
 
### Revenue & Sales
 
- **$29.4M** total revenue generated over 4 years
- **2013 was the peak year** — 17,427 unique customers, 52,782 units sold
- Sales dropped sharply in **2014** (only $45,642) indicating potential data truncation for that year

### Product Performance
 
- **Bikes dominate at 96.46%** of total revenue ($28.3M out of $29.4M)
- Accessories (2.39%) and Clothing (1.16%) are marginal contributors
- **Road Bikes** are the top subcategory ($14.5M), followed by Mountain Bikes ($9.9M)
- **Top 3 products by revenue:** Mountain-200 Black-46 ($1.37M),
  Mountain-200 Black-42 ($1.36M), Mountain-200 Silver-38 ($1.34M)
- **Worst performers:** Racing Socks-L ($2,430), Racing Socks-M ($2,682) —
  strong candidates for discontinuation or repositioning
- **110 products** are priced below $100 (cost), while **39** exceed $1,000


### Customer Segmentation
 
| Segment | Total Customers | Definition |
|---------|----------------|------------|
| New | 14,631 | Active < 12 months |
| Regular | 2,198 | Active ≥ 12 months, sales ≤ $5,000 |
| VIP | 1,655 | Active ≥ 12 months, sales > $5,000 |
 
- Despite being the smallest group, **VIP customers** generate the highest
  average monthly spend — priority retention target
- **United States** leads with 7,482 customers (40.5% of total base)
- Gender split is nearly equal: Male 50.5% / Female 49.4%


### 🗺️ Geography
 
| Country | Customers | Units Sold |
|---------|-----------|-----------|
| United States | 7,482 | 20,481 |
| Australia | 3,591 | 13,346 |
| Canada | 1,571 | 7,630 |
| United Kingdom | 1,913 | 6,910 |
| Germany | 1,780 | 5,626 |
| France | 1,810 | 5,559 |
 
### Age Segments
 
| Age Group | Avg Monthly Total | Avg Order Total |
|-----------|-------------------|-----------------|
| 60 and Over | $2,827,232 | $3,105,364 |
| Older (40-59) | $5,540,958 | $6,263,083 |
 
- The **40-59 age group** is the highest-spending segment by order value


---
## 💡 Business Recommendations
 
Based on the SQL analysis, the following actions are recommended:
 
1. **Double down on Bikes** — 96% of revenue. Expand the Mountain-200 line
   which contains the top 5 revenue-generating products.
2. **Re-evaluate Accessories & Clothing** — Less than 4% combined revenue.
   Consider reducing SKU count or improving margin strategy.
3. **Activate VIP retention program** — Only 1,655 VIP customers but
   disproportionately high spend. A loyalty program here has the highest ROI.
4. **Prioritize the 40-59 age segment** — Highest average order value.
   Marketing campaigns should target this demographic specifically.
5. **Invest in the US and Australian markets** — Together they account for
   over 60% of units sold. These are the core markets to defend.
6. **Discontinue Racing Socks line** — Less than $5,000 total revenue
   across both SKUs. Resources better allocated elsewhere.
