CREATE TABLE bronze.crm_cust_info(
	cst_id VARCHAR(50),
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE
);

CREATE TABLE bronze.crm_prd_info(
	prd_id VARCHAR(50),
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);
DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id VARCHAR(50),
	sls_order_dt VARCHAR(50),
	sls_ship_dt VARCHAR(50),
	sls_due_dt VARCHAR(50),
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

CREATE TABLE bronze.erd_cust_az12(
	cid VARCHAR(50),
	bdate DATE,
	gen VARCHAR(50)
);

CREATE TABLE bronze.erd_loc_a101(
	cid VARCHAR(50),
	cntry VARCHAR(50)
);

CREATE TABLE bronze.erd_px_cat_g1v2(
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50)
)
