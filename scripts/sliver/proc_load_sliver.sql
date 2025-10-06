/*
==========================================================================
Stored Procedure : Load Sliver Layer (Bronze --> Sliver)
==========================================================================
Sript Purpose:
	This stored procedure performs the ETL (Extract , Transform , Load) Porcess to
	populate the 'sliver' schema tables from the 'bronze' schema.
	Actions performed :
	- Truncates Sliver Tables
	-Insert Transformed and cleansed data from bronze into sliver tables.
	parameters:
	None , this stored procedure doesn't accept any parameters or return any values.

	Usage example :
	CALL sliver.load_sliver; 
	======================================================================
*/

CREATE OR REPLACE PROCEDURE sliver.load_sliver() 

AS $$
DECLARE
	start_date TIMESTAMP;
	end_date  TIMESTAMP;
	phase_start_date TIMESTAMP;
	phase_end_date TIMESTAMP; 
	BEGIN
	RAISE NOTICE '========================================================================================';
	RAISE NOTICE '========================================================================================';
	RAISE NOTICE '                     INSERTING DATA INTO SLIVER LAYER AFTER                             ';
	RAISE NOTICE '========================================================================================';
	RAISE NOTICE '========================================================================================';
	start_date := CURRENT_TIMESTAMP;
	-------------------------------------------------------------------------------------------------------
	phase_start_date := CURRENT_TIMESTAMP;
	---------------------------------- Insert Data into : crm_cust_info -----------------------------------
	
	RAISE NOTICE '>>Truncating Table : sliver.crm_cust_info';
	TRUNCATE TABLE sliver.crm_cust_info;
	RAISE NOTICE '>>Insert Data into table : sliver.crm_cust_info';
	INSERT INTO sliver.crm_cust_info (
		cst_id, 
		cst_key, 
		cst_firstname, 
		cst_lastname, 
		cst_martial_status, 
		cst_gndr, 
		cst_create_date
	)
	SELECT 
		cst_id, 
		cst_key, 
		TRIM(cst_firstname) AS cst_firstname, 
		TRIM(cst_lastname) AS cst_lastname, 
		CASE 
			WHEN UPPER(TRIM(cst_martial_status)) = 'M' THEN 'Married'
			WHEN UPPER(TRIM(cst_martial_status)) = 'S' THEN 'Single'
			ELSE 'NA'
		END AS cst_martial_status, 
		CASE 
			WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			ELSE 'NA'
		END AS cst_gndr,
		cst_create_date
	FROM (
		SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
		FROM bronze.crm_cust_info
	) t
	WHERE flag_last = 1;
	phase_end_date := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_date;
    RAISE NOTICE 'End time: %', phase_end_date;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_date - Phase_start_date));
    RAISE NOTICE '======================================================================';
	
	-----------------------------------------------------------------------------------------------------
	phase_start_date := CURRENT_TIMESTAMP;	
	---------------------------------- Insert Data into : crm_prd_info -----------------------------------
	RAISE NOTICE '>>Truncating Table : sliver.crm_prd_info';
	TRUNCATE TABLE sliver.crm_prd_info;
	RAISE NOTICE '>>Inserting data into table : sliver.crm_prd_info';
	INSERT INTO sliver.crm_prd_info (
		prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
	)
	SELECT
		prd_id, 
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
		SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
		prd_nm,
		COALESCE(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'NA'
		END AS prd_line, 
		CAST(prd_start_dt AS DATE) AS prd_start_dt, 
		CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS DATE) AS prd_end_dt
	FROM bronze.crm_prd_info;
	phase_end_date := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_date;
    RAISE NOTICE 'End time: %', phase_end_date;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_date - Phase_start_date));
    RAISE NOTICE '======================================================================';
	------------------------------------------------------------------------------------------------------
	phase_start_date := CURRENT_TIMESTAMP;
	---------------------------------- Insert Data into : crm_sales_details -----------------------------------
	RAISE NOTICE '>>Truncating Table : sliver.crm_sales_details';
	TRUNCATE TABLE sliver.crm_sales_details;
	RAISE NOTICE '>>Inserting Data Into Table : sliver.crm_sales_details';
	INSERT INTO sliver.crm_sales_details (
		sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
	)
	SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE 
			WHEN sls_order_dt = 0 OR LENGTH(ABS(sls_order_dt)::TEXT) != 8 THEN NULL
			ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END AS sls_order_dt,
		CASE 
			WHEN sls_ship_dt = 0 OR LENGTH(ABS(sls_ship_dt)::TEXT) != 8 THEN NULL
			ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE 
			WHEN sls_due_dt = 0 OR LENGTH(ABS(sls_due_dt)::TEXT) != 8 THEN NULL
			ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt,
		CASE 
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,
		sls_quantity,
		CASE 
			WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_price
	FROM bronze.crm_sales_details;
	phase_end_date := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_date;
    RAISE NOTICE 'End time: %', phase_end_date;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_date - Phase_start_date));
    RAISE NOTICE '======================================================================';
	------------------------------------------------------------------------------------------------------
	phase_start_date := CURRENT_TIMESTAMP;
	---------------------------------- Insert Data into : erp_cust_az12 -----------------------------------
	RAISE NOTICE '>>Truncating Table : sliver.erp_cust_az12';
	TRUNCATE TABLE sliver.erp_cust_az12;
	RAISE NOTICE '>>Inserting data into table : sliver.erp_cust_az12';
	INSERT INTO sliver.erp_cust_az12 (cid, bdate, gen)
	SELECT 
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) ELSE cid END AS cid,
		CASE WHEN bdate > NOW() THEN NULL ELSE bdate END AS bdate,
		CASE 
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			ELSE 'n/a'
		END AS gen
	FROM bronze.erp_cust_az12;
	phase_end_date := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_date;
    RAISE NOTICE 'End time: %', phase_end_date;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_date - Phase_start_date));
    RAISE NOTICE '======================================================================';
	------------------------------------------------------------------------------------
	phase_start_date := CURRENT_TIMESTAMP;
	---------------------------------- Insert Data into : erp_loc_a101 -----------------------------------
	RAISE NOTICE '>>Truncating Table : sliver.erp_loc_a101';
	TRUNCATE TABLE sliver.erp_loc_a101;
	RAISE NOTICE '>>Inserting Data Into : sliver.erp_loc_a101';
	INSERT INTO sliver.erp_loc_a101 (cid, cntry)
	SELECT 
		REPLACE(cid, '-', '') AS cid,
		CASE 
			WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			ELSE TRIM(cntry)
		END AS cntry
	FROM bronze.erp_loc_a101;
	phase_end_date := CURRENT_TIMESTAMP;
	RAISE NOTICE '>>======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_date;
    RAISE NOTICE 'End time: %', phase_end_date;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_date - Phase_start_date));
    RAISE NOTICE '>>======================================================================';
	------------------------------------------------------------------------------------
	phase_start_date := CURRENT_TIMESTAMP;
	---------------------------------- Insert Data into : erp_px_g1v2 -----------------------------------
	RAISE NOTICE '>>Truncating Table : sliver.erp_px_cat_g1v2';
	TRUNCATE TABLE sliver.erp_px_cat_g1v2;
	RAISE NOTICE '>>Inserting Data Into : sliver.erp_px_cat_g1v2';
	INSERT INTO sliver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
	SELECT id, cat, subcat, maintenance
	FROM bronze.erp_px_cat_g1v2;
	phase_end_date := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_date;
    RAISE NOTICE 'End time: %', phase_end_date;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_date - Phase_start_date));
    RAISE NOTICE '======================================================================';
	--------------------------------------------------------------------------------------------------------------------
	 
	 RAISE NOTICE '======================================================================';
	 RAISE NOTICE '======================================================================';
	 RAISE NOTICE '                           FULL LAYER HAS BEEN LOADED                 '; 
	 RAISE NOTICE '======================================================================';
	 RAISE NOTICE '======================================================================';
	 RAISE NOTICE '>> LOAD INFORMATION ';
	RAISE NOTICE '======================================================================';
	end_date := CURRENT_TIMESTAMP;
    RAISE NOTICE 'Start time: %', start_date;
    RAISE NOTICE 'End time: %', end_date;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (end_date - start_date));
    RAISE NOTICE '======================================================================';
	
END;
$$ LANGUAGE plpgsql;

CALL sliver.load_sliver()


