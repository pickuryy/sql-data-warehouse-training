-- silver.crm_cust_info
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
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


-- silver.crm_prd_info
INSERT INTO silver.crm_prd_info(
	prd_id,
	prd_cat_key,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt)
SELECT 
	prd_id,
	REPLACE(SUBSTRING (prd_key,1,5),'-','_') as prd_cat_key,
	SUBSTRING(prd_key, 7, len(prd_key)) as prd_key,
	prd_nm,
	prd_cost,
	CASE WHEN UPPER(prd_line) = 'R' THEN 'Road'
		 WHEN UPPER(prd_line) = 'S' THEN 'other Sales'
		 WHEN UPPER(prd_line) = 'T' THEN 'Touring'
		 WHEN UPPER(prd_line) = 'M' THEN 'Mountain'
		 ELSE 'n/a'
	END prd_line,
	prd_start_dt,
	DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
FROM bronze.crm_prd_info;


-- silver.crm_sales_details
INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price)
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
FROM bronze.crm_sales_details;


-- silver.erd_cust_az12
INSERT INTO silver.erd_cust_az12(
	cid,
	bdate,
	gen)
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



-- silver.erd_loc_a101 
INSERT INTO silver.erd_loc_a101 (
	cid,
	cntry)
SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE WHEN cntry = 'US' OR cntry = 'USA' OR cntry = 'United States' THEN 'United States'
		 WHEN cntry = 'DE' THEN 'Germany'
		 WHEN cntry = '  ' OR cntry IS NULL THEN 'n/a'
		 ELSE cntry
END cntry
FROM bronze.erd_loc_a101 


-- silver.erd_px_cat_g1v2
INSERT INTO silver.erd_px_cat_g1v2(
	id,
	cat,
	subcat,
	maintenance
)
SELECT
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erd_px_cat_g1v2
