# Data Warehouse Project

This project implements a robust, scalable data warehouse architecture using a **Bronze-Silver-Gold** layered approach to process and transform raw data into clean, business-ready datasets for analytics and reporting.

---

## Project Overview

The project organizes the data pipeline into three layers, each designed for specific data management and transformation purposes:

### Bronze Layer — Raw Data Ingestion

- Stores raw, unprocessed data from source systems (CRM, ERP, sales).
- Data is ingested as-is with minimal transformation to preserve original details.
- Tables include:
  - `bronze.crm_cust_info` — Raw customer details.
  - `bronze.crm_prd_info` — Raw product information.
  - `bronze.crm_sales_details` — Raw sales transactions.
  - ERP-related tables with location and category info.

Purpose: Serve as the single source of truth for all raw input data and maintain full auditability.

---

### Silver Layer — Data Cleansing & Standardization

- Cleanses and standardizes Bronze data to improve quality and consistency.
- Applies transformations like trimming text, standardizing categorical values (e.g., gender, marital status), date formatting, and deduplication.
- Adds metadata such as load timestamps.
- Tables include cleansed versions of customer, product, sales, and ERP datasets.

Purpose: Provide a reliable, intermediate curated dataset ready for further enrichment.

---

### Gold Layer — Business-Ready Data Model

- Constructs analytical models optimized for business users and reporting.
- Creates dimension tables (`dim_customer`, `dim_products`) with surrogate keys and business keys.
- Builds fact tables to capture transactions and metrics.
- Supports analytics, dashboarding, and decision-making processes.

Purpose: Deliver performant and clean datasets that power business intelligence.

---

## Data Pipeline Summary

| Layer  | Description                        | Key Operations                             | Example Tables             |
|--------|----------------------------------|--------------------------------------------|---------------------------|
| Bronze | Raw data ingestion                | Load raw source data                        | `bronze.crm_cust_info`    |
| Silver | Cleansing and standardization    | Trim, format, deduplicate, standardize     | `silver.crm_cust_info`    |
| Gold   | Analytical data modeling         | Build dimensions, facts, surrogate keys    | `gold.dim_customer`       |

---

## Usage

- Run the SQL scripts sequentially from Bronze → Silver → Gold.
- Use provided stored procedures to load and transform data efficiently.
- Query Gold layer tables for reporting and analysis.

---

## Skills Utilized

- **SQL & PL/pgSQL**: Writing ETL procedures, complex queries, and transformations.
- **Data Warehousing**: Multi-layer architecture design and implementation.
- **Data Cleansing**: Handling nulls, standardizing fields, and data quality improvements.
- **Data Modeling**: Designing dimension and fact tables with surrogate keys.
- **Database Management**: Working with PostgreSQL schemas and procedures.
- **Version Control**: Managing scripts and collaboration via Git/GitHub.

---

## Folder Structure (Example)

