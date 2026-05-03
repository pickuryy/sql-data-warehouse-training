-- silver.crm_cust_info (DONE)
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname, -- remove whitespace
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN UPPER(cst_marital_status) = 'S' THEN 'Single' -- if else change value
		 WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
		 ELSE 'n/a'
	END cst_marital_status, -- end of case as value name
	CASE WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
		 WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
		 ELSE 'n/a'
	END cst_gndr,
	cst_create_date
FROM(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
	FROM bronze.crm_cust_info)t
WHERE cst_id IS NOT NULL and rn = 1;


-- silver.crm_prd_info (DONE)
SELECT 
	prd_id,
	REPLACE(SUBSTRING (prd_key,1,5),'-','_') as prd_cat_key,
	SUBSTRING(prd_key, 7, len(prd_key)) as new_prd_key,
	prd_nm,
	prd_cost,
	CASE WHEN UPPER(prd_line) = 'R' THEN 'Road'
		 WHEN UPPER(prd_line) = 'S' THEN 'other Sales'
		 WHEN UPPER(prd_line) = 'T' THEN 'Touring'
		 WHEN UPPER(prd_line) = 'M' THEN 'Mountain'
		 ELSE 'n/a'
	END prd_line,
	prd_start_dt,
	DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS new_prd_end_dt 
FROM bronze.crm_prd_info 
ORDER BY prd_cost DESC

-- silver.crm_sales_details (DONE)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt=0 or len(sls_order_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE WHEN sls_ship_dt=0 or len(sls_ship_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt=0 or len(sls_due_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE WHEN sls_sales < 0 THEN ABS(sls_sales) --asumption sales is the main char of data (i mean price will follow the condition of sales)
		WHEN sls_sales = 0 or sls_sales IS NULL THEN ABS(sls_price)/ABS(sls_quantity)
	ELSE sls_sales
	END new_sls_sales,
	sls_quantity,
	CASE WHEN sls_price < 1 or sls_price != ABS(sls_quantity)*ABS(sls_sales) or sls_price IS NULL
	THEN ABS(sls_quantity)*ABS(
		CASE WHEN sls_sales < 0 THEN ABS(sls_sales)
			 WHEN sls_sales = 0 THEN ABS(sls_price)/ABS(sls_quantity)
		ELSE sls_sales
	END)
	ELSE sls_price
	END new_sls_price
FROM bronze.crm_sales_details

SELECT * from silver.crm_prd_info

-- silver.erd_cust_az12 (DONE)
SELECT 
	CASE WHEN LEFT(cid,3) = 'NAS' THEN right(cid,10)
	ELSE cid
END cid,
	CASE WHEN bdate > GETDATE() THEN NULL
	ELSE bdate
END bdate,
	CASE WHEN gen = 'F' OR gen = 'Female' THEN 'Female'
		 WHEN gen = 'M' OR gen = 'Male' THEN 'Male'
		 ELSE 'n/a'
END gen
FROM bronze.erd_cust_az12


-- silver.erd_loc_a101 (DONE)
SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE WHEN cntry = 'US' OR cntry = 'USA' OR cntry = 'United States' THEN 'United States'
		 WHEN cntry = 'DE' THEN 'Germany'
		 WHEN cntry = '  ' OR cntry IS NULL THEN 'n/a'
		 ELSE cntry
END cntry
FROM bronze.erd_loc_a101 ORDER BY cntry


/* Common step for cleane/integrate data :
1. Check the data condition
We must know all the content of our data, so we can make an early assumption about what type of method that will we use

2. Check the value per column (use distinct or select *)
In this step we will know about the content and the anomalies (duplicate, extra whitespace, different data type, etc.)

3. Get to know the content of data by asking the experts
We must know all the value mean in our data like M is for Mountain (in this case), etc., we must know what is the priority of each data?

4. If there are any number in the data, we must make sure it fulfill the logic
Example : end date always happen after the start date, price/sales always positive, age always positive, are ther any NULL?

5. Data integration : get to know how to make sure all of the table in the data can explain each other
To integrate each data, we must make sure the value type is similar each other. We must have the same data type (for id, date, etc.)
*/
