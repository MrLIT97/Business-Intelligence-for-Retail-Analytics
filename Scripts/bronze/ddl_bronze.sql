/*
=======================================================
CREATE TABLES IN THE BRONZE LAYERS
=======================================================
Script Purpose:
		This script creates required tables: customers, prod_cat_info and transactions in the BRONZE LAYER by
		first checking if the table exists. If exists, it drops the table and recreates it.
		This Layer is just for STAGING. Data are RETAINED as RAW FROM THE SOURCE
*/

IF OBJECT_ID('bronze.customers', 'U') IS NOT NULL
	DROP TABLE bronze.customers;
GO

CREATE TABLE bronze.customers (
					customer_id INT,
					dob NVARCHAR(15),
					gender NVARCHAR(15),
					city_code INT
);  -- each field set to the format compatible with the source data 
GO

IF OBJECT_ID('bronze.prod_cat_info', 'U') IS NOT NULL
	DROP TABLE bronze.prod_cat_info;
GO

CREATE TABLE bronze.prod_cat_info (
					prod_cat_code INT,
					prod_cat NVARCHAR(50),
					prod_sub_cat_code INT,
					prod_subcat NVARCHAR(50)
);  -- each field set to the format compatible with the source data 
GO

IF OBJECT_ID('bronze.transactions', 'U') IS NOT NULL
	DROP TABLE bronze.transactions;
GO

CREATE TABLE bronze.transactions (
					transaction_id NVARCHAR(25),
					cust_id INT,
					tran_date NVARCHAR(15), 
					prod_subcat_code INT,
					prod_cat_code INT,
					qty INT,
					rate INT,
					tax NVARCHAR(15),
					total_amt NVARCHAR(15),
					store_type NVARCHAR(15)
); -- each field set to the format compatible with the source data 
GO
