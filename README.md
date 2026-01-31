# E-Commerce Data Pipeline

## 📌 Overview
This project implements an **end-to-end data pipeline** for an e-commerce system, transforming raw transactional data into analytics-ready data marts.

The main goal of this project is to demonstrate **data engineering fundamentals**:
- data ingestion
- layered data modeling (raw → staging → marts)
- reproducible pipelines
- basic data quality checks
- clear project structure

This is **not a dashboard or BI project**, but a **pipeline-focused data engineering project**.

---

## 🧱 Architecture Overview
```text
Raw Data (CSV)
↓
Ingestion Layer
↓
Staging Layer (cleaned & standardized)
↓
Marts Layer (analytics-ready tables)
```

Each layer is executed as an independent step and orchestrated locally using a `Makefile`.

---

## 📂 Project Structure
```text
ecommerce-data-pipeline/
│
├── data/
│ ├── raw/ # Raw source data (CSV / JSON)
│ ├── staging/ # Cleaned and standardized data
│ └── marts/ # Analytics-ready data marts
│
├── src/
│ ├── ingestion/ # Raw data ingestion logic
│ ├── staging/ # Raw → staging transformations
│ ├── marts/ # Build fact & dimension tables
│ └── utils/ # Shared utilities (logging, helpers)
│
├── sql/
│ ├── ddl/ # Table definitions
│ └── marts/ # Analytics queries (optional)
│
├── tests/ # Basic data quality checks
├── config/ # Pipeline configuration
│
├── Makefile # Pipeline orchestration
├── README.md
├── requirements.txt
└── .gitignore
```

---

## 📊 Data Model (High Level)

This pipeline is built around three core entities:

- **customers**
- **orders**
- **order_items**

Relationships:
- One customer can have many orders
- One order can have many order items

The data is intentionally modeled in multiple layers to simulate real-world data pipelines.

---

## ⚙️ Pipeline Steps

### 1️⃣ Ingestion
- Reads source data
- Splits and stores entity-based raw tables
- Writes output to `data/raw/`

### 2️⃣ Staging
- Cleans and standardizes raw data
- Handles missing values and basic validation
- Writes output to `data/staging/`

### 3️⃣ Marts
- Builds analytics-ready fact and dimension tables
- Writes output to `data/marts/`

---

## 🧪 Data Quality Checks
Basic data quality validations are applied, such as:
- non-empty datasets
- non-null primary keys
- referential integrity between tables

These checks ensure that downstream data is reliable.

---

## ▶️ How to Run the Pipeline

All pipeline steps are orchestrated using a `Makefile`.

Run individual steps:
```bash
make ingest
make staging
make marts
```

Run the full pipeline:
```bash
make run-all
```

---

## 🛠️ Tech Stack

- Python
- Pandas
- SQL
- Makefile (local orchestration)

---

## 🎯 Project Scope

This project focuses on:

- pipeline structure
- data modeling
- reproducibility
- engineering best practices

---

## 📌 Notes

This project is designed as a learning and portfolio project to demonstrate data engineering concepts in a clear and structured way.