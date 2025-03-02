/*
=======================================================
CREATE PROCEDURE
LOAT RAW DATA FROM BRONZE LAYER, CLEAN IT AND SAVE IN THE SILVER LAYER
=======================================================
Script Purpose (TL - TRANSFORM, LOAD):
		This script creates a procedure that transforms the data from the BRONZE LAYER and the load it into the SILVER LAYER
		Full Load - Full data from the Bronze Layer is loaded and Transformed through a meticulous Data Cleaning Process involving
		
		Removing Duplicates, Handling Missing Data, 
		Data Type Casting, Data Filtering, 
		Handling Whitespaces, Handing Negativity, 
		Handling Accuracy, Handling Inconsistency, and 
		Validating Measures (Applying Business Logic).

		Being a Full Load, the script truncating existing tables first to remove existing values and then reload them with 
		refreshed data through an insert method
		Acion:
			Execute Procedure with EXEC silver.load_silver
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN -- Start Procedure
	BEGIN TRY -- Start Checking Error

		TRUNCATE TABLE silver.customers; --Truncate Customers Table

		INSERT INTO silver.customers(
							customer_id,
							dob,
							gender,
							city_code
		)
		SELECT 
			customer_id,
			CONVERT(DATE, dob, 103) AS dob,
			CASE
				WHEN TRIM(UPPER(gender)) = 'F' THEN 'Female'
				WHEN TRIM(UPPER(gender)) = 'M' THEN 'Male'
				ELSE 'Unknown'
			END AS gender,
			COALESCE(city_code, 0) AS city_code
		FROM bronze.customers; -- Load into Customers Table


		TRUNCATE TABLE silver.prod_cat_info; -- Truncate Product Category Table

		INSERT INTO silver.prod_cat_info(
								prod_cat_code,
								prod_cat,
								prod_sub_cat_code,
								prod_subcat
		)
		SELECT 
				prod_cat_code,
				CASE
					WHEN TRIM(prod_cat) = 'Bouks' THEN 'Books'
					WHEN TRIM(prod_cat) = 'Clothng' THEN 'Clothing'
					WHEN TRIM(prod_cat) = 'Hame and kitchen' THEN 'Home and kitchen'
					ELSE TRIM(prod_cat)
				END prod_cat,
				prod_sub_cat_code,
				CASE WHEN TRIM(prod_subcat) = 'Childran' THEN 'Children' ELSE TRIM(prod_subcat) END prod_subcat
		FROM bronze.prod_cat_info; -- Load into Product Category Table


		TRUNCATE TABLE silver.transactions; -- Truncate Transactions Table

		INSERT INTO silver.transactions(
							transaction_id,
							cust_id,
							tran_date,
							prod_subcat_code,
							prod_cat_code,
							qty,
							rate,
							tax,
							total_amt,
							store_type
		)
		SELECT 
			CAST(TRIM(transaction_id) AS BIGINT) AS transaction_id,
			cust_id,
			CONVERT(DATE, tran_date, 103) AS tran_date,
			prod_subcat_code,
			prod_cat_code,
			ABS(qty) AS qty,
			ABS(rate) AS rate,
			ABS(CAST(TRIM(tax) AS DECIMAL(10, 2))) AS tax,
			ABS(CAST(TRIM(total_amt) AS DECIMAL(10,2))) AS total_amt,
			TRIM(store_type) AS store_type
		FROM (
		SELECT *, ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY tran_date) AS record_flag
		FROM bronze.transactions
		) t
		WHERE record_flag = 1; -- Load into Transactions Table
	END TRY -- End checking Error
	BEGIN CATCH
		PRINT 'Error Message: ' + ERROR_MESSAGE() -- If Error, print Error Message
	END CATCH
END -- End Procedure
