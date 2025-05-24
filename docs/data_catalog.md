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




## 📘 Data Model 2: `gold.dim_products`


| Column Name      | Data Type   | Description                                                                 |
|------------------|-------------|-----------------------------------------------------------------------------|
| `product_key`    | INTEGER     | Surrogate key generated using `ROW_NUMBER()`; uniquely identifies each product. |
| `product_id`     | INTEGER     | Product ID from the source system.                                          |
| `product_number` | VARCHAR(50) | Business-defined product key.                                               |
| `product_name`   | VARCHAR(50) | Name/label of the product.                                                  |
| `category_id`    | VARCHAR(50) | Category ID derived from the product key.                                   |
| `category`       | VARCHAR(50) | Main product category name.                                                 |
| `subcategory`    | VARCHAR(50) | Product subcategory.                                                        |
| `maintenance`    | VARCHAR(50) | Maintenance level or notes related to the product.                          |
| `cost`           | INTEGER     | Product cost; cleansed and standardized.                                    |
| `product_line`   | VARCHAR(50) | Product line derived and mapped from original codes (e.g., Mountain, Road). |
| `start_date`     | DATE        | Product start/launch date.                                                  |

### 🛠 Notes:
- This model filters out ended products (`prd_end_dt IS NULL`), ensuring only currently active products are included.
- Surrogate key `product_key` is used for joining in analytical layers (like fact tables).
- The mapping logic in `product_line`, `category`, and `subcategory` provides cleaned and human-readable metadata.



## 📘 Data Model 3: `gold.fact_sales`

| Column Name     | Data Type   | Description                                                        |
|-----------------|-------------|--------------------------------------------------------------------|
| `order_name`    | VARCHAR(50) | Sales order number from CRM.                                       |
| `product_key`   | INTEGER     | Surrogate key from `gold.dim_products` table.                      |
| `customer_key`  | INTEGER     | Surrogate key from `gold.dim_customer` table.                      |
| `order_date`    | DATE        | The date when the order was placed.                                |
| `shipping_date` | DATE        | The date when the order was shipped.                               |
| `due_date`      | DATE        | The expected delivery date.                                        |
| `sales`         | INTEGER     | Total sales amount.                                                |
| `quantity`      | INTEGER     | Number of units sold.                                              |
| `price`         | INTEGER     | Unit price of the product.                                         |

> 🔗 **Joins**:  
> - `silver.crm_sales_details.sls_prd_key` → `gold.dim_products.product_number`  
> - `silver.crm_sales_details.sls_cust_id` → `gold.dim_customer.customer_id`

