-- cust layer
SELECT TOP 10 * FROM silver.crm_cust_info
SELECT TOP 10 * FROM silver.erd_cust_az12
SELECT TOP 10 * FROM silver.erd_loc_a101
SELECT TOP 10 * FROM gold.dim_cust

SELECT
	RIGHT(cst_key, 5) AS cust_id,
	cst_key AS cust_number,
	cst_firstname AS first_name,
	cst_lastname AS last_name,
	cst_marital_status AS marital_status,
	CASE WHEN c.cst_gndr IN ('Male' , 'Female') THEN cst_gndr
		 WHEN bg.gen IS NULL THEN 'n/a'
		 ELSE bg.gen
	END gender,
	cst_create_date AS create_date,
	bdate AS birth_date,
	cntry AS country
FROM silver.crm_cust_info c
LEFT JOIN silver.erd_cust_az12 bg
ON c.cst_key = bg.cid
LEFT JOIN silver.erd_loc_a101 l
ON c.cst_key = l.cid





-- prod layer
SELECT TOP 10 * FROM silver.erd_px_cat_g1v2
SELECT TOP 10 * FROM silver.crm_prd_info

SELECT TOP 10
	prd_cat_key AS cat_id,
	prd_key AS prod_id,
	cat AS category,
	subcat AS subcategory,
	prd_nm AS prod_name,
	prd_line AS line,
	prd_cost AS cost,
	prd_start_dt AS prod_start_date,
	prd_end_dt AS prod_end_date
FROM silver.crm_prd_info p
LEFT JOIN silver.erd_px_cat_g1v2 cp
ON p.prd_cat_key = cp.id





-- sales layer
SELECT TOP 10 * FROM silver.crm_sales_details
SELECT * FROM gold.dim_cust
SELECT TOP 10 
	sls_ord_num AS ord_num,
	sls_prd_key AS prod_id,
	sls_cust_id AS cust_id,
	sls_order_dt AS order_date,
	sls_ship_dt AS ship_date,
	sls_due_dt AS due_date,
	sls_sales AS sales,
	sls_quantity AS quantity,
	sls_price AS price
FROM silver.crm_sales_details
