/*
=================================================================================================================
DDL Script : Create Bronze schemas Tables
=================================================================================================================
SCRIPT PURPOSE :
	this script creates tables in the 'bronze' schema , dropping existing tables if they already exists.
	Run this script to re-define the DDL Structure of the 'bronze' tables 
================================================================================================================	



 	========================== FULL DATA LOAD USING TRUNCATE & COPY (INSERT) =============================== 
 
 */

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time timestamp;
    end_time timestamp;
	Phase_start_time Timestamp;
	phase_end_time Timestamp;
BEGIN
    RAISE NOTICE '======================================================================';
    RAISE NOTICE '                 Loading DATA INSIDE BRONZE LAYER                     ';
    RAISE NOTICE '======================================================================';
	start_time := CURRENT_TIMESTAMP;
-----------------------------------------------------------------------------------------------------	
    Phase_start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> TRUNCATING TABLE bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;

    RAISE NOTICE '>> INSERTING INTO TABLE bronze.crm_cust_info';
    EXECUTE format(
        'COPY bronze.crm_cust_info FROM %L WITH (FORMAT csv, HEADER true, DELIMITER '','')',
        'E:\Career\DWH_PROJECT\source_crm\cust_info.csv'
    );
	phase_end_time := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_time;
    RAISE NOTICE 'End time: %', phase_end_time;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_time - Phase_start_time));
    RAISE NOTICE '======================================================================';
-----------------------------------------------------------------------------------------------------------
	Phase_start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> TRUNCATING TABLE bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;

    RAISE NOTICE '>> INSERTING INTO TABLE bronze.crm_prd_info';
    EXECUTE format(
        'COPY bronze.crm_prd_info FROM %L WITH (FORMAT csv, HEADER true, DELIMITER '','')',
        'E:\Career\DWH_PROJECT\source_crm\prd_info.csv'
    );
	phase_end_time := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_time;
    RAISE NOTICE 'End time: %', phase_end_time;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_time - Phase_start_time));
    RAISE NOTICE '======================================================================';
--------------------------------------------------------------------------------------------------------
	Phase_start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> TRUNCATING TABLE bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;

    RAISE NOTICE '>> INSERTING INTO TABLE bronze.crm_sales_details';
    EXECUTE format(
        'COPY bronze.crm_sales_details FROM %L WITH (FORMAT csv, HEADER true, DELIMITER '','')',
        'E:\Career\DWH_PROJECT\source_crm\sales_details.csv'
    );
	phase_end_time := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_time;
    RAISE NOTICE 'End time: %', phase_end_time;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_time - Phase_start_time));
    RAISE NOTICE '======================================================================';
---------------------------------------------------------------------------------------------------------
	Phase_start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> TRUNCATING TABLE bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;

    RAISE NOTICE '>> INSERTING INTO TABLE bronze.erp_cust_az12';
    EXECUTE format(
        'COPY bronze.erp_cust_az12 FROM %L WITH (FORMAT csv, HEADER true, DELIMITER '','')',
        'E:\Career\DWH_PROJECT\source_erp\cust_az12.csv'
    );
	phase_end_time := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_time;
    RAISE NOTICE 'End time: %', phase_end_time;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_time - Phase_start_time));
    RAISE NOTICE '======================================================================';
	----------------------------------------------------------------------------------------------------------
   	Phase_start_time := CURRENT_TIMESTAMP;
   	RAISE NOTICE '>> TRUNCATING TABLE bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;
    RAISE NOTICE '>> INSERTING INTO TABLE bronze.erp_loc_a101';
    EXECUTE format(
        'COPY bronze.erp_loc_a101 FROM %L WITH (FORMAT csv, HEADER true, DELIMITER '','')',
        'E:\Career\DWH_PROJECT\source_erp\loc_a101.csv'
    );
	phase_end_time := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_time;
    RAISE NOTICE 'End time: %', phase_end_time;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_time - Phase_start_time));
    RAISE NOTICE '======================================================================';
	------------------------------------------------------------------------------------------------------
	Phase_start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> TRUNCATING TABLE bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    RAISE NOTICE '>> INSERTING INTO TABLE bronze.erp_px_cat_g1v2';
    EXECUTE format(
        'COPY bronze.erp_px_cat_g1v2 FROM %L WITH (FORMAT csv, HEADER true, DELIMITER '','')',
        'E:\Career\DWH_PROJECT\source_erp\px_cat_g1v2.csv'
    );
	phase_end_time := CURRENT_TIMESTAMP;
	RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', Phase_start_time;
    RAISE NOTICE 'End time: %', phase_end_time;
    RAISE NOTICE 'Total duration for this phase: % seconds', EXTRACT(EPOCH FROM (phase_end_time - Phase_start_time));
    RAISE NOTICE '======================================================================';
    RAISE NOTICE '>> TRUNCATING TABLE bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
-----------------------------------------------------------------------------------------------------------
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '======================================================================';
    RAISE NOTICE 'Start time: %', start_time;
    RAISE NOTICE 'End time: %', end_time;
    RAISE NOTICE 'Total duration for loading all tables: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '======================================================================';
END;
$$;

-- Now you can call the stored proecdure Using CALL 

CALL bronze.load_bronze()
