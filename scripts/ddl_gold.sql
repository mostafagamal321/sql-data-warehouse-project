/*
=====================================================================================================================================
DDL Script: create Gold Views
=====================================================================================================================================
Script purpose :
This script creates views for the gold layer in the data warehouse.
the gold layer represents the final dimension and fact tables (star schema )

each view performs transformation and combines data from the silver layer 
to roduce a clean , enrinched and business ready dataset.

USAGE :
-- these views can be queried directly for analytics and reporting 
=====================================================================================================================================
*/
------------------------------------------------- 1.   VIEW : dim_customers --------------------------------------------------------
CREATE OR REPLACE VIEW gold.dim_customers AS

SELECT ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS Customer_key
	, ci.cst_id AS customer_id 
	, ci.cst_key AS	customer_number
	, ci.cst_firstname AS first_name 
	, ci.cst_lastname  AS last_name
	, ci.cst_martial_status  AS marital_status 
	, CASE WHEN ci.cst_gndr != caz.gen THEN cst_gndr 
		ELSE COALESCE(caz.gen , 'NA')
  	   END AS gender
	, a1.cntry AS Country
	, caz.bdate  AS birth_date
	, ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS caz
ON ci.cst_key = caz.cid 
LEFT JOIN silver.erp_loc_a101 AS a1
ON Ci.cst_key = a1.cid;


-----------------------------------------------------------------------------------------------------------
------------------------------------------------- 2.   VIEW : dim_products ---------------------------------------------------
CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pi.prd_start_dt , pi.prd_key) AS product_key ,
	Pi.prd_id  AS product_id , 
	pi.prd_key AS Product_number ,
	pi.prd_nm AS product_name,
							CASE 					WHEN pi.cat_id != pcg.id THEN cat_id 
													ELSE COALESCE(pcg.id , 'NA')END AS 
	category_id ,
	pcg.cat AS category,
	pcg.subcat AS sub_category,
	pcg.maintenance AS Maintenance,
	pi.prd_cost AS Cost ,
	pi.prd_line AS product_line,
	pi.prd_start_dt  AS start_date
FROM silver.crm_prd_info AS pi
LEFT JOIN silver.erp_px_cat_g1v2 AS pcg
ON pi.cat_id = pcg.id
WHERE prd_end_dt IS NULL;



-----------------------------------------------------------------------------------
------------------------------------------------- 3.   VIEW : fact_sales ----------------------------------------------------

CREATE VIEW gold.fact_sales AS 
SELECT 
sd.sls_ord_num AS order_number , 
pr.product_key , 
cu.customer_key , 
sd.sls_order_dt AS order_date ,
sd.sls_ship_dt AS shipping_date , 
sd.sls_due_dt AS due_date , 
sd.sls_sales AS Sales_amount ,
sd.sls_quantity AS Quantity ,
sd.sls_price AS price 
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;

