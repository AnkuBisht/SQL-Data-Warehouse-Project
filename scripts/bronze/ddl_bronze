-- =====================================================================
-- File: ddl_bronze.sql
-- Description: Contains all table creation statements for the 'bronze' schema
--              in a multi-layered data warehouse architecture.
--
-- Layer: Bronze (Raw/Staging Layer)
--
-- Purpose:
--   - Stores raw ingested data with minimal transformation
--   - Acts as the base layer for building Silver and Gold layer datasets
--   - Enables reproducibility, traceability, and rollback
--
-- Tables Included:
--   - bronze.crm_cust_info         -- Raw customer data
--   - bronze.crm_prd_info          -- Product master information
--   - bronze.crm_sales_details     -- Sales transaction records
--   - bronze.erp_loc_a101          -- Customer location data
--   - bronze.erp_cust_az12         -- ERP customer attributes
--   - bronze.erp_px_cat_g1v2       -- ERP product catalog and maintenance info
--
-- How to Execute:
--   Ensure the 'bronze' schema exists:
--     CREATE SCHEMA IF NOT EXISTS bronze;
--
--   Then run:
--     \i ddl/ddl_bronze.sql
--
-- Author: [Ankit Singh Bisht]
--
-- =====================================================================



create table bronze.crm_cust_info(
    cst_id              INT,
    cst_key             VARCHAR(50),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  VARCHAR(50),
    cst_gndr            VARCHAR(50),
    cst_create_date     date
)

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_dt TIMESTAMP,
    prd_end_dt   TIMESTAMP
)

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
)

CREATE TABLE bronze.erp_loc_a101 (
    cid    VARCHAR(50),
    cntry  VARCHAR(50)
)

CREATE TABLE bronze.erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50)
)

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50)
)








