/*
===============================================================================
Quality Checks After Transformation
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the SILVER LAYER . It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
	- To confirm the efficiency of the Transformations done
    - Run these checks after data loading Silver Layer.
 ===============================================================================
*/

--Quality Check For Customers Table
SELECT * FROM silver.customers

--check uniqueness
SELECT customer_id, COUNT(*)
FROM silver.customers
GROUP BY customer_id
HAVING COUNT(*) > 1 -- No Duplicates

--check completeneess
SELECT *
FROM silver.customers
WHERE customer_id IS NULL OR dob IS NULL OR gender IS NULL OR city_code IS NULL -- Handle NULLS in gender and city code

--check consistency
SELECT DISTINCT gender
FROM silver.customers -- No consistency issue, just express abbreviation in full in gender

SELECT DISTINCT city_code
FROM silver.customers
ORDER BY city_code-- No consistency issue, just handle NULL

-- checking accuracy
SELECT CONVERT(DATE, dob, 103) AS dob
FROM silver.customers
WHERE CONVERT(DATE, dob, 103) > GETDATE(); --check for impossibilty (dob in future)

SELECT MAX(CONVERT(DATE, dob, 103)) AS dob
FROM silver.customers; --check the highest dob

SELECT MIN(CONVERT(DATE, dob, 103)) AS dob
FROM silver.customers; -- check the lowest dob
			-- dob is accurate


--Quality Check For Product Category Table
SELECT * FROM silver.prod_cat_info;

--check uniqueness in catcode
SELECT prod_cat_code, COUNT(*)
FROM silver.prod_cat_info
GROUP BY prod_cat_code
HAVING COUNT(*) > 1 -- There are repetitions. Check consistency in category column for further insight

--check error input in catcode
SELECT DISTINCT prod_cat_code
FROM silver.prod_cat_info

-- check consistency in category
SELECT DISTINCT prod_cat
FROM silver.prod_cat_info -- There is consistency issue due to spelling error

-- check uniqueness in subcatcode
SELECT prod_sub_cat_code, COUNT(*)
FROM silver.prod_cat_info
GROUP BY prod_sub_cat_code
HAVING COUNT(*) > 1 -- There are repetitions. Check consistency in subcategory column for further insight

-- check for error inputs in subcatcode
SELECT DISTINCT prod_sub_cat_code
FROM silver.prod_cat_info

--check consistency in subcategory
SELECT DISTINCT prod_subcat
FROM silver.prod_cat_info -- No consistency issue. Just fix spelling error in 'Childran'

--Quality Check For the Transaction Table
SELECT * FROM silver.transactions

-- Check uniqueness and missing values
SELECT transaction_id, COUNT(*)
FROM silver.transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1 OR transaction_id IS NULL -- There are DUPLICATES or NULL

SELECT tran_date
FROM silver.transactions
WHERE tran_date IS NULL

--Closer look at a sample of Duplicates
SELECT *
FROM silver.transactions
WHERE transaction_id = 10013640089

-- Testing Flagging Process of Duplicated Records
SELECT * 
FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY tran_date) AS record_flag
FROM silver.transactions
WHERE transaction_id IN (
					SELECT transaction_id
					FROM silver.transactions
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
	tax,
	total_amt
FROM silver.transactions)

SELECT qty, rate, tax, total_amt
FROM measures
WHERE total_amt <> ((rate * qty) + tax) 
OR qty IS NULL
OR rate IS NULL
OR tax IS NULL
OR total_amt IS NULL -- None. Measure is accurate. 

-- check consistency in Store Type
SELECT DISTINCT store_type
FROM silver.transactions -- No Issue