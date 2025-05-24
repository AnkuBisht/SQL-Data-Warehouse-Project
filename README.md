# 🏗️ Data Warehouse Project

Welcome to the **Data Warehouse Project**, a structured ETL data pipeline built using **PostgreSQL**. This project models a modern data warehousing architecture using the **Bronze–Silver–Gold** layer pattern.

## 📦 Project Structure

The project is organized into three main data layers:

- **Bronze Layer**: Raw ingestion layer containing untransformed source data.
- **Silver Layer**: Cleaned, enriched, and deduplicated data ready for analysis.
- **Gold Layer** *(Future Scope)*: Business-ready aggregated data for reporting and dashboards.

## 📁 Folder Contents

| File                         | Description                                         |
|-----------------------------|-----------------------------------------------------|
| `ddl_bronze.sql`            | DDL scripts to create raw (bronze) layer tables     |
| `ddl_silver.sql`            | DDL scripts for cleansed (silver) layer tables      |
| `load_silver_procedure.sql` | Stored procedure to transform and load silver data  |

---

## 🗃️ Database: `data_warehouse_project`

### 🥉 Bronze Layer

Tables that hold raw data ingested from various operational sources. These are:

- `bronze.crm_cust_info`
- `bronze.crm_prd_info`
- `bronze.crm_sales_details`
- `bronze.erp_loc_a101`
- `bronze.erp_cust_az12`
- `bronze.erp_px_cat_g1v2`

### 🥈 Silver Layer

Cleaned and normalized versions of the bronze tables:

- `silver.crm_cust_info`
- `silver.crm_prd_info`
- `silver.crm_sales_details`
- `silver.erp_loc_a101`
- `silver.erp_cust_az12`
- `silver.erp_px_cat_g1v2`

These tables include:
- Standardized values (e.g., gender, country)
- Cleaned/trimmed strings
- Default values and derived fields
- Metadata columns like `dwh_create_date`

---

## 🔁 ETL Procedure

The ETL process is encapsulated in a PostgreSQL **stored procedure**:

```sql
CALL silver.load_silver();



Credits
Built by [Ankit Singh Bisht] as part of a hands-on data warehousing learning journey.


 License
This project is open-source and available under the MIT License.

