/*
=================================================================================================================
DDL Script : Create Bronze schemas Tables
=================================================================================================================
SCRIPT PURPOSE :
	this script creates tables in the 'bronze' schema , dropping existing tables if they already exists.
	Run this script to re-define the DDL Structure of the 'bronze' tables 
================================================================================================================	

/*=================== CRM Source Tables =============================*/

DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT ,
	cst_key VARCHAR(50) ,
	cst_firstname VARCHAR(50) ,
	cst_lastname VARCHAR(50) ,
	cst_martial_status VARCHAR(50) , 
	cst_gndr VARCHAR(50) , 
	cst_create_date DATE
);
--  prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt
-- I just copied the col sequences and names from the csv file to make sure there is no mistake in the naming
-- also make sure to follow the conventinal naming of the table by startin with the source system

DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
prd_id INT ,
prd_key VARCHAR(150) , 
prd_nm VARCHAR(100) , 
prd_cost FLOAT , 
prd_line VARCHAR(150) ,
prd_start_dt DATE ,
prd_end_dt DATE
);

-- sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
sls_ord_num CHARACTER VARYING (50) ,
sls_prd_key CHARACTER VARYING (50) , 
sls_cust_id INT ,
sls_order_dt TEXT ,
sls_ship_dt TIMESTAMP ,
sls_due_dt TIMESTAMP ,
sls_sales INT ,
sls_quantity INT, 
sls_price INT
);


/*=================== ERP Source Tables =============================*/
-- CID,BDATE,GEN
DROP TABLE IF EXISTS bronze.erp_CUST_AZ12;
CREATE TABLE bronze.erp_CUST_AZ12 (
CID VARCHAR(50), 
BDATE DATE , 
GEN CHAR(10)
);

--CID,CNTRY
DROP TABLE IF EXISTS bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101 (
CID VARCHAR(50) ,
CNTRY VARCHAR(50)
);

-- ID,CAT,SUBCAT,MAINTENANCE
DROP TABLE IF EXISTS bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2 (
ID VARCHAR(30),
CAT VARCHAR(50),
SUBCAT VARCHAR(80), 
MAINTENANCE BOOLEAN
);
 
