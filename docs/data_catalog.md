Data Dictionary: Gold Layer

Overview
This table represents a curated Customer Dimension in the Gold Layer of the data_warehouse project, created by consolidating and transforming data from multiple Silver Layer sources.

1.Table: gold.dim_customer
Column Name	Data Type	Description
customer_key	INTEGER	Surrogate key; uniquely identifies each customer record in the dimension. Generated using ROW_NUMBER() over cst_id.
customer_id	INTEGER	Business-defined customer ID. May not be unique across all systems.
customer_number	VARCHAR(50)	Business key (cst_key) used in source systems to identify the customer.
first_name	VARCHAR(50)	Customer's first name. Trimmed for consistency.
last_name	VARCHAR(50)	Customer's last name. Trimmed for consistency.
country	VARCHAR(50)	Normalized country information from location source.
marital_status	VARCHAR(50)	Translated marital status: 'S' → 'Single', 'M' → 'Married', others → 'N/A'.
gender	VARCHAR(50)	Final gender value. Prioritizes crm_cust_info; uses erp_cust_az12 as fallback.
birthdate	DATE	Customer's date of birth (if known and valid).
create_date	DATE	Original date the customer was created in the CRM system.
