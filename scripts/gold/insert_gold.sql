INSERT INTO gold.dim_cust(
	cust_id,
	cust_number,
	first_name,
	last_name,
	marital_status,
	gender,
	create_date,
	birth_date,
	country)
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
ON c.cst_key = l.cid;



INSERT INTO gold.dim_prod(
	cat_id,
	prod_id,
	category,
	subcategory,
	prod_name,
	line,
	cost,
	prod_start_date,
	prod_end_date)
SELECT
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
ON p.prd_cat_key = cp.id;


INSERT INTO gold_fact_sales(
	ord_num,
	prod_id,
	cust_id,
	order_date,
	ship_date,
	due_date,
	sales,
	quantity,
	price)
SELECT
	sls_ord_num AS ord_num,
	sls_prd_key AS prod_id,
	sls_cust_id AS cust_id,
	sls_order_dt AS order_date,
	sls_ship_dt AS ship_date,
	sls_due_dt AS due_date,
	sls_sales AS sales,
	sls_quantity AS quantity,
	sls_price AS price
FROM silver.crm_sales_details;
