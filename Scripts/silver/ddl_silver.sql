/*
=======================================================
CREATE TABLES IN THE SILVER LAYERS
=======================================================
Script Purpose:
		This script creates required tables: customers, prod_cat_info and transactions in the SILVER LAYER by
		first checking if the table exists. If exists, it drops the table and recreates it.
		This Layer is for CLEAN DATA. Data Loaded from the Bronze Layer and TRANSFORMED is saved here.
*/

IF OBJECT_ID('silver.customers', 'U') IS NOT NULL
	DROP TABLE silver.customers;
GO

CREATE TABLE silver.customers (
					customer_id INT,
					dob DATE,
					gender NVARCHAR(15),
					city_code INT,
					cap_date_created DATETIME DEFAULT GETDATE()
);  -- each field set to the format compatible with the source data 
GO

IF OBJECT_ID('silver.prod_cat_info', 'U') IS NOT NULL
	DROP TABLE silver.prod_cat_info;
GO

CREATE TABLE silver.prod_cat_info (
					prod_cat_code INT,
					prod_cat NVARCHAR(50),
					prod_sub_cat_code INT,
					prod_subcat NVARCHAR(50),
					cap_date_created DATETIME DEFAULT GETDATE()
);  -- each field set to the format compatible with the source data 
GO

IF OBJECT_ID('silver.transactions', 'U') IS NOT NULL
	DROP TABLE silver.transactions;
GO

CREATE TABLE silver.transactions (
					transaction_id BIGINT,
					cust_id INT,
					tran_date DATE, 
					prod_subcat_code INT,
					prod_cat_code INT,
					qty INT,
					rate INT,
					tax DECIMAL(10,2),
					total_amt DECIMAL(10,2),
					store_type NVARCHAR(15),
					cap_date_created DATETIME DEFAULT GETDATE()
); -- each field set to the format compatible with the source data 
GO
