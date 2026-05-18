# ShopWave ELT Pipeline

## Overview

ShopWave ELT is a professional Data Engineering project designed to simulate a modern cloud-oriented analytical pipeline for an e-commerce company using the public Brazilian E-Commerce dataset from Olist.

The project follows real-world ELT architecture principles and industry-standard data engineering practices using PostgreSQL, Python, SQL, pandas, and psycopg2.

The pipeline is structured using layered data architecture:

- RAW Layer → Immutable source ingestion
- STAGING Layer → Technical data cleaning and standardization
- MARTS Layer → Business-ready analytical models

The main goal of this project is to demonstrate how modern Data Engineers design scalable, maintainable, and production-oriented data pipelines for analytics and reporting environments.

---

# Architecture

```text
CSV Files
    ↓
Python Ingestion Layer
    ↓
RAW Schema (Immutable)
    ↓
STAGING Schema (Cleaned & Standardized)
    ↓
MARTS Schema (Business Analytics)
```

---

# Dataset

This project uses the public dataset:

Olist Brazilian E-Commerce Dataset

Files used:

- olist_orders_dataset.csv
- olist_order_items_dataset.csv
- olist_customers_dataset.csv
- olist_products_dataset.csv

--- 

# Tech Stack

- Database
- PostgreSQL
- Programming
- Python 3

---

# Libraries

- psycopg2
- pandas

---

# Concepts

- ELT Pipelines
- Data Warehousing
- Data Profiling
- Data Quality
- SQL Transformations
- Schema Layering
- Bulk Ingestion
- Analytical Modeling

---

# Project Structure

```text
shopwave_elt/
│
├── data/
│   ├── olist_orders_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_customers_dataset.csv
│   └── olist_products_dataset.csv
│
├── scripts/
│   ├── create_schemas.py
│   ├── create_raw_tables.py
│   ├── load_raw_data.py
│   └── profile_raw_data.py
│
├── requirements.txt
│
└── README.md
```

---
## Layered Architecture

RAW Layer

Schema:

raw

Tables:

raw.orders
raw.order_items
raw.customers
raw.products
Purpose

The RAW layer stores the original source data exactly as received from external systems.

Rules
Immutable
No transformations
No business logic
No cleaning
All columns stored as TEXT
Exact source preservation
Why This Matters

This approach guarantees:

auditability
reproducibility
traceability
rollback safety
source integrity

This is a standard practice in modern enterprise data platforms.

STAGING Layer

Schema:

staging

Tables:

stg_orders
stg_order_items
stg_customers
stg_products
Purpose

The STAGING layer performs technical transformations and data standardization.

Responsibilities
Type conversions
Null handling
Date parsing
Data standardization
Deduplication
Formatting consistency
Invalid value handling
Important Principle

The STAGING layer contains:

technical logic
data quality logic

But NOT:

business KPIs
aggregations
reporting metrics
MARTS Layer

Schema:

marts

Tables:

sales_by_customer
sales_by_product
sales_by_category
Purpose

The MARTS layer provides business-ready analytical models optimized for dashboards, reporting, and decision-making.

Responsibilities
KPIs
Aggregations
Revenue metrics
Customer analytics
Product analytics
Category performance
Why MARTS Matter

Separating MARTS from STAGING improves:

query performance
governance
maintainability
scalability
analytical usability
Implemented Features
PostgreSQL Database Setup

Created:

database: shopwave
schemas:
raw
staging
marts
RAW Table Creation

Implemented using:

Python
psycopg2
dynamic SQL execution

All RAW columns were intentionally created as TEXT to preserve source integrity.

Bulk CSV Ingestion

Implemented using PostgreSQL COPY command via:

cursor.copy_expert()
Why COPY Was Used

COPY is significantly faster than row-by-row INSERT statements because it:

minimizes transaction overhead
reduces network round trips
uses PostgreSQL internal optimizations
scales for large datasets

This is a production-oriented ingestion strategy.

Data Profiling & Exploration

The project includes a dedicated profiling phase before transformations.

Objectives
Detect null values
Identify duplicates
Find malformed records
Validate numeric consistency
Analyze timestamp quality
Detect analytical risks
Why Profiling Matters

Data profiling is critical for:

data quality validation
transformation design
analytical trustworthiness
downstream reliability

Professional Data Engineering pipelines always validate source quality before transformation layers.

Engineering Principles Applied
Separation of Responsibilities

Each layer has a single responsibility:

Layer	Responsibility
RAW	Source preservation
STAGING	Technical cleaning
MARTS	Business analytics
Immutable RAW Design

RAW data is never modified.

Benefits:

traceability
auditability
disaster recovery
reproducibility
ELT Architecture

The project follows ELT instead of traditional ETL.

Why ELT

Transformations occur inside PostgreSQL after loading because:

databases are highly optimized
transformations become scalable
SQL becomes centralized
orchestration becomes simpler
Production-Oriented Patterns

Implemented concepts:

transaction handling
rollback support
connection management
modular scripting
scalable query organization
schema isolation
bulk ingestion optimization
Future Improvements

Potential extensions:

Airflow orchestration
dbt transformations
Docker containerization
CI/CD pipelines
Data quality frameworks
Incremental loading
Partitioning strategies
Cloud deployment
Monitoring and alerting
Automated testing
Learning Outcomes

This project demonstrates practical knowledge of:

Data Warehousing
ELT Architecture
PostgreSQL Engineering
Python Data Pipelines
Bulk Data Loading
SQL Transformation Design
Data Profiling
Data Quality Engineering
Layered Data Architectures
Analytical Modeling
Author

Miguel Angel Mejia Mejia

Data Engineering • ELT • PostgreSQL • Python • Analytics

GitHub Portfolio Project focused on professional Data Engineering practices and scalable analytical pipeline design.