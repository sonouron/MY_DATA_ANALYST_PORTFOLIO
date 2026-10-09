
## 🗂️ Database Schema

The project uses a **star schema** with one fact table and two dimension tables:

```
                ┌──────────────────┐
                │  dim_customers   │
                └────────┬─────────┘
                         │ customer_key
                ┌────────▼─────────┐
                │   fact_sales     │
                └────────▲─────────┘
                         │ product_key
                ┌────────┴─────────┐
                │   dim_products   │
                └──────────────────┘
```

```
fact_sales
├── order_number   → Order identifier
├── product_key    → FK → dim_products
├── customer_key   → FK → dim_customers
├── order_date
├── shipping_date
├── due_date
├── sales_amount
├── quantity
└── price

dim_customers
├── customer_key   → PK
├── customer_id
├── customer_number
├── first_name / last_name
├── country
├── gender
├── marital_status
├── birthdate
└── create_date

dim_products
├── product_key    → PK
├── product_id
├── product_number
├── product_name
├── category / subcategory
├── cost
├── product_line
└── start_date
```
