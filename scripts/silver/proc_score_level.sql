-- =====================================================================
-- File: load_silver_procedure.sql
-- Description: Defines a stored procedure to load and transform data
--              from the 'bronze' (raw) layer into the 'silver' (cleansed) layer.
--
-- Procedure: silver.load_silver()
-- Language : PL/pgSQL
--
-- Purpose:
--   - Truncates existing records in the 'silver' tables
--   - Loads, cleanses, and transforms data from 'bronze' tables
--   - Applies standardization, formatting, and basic business logic
--   - Handles nulls, malformed values, and ensures data quality
--
-- Key Features:
--   - Standardizes gender and marital status fields
--   - Computes sales values when missing
--   - Fixes malformed date fields
--   - Categorizes and restructures product keys and customer identifiers
--   - Adds basic enrichment like product line decoding and country names
--
-- Tables Affected:
--   - silver.crm_cust_info
--   - silver.crm_prd_info
--   - silver.crm_sales_details
--   - silver.erp_cust_az12
--   - silver.erp_loc_a101
--   - silver.erp_px_cat_g1v2
--
-- How to Execute:
--   CALL silver.load_silver();
--
-- Author: [Ankit Singh Bisht]
-- 
-- =====================================================================

  
  CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN

  RAISE NOTICE 'Truncating silver tables...';
  TRUNCATE TABLE 
    silver.crm_cust_info,
    silver.crm_prd_info,
    silver.crm_sales_details,
    silver.erp_cust_az12,
    silver.erp_loc_a101,
    silver.erp_px_cat_g1v2;

  RAISE NOTICE 'Loading into silver.crm_cust_info...';
  INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
  )
  SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname),
    TRIM(cst_lastname),
    CASE
      WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
      WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
      ELSE 'N/A'
    END,
    CASE
      WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
      WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
      ELSE 'N/A'
    END,
    cst_create_date
  FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS ranks
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
  ) t
  WHERE ranks = 1;

  RAISE NOTICE 'Loading into silver.crm_prd_info...';
  INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
  )
  SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
    SUBSTRING(prd_key, 7, LENGTH(prd_key)),
    prd_nm,
    COALESCE(prd_cost, 0),
    CASE
      WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
      WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
      WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'other Sales'
      WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
      ELSE 'n/a'
    END,
    CAST(prd_start_dt AS DATE),
    CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS DATE)
  FROM bronze.crm_prd_info;

  RAISE NOTICE 'Loading into silver.crm_sales_details...';
  INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
  )
  SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE
      WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
      ELSE TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
    END,
    CASE
      WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
      ELSE TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')
    END,
    CASE
      WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
      ELSE TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')
    END,
    CASE
      WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
      THEN sls_quantity * ABS(sls_price)
      ELSE sls_sales
    END,
    sls_quantity,
    CASE
      WHEN sls_price IS NULL OR sls_price <= 0
      THEN sls_sales / NULLIF(sls_quantity, 0)
      ELSE sls_price
    END
  FROM bronze.crm_sales_details;

  RAISE NOTICE 'Loading into silver.erp_cust_az12...';
  INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
  SELECT
    CASE
      WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
      ELSE cid
    END,
    CASE
      WHEN bdate > NOW() THEN NULL
      ELSE bdate
    END,
    CASE
      WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
      WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
      ELSE 'n/a'
    END
  FROM bronze.erp_cust_az12;

  RAISE NOTICE 'Loading into silver.erp_loc_a101...';
  INSERT INTO silver.erp_loc_a101 (cid, cntry)
  SELECT
    REPLACE(cid, '-', ''),
    CASE
      WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
      WHEN TRIM(cntry) = 'DE' THEN 'Germany'
      WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
      ELSE cntry
    END
  FROM bronze.erp_loc_a101;

  RAISE NOTICE 'Loading into silver.erp_px_cat_g1v2...';
  INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
  )
  SELECT
    id,
    cat,
    subcat,
    maintenance
  FROM bronze.erp_px_cat_g1v2;

END;
$$;

call silver.load_silver()




