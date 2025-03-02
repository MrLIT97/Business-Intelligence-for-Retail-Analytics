/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- Create Dimension: gold.dim_customer
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS 
SELECT 
	customer_id,
	dob AS birthdate,
	gender,
	city_code
FROM silver.customers;
GO

-- Create Dimension: gold.dim_products_category
IF OBJECT_ID('gold.dim_products_category', 'V') IS NOT NULL
	DROP VIEW gold.dim_products_category;
GO

CREATE VIEW gold.dim_products_category AS 
SELECT
	ROW_NUMBER() OVER (ORDER BY prod_cat_code, prod_sub_cat_code) AS product_id,
	prod_cat_code AS product_category_code,
	prod_cat AS product_category,
	prod_sub_cat_code AS product_subcategory_code,
	prod_subcat AS product_subcategory
FROM silver.prod_cat_info;
GO

-- Create Fact: gold.fact_transactions
IF OBJECT_ID('gold.fact_transactions', 'V') IS NOT NULL
	DROP VIEW gold.fact_transactions;
GO

CREATE VIEW gold.fact_transactions AS 
SELECT
	t.transaction_id,
	c.customer_id,
	p.product_id,
	t.tran_date AS transaction_date,
	t.qty AS quantity,
	t.rate AS price,
	t.tax,
	t.total_amt AS total_amount,
	t.store_type
FROM silver.transactions t
LEFT JOIN gold.dim_customers c
	ON t.cust_id = c.customer_id
LEFT JOIN gold.dim_products_category p
	ON t.prod_cat_code = p.product_category_code
	AND t.prod_subcat_code = p.product_subcategory_code


