DROP TABLE gold.dim_cust
CREATE TABLE gold.dim_cust(
	cust_id VARCHAR(50),
	cust_number  VARCHAR(50),
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	marital_status VARCHAR(50),
	gender VARCHAR(50),
	create_date DATE,
	birth_date DATE,
	country VARCHAR(50)
)


DROP TABLE gold.dim_prod
CREATE TABLE gold.dim_prod(
	cat_id VARCHAR(50),
	prod_id VARCHAR(50),
	category VARCHAR(50),
	subcategory VARCHAR(50),
	prod_name VARCHAR(50),
	line VARCHAR(50),
	cost INT,
	prod_start_date DATE,
	prod_end_date DATE
)

CREATE TABLE gold_fact_sales(
	ord_num VARCHAR(50),
	prod_id VARCHAR(50),
	cust_id VARCHAR(50),
	order_date DATE,
	ship_date DATE,
	due_date DATE,
	sales INT,
	quantity INT,
	price INT
)
