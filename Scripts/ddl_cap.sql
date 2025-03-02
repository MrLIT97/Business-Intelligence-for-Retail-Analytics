/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'CAP' after checking if it already exists. 
    If the database exists, it is dropped and recreated. 
	Additionally, CAP being a Data Warehouse built with a Medallion architecture, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
*/

USE master;
GO

-- Drop and recreate the 'CAP' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'CAP')
BEGIN
    ALTER DATABASE CAP SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CAP;
END;
GO

-- Create the 'CAP' database
CREATE DATABASE CAP;
GO

USE CAP;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
