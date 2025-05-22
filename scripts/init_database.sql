-- ====================================================
-- Script: create_datawarehouse.sql
-- Description: Creates a PostgreSQL DataWarehouse database
--              with Bronze, Silver, and Gold schemas
-- Author: [Your Name]
-- ====================================================

-- STEP 1: Create the database
-- (Note: Run this from a PostgreSQL superuser or user with CREATE privileges)
CREATE DATABASE "DataWarehouse";

-- ====================================================
-- After running the above command, connect to the
-- DataWarehouse database before executing the next part
-- ====================================================

-- STEP 2: Create Bronze, Silver, and Gold schemas
-- Connect to DataWarehouse database before running the following:

-- Create Bronze schema (raw/ingested data)
CREATE SCHEMA IF NOT EXISTS bronze;

-- Create Silver schema (cleaned/transformed data)
CREATE SCHEMA IF NOT EXISTS silver;

-- Create Gold schema (aggregated/analytics-ready data)
CREATE SCHEMA IF NOT EXISTS gold;

-- ====================================================
-- Optional: Verify created schemas
-- Run \dn in psql to list all schemas
-- ====================================================
