/*
=======================================================
CREATE PROCEDURE
FULL EXTRACT DATA FROM SOURCE INTO TABLES IN THE BRONZE LAYER
=======================================================
Script Purpose (EL - EXTRACT, LOAD):
		File Parsing - This script creates a procedure that extracts data from the source files into the BRONZE LAYER
		Full Extract - Full data from the source file is extracted through a batch streaming process 
		by first truncating existing tables and reloading them with data through a bulk insert

		Being a Full Extract, the script truncating existing tables first to remove existing values and then reload them with 
		refreshed data through an insert method
		
		Acion:
			Execute Procedure with EXEC bronze.load_bronze
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN -- Start Procedure
	BEGIN TRY -- Start Checking Error
		TRUNCATE TABLE bronze.customers; -- Truncate Customers Table

		BULK INSERT bronze.customers 
		FROM 'C:\Users\USER\Desktop\My Portfolio\CAP\Case Study 2 Datasets\Customer.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		); -- Load into Customers Table

		TRUNCATE TABLE bronze.prod_cat_info; -- Truncate Product Category Table

		BULK INSERT bronze.prod_cat_info 
		FROM 'C:\Users\USER\Desktop\My Portfolio\CAP\Case Study 2 Datasets\prod_cat_info.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		); -- Load into Products Category Table

		TRUNCATE TABLE bronze.transactions; -- Truncate Transactions Table

		BULK INSERT bronze.transactions 
		FROM 'C:\Users\USER\Desktop\My Portfolio\CAP\Case Study 2 Datasets\Transactions.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		); -- Load into Transactions Table
	END TRY -- End Checking Error
	BEGIN CATCH
		PRINT 'Error Message: ' + ERROR_MESSAGE() -- If Error, print Error Message;
	END CATCH
		PRINT 'Bronze Layer Successfully Loaded';
END -- End Procedure

