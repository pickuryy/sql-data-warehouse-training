BULK INSERT	bronze.crm_cust_info
FROM 'E:\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)

BULK INSERT	bronze.crm_prd_info
FROM 'E:\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)

BULK INSERT	bronze.crm_sales_details
FROM 'E:\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)

BULK INSERT	bronze.erd_cust_az12
FROM 'E:\datasets\source_erp\CUST_AZ12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)

BULK INSERT	bronze.erd_loc_a101
FROM 'E:\datasets\source_erp\LOC_A101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)

BULK INSERT	bronze.erd_px_cat_g1v2
FROM 'E:\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)
