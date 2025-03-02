/*
===============================================================================
Quality Checks Before Transformation
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the BRONZE LAYER . It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Bronze Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

--Quality Check For Customers Table
SELECT * FROM bronze.customers

--check uniqueness
SELECT customer_id, COUNT(*)
FROM bronze.customers
GROUP BY customer_id
HAVING COUNT(*) > 1 -- No Duplicates

--check completeneess
SELECT *
FROM bronze.customers
WHERE customer_id IS NULL OR dob IS NULL OR gender IS NULL OR city_code IS NULL -- Handle NULLS in gender and city code

--check consistency
SELECT DISTINCT gender
FROM bronze.customers -- No consistency issue, just express abbreviation in full in gender

SELECT DISTINCT city_code
FROM bronze.customers
ORDER BY city_code-- No consistency issue, just handle NULL

-- checking accuracy
SELECT CONVERT(DATE, dob, 103) AS dob
FROM bronze.customers
WHERE CONVERT(DATE, dob, 103) > GETDATE(); --check for impossibilty (dob in future)

SELECT MAX(CONVERT(DATE, dob, 103)) AS dob
FROM bronze.customers; --check the highest dob

SELECT MIN(CONVERT(DATE, dob, 103)) AS dob
FROM bronze.customers; -- check the lowest dob
			-- dob is accurate


--Quality Check For Product Category Table
SELECT * FROM bronze.prod_cat_info;

--check uniqueness in catcode
SELECT prod_cat_code, COUNT(*)
FROM bronze.prod_cat_info
GROUP BY prod_cat_code
HAVING COUNT(*) > 1 -- There are repetitions. Check consistency in category column for further insight

--check error input in catcode
SELECT DISTINCT prod_cat_code
FROM bronze.prod_cat_info

-- check consistency in category
SELECT DISTINCT prod_cat
FROM bronze.prod_cat_info -- There is consistency issue due to spelling error

-- check uniqueness in subcatcode
SELECT prod_sub_cat_code, COUNT(*)
FROM bronze.prod_cat_info
GROUP BY prod_sub_cat_code
HAVING COUNT(*) > 1 -- There are repetitions. Check consistency in subcategory column for further insight

-- check for error inputs in subcatcode
SELECT DISTINCT prod_sub_cat_code
FROM bronze.prod_cat_info

--check consistency in subcategory
SELECT DISTINCT prod_subcat
FROM bronze.prod_cat_info -- No consistency issue. Just fix spelling error in 'Childran'

--Quality Check For the Transaction Table
SELECT * FROM bronze.transactions

-- Check uniqueness
SELECT transaction_id, COUNT(*)
FROM bronze.transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1 OR transaction_id IS NULL -- There are DUPLICATES

--Closer look at a sample of Duplicates
SELECT *
FROM bronze.transactions
WHERE transaction_id = 10013640089

-- Testing Flagging Process of Duplicated Records
SELECT * 
FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY tran_date) AS record_flag
FROM bronze.transactions
WHERE transaction_id IN (
					SELECT transaction_id
					FROM bronze.transactions
					GROUP BY transaction_id
					HAVING COUNT(*) > 1 OR transaction_id IS NULL)
) t
ORDER BY transaction_id

-- NEGATIVE ISSUE in qty, rate, and total_amt

-- Validate Measures (
WITH measures AS (
SELECT 
	ABS(qty) AS qty,
	ABS(rate) AS rate,
	ABS(CAST(TRIM(tax) AS DECIMAL(10, 2))) AS tax,
	ABS(CAST(TRIM(total_amt) AS DECIMAL(10,2))) AS total_amt
FROM bronze.transactions)

SELECT qty, rate, tax, total_amt
FROM measures
WHERE total_amt <> ((rate * qty) + tax) 
OR qty IS NULL
OR rate IS NULL
OR tax IS NULL
OR total_amt IS NULL -- None. Measure is accurate. 

-- check consistency in Store Type
SELECT DISTINCT store_type
FROM bronze.transactions -- No Issue





SELECT * , DENSE_RANK() OVER (PARTITION BY prod_subcat ORDER BY prod_cat) AS prod_subcat_code
FROM (
SELECT
	CASE 
		WHEN prod_cat1 = 'Bags' THEN 1
		WHEN prod_cat1 = 'Books' THEN 2
		WHEN prod_cat1 = 'Clothing' THEN 3
		WHEN prod_cat1 = 'Electronics' THEN 4
		WHEN prod_cat1 = 'Footwear' THEN 5
		WHEN prod_cat1 = 'Home and kitchen' THEN 6
	END AS prod_cat_code,
	prod_cat1 AS prod_cat, prod_subcat
FROM (
			SELECT 
				*,
				CASE
					WHEN TRIM(prod_cat) = 'Bouks' THEN 'Books'
					WHEN TRIM(prod_cat) = 'Clothng' THEN 'Clothing'
					WHEN TRIM(prod_cat) = 'Hame and kitchen' THEN 'Home and kitchen'
					ELSE TRIM(prod_cat)
				END AS prod_cat1
			FROM bronze.prod_cat_info
) t
) a


SELECT DISTINCT prod_subcat
FROM bronze.prod_cat_info


