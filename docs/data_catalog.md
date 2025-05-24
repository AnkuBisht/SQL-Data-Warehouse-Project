DATA DICTIONARY:Gold Layer

OVERVIEW
This table represents a curated Customer Dimension in the Gold Layer of the data_warehouse project, created by consolidating and transforming data from multiple Silver Layer sources.



## 📘 Data Model 1: `gold.dim_customer`

| Column Name       | Data Type   | Description                                                                 |
|-------------------|-------------|-----------------------------------------------------------------------------|
| `customer_key`    | INTEGER     | Surrogate key; uniquely identifies each customer.                          |
| `customer_id`     | INTEGER     | Business-defined customer ID.                                              |
| `customer_number` | VARCHAR(50) | Source system key for identifying the customer.                            |
| `first_name`      | VARCHAR(50) | Customer's first name.                                                     |
| `last_name`       | VARCHAR(50) | Customer's last name.                                                      |
| `country`         | VARCHAR(50) | Standardized country name.                                                 |
| `marital_status`  | VARCHAR(50) | Translated marital status (e.g., 'Single', 'Married').                     |
| `gender`          | VARCHAR(50) | Resolved gender, with fallback if missing.                                 |
| `birthdate`       | DATE        | Customer’s date of birth.                                                  |
| `create_date`     | DATE        | CRM customer creation date.                                                |
