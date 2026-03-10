	/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.
===============================================================================
*/
	
	use DatawareHouse;
	GO

	EXEC bronze.load_bronze;
	GO

	CREATE OR ALTER PROCEDURE bronze.load_bronze 
	AS 
	BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 

	BEGIN TRY
				SET @batch_start_time = GETDATE();

				PRINT '============================================================================';
				PRINT ' Loading Bronze Layer';
				PRINT '============================================================================';

				IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
					DROP TABLE bronze.crm_cust_info;

				CREATE TABLE bronze.crm_cust_info(
				cust_id				INT,
				cst_key				VARCHAR(50),
				cst_firstname		VARCHAR(50),
				cst_lastname		VARCHAR(50),
				cst_material_status VARCHAR(50),
				cst_gndr			VARCHAR(50),
				cst_create_date		DATE
				);

	 
	

				PRINT '-----------------------------------------------------------------------------';
				PRINT 'Loading CRM Tables';
				PRINT '-----------------------------------------------------------------------------';

				IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
					DROP TABLE  bronze.crm_prd_info;
				
				SET @start_time = GETDATE();

				CREATE TABLE bronze.crm_prd_info(
				prd_id			INT,
				prd_key			NVARCHAR(50),
				prd_nm			NVARCHAR(50),
				prd_cost		INT,
				prd_line		NVARCHAR(50),
				prd_start_dt	DATETIME,
				prd_end_dt		DATETIME
				);


				IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
					DROP TABLE bronze.crm_sales_details;

				CREATE TABLE bronze.crm_sales_details(
				sls_ord_num		NVARCHAR(50),
				sls_prd_key		NVARCHAR(50),
				sls_cust_id		INT,
				sls_order_dt	INT,
				sls_ship_dt		INT,
				sls_due_dt		INT,
				sls_sales		INT,
				sls_quantity	INT,
				sls_price		INT
				);

				SET @end_time = GETDATE();


				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				PRINT '-----------------------------------------------------------------------------';
				PRINT 'Loading ERP Tables';
				PRINT '-----------------------------------------------------------------------------';

				IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
					DROP TABLE bronze.erp_loc_a101;

				CREATE TABLE bronze.erp_loc_a101(
					cid		NVARCHAR(50),
					cntry	NVARCHAR(50)
				);

				SET @end_time = GETDATE();


				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

				PRINT '>> -------------';

				SET @start_time = GETDATE();

				IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
					DROP TABLE bronze.erp_cust_az12;


				CREATE TABLE bronze.erp_cust_az12(
					cid			NVARCHAR(50),
					bdate		DATE,
					gen			nVARCHAR(50)
				);


				IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
					DROP TABLE bronze.erp_px_cat_g1v2;


				CREATE TABLE bronze.erp_px_cat_g1v2(
					id			NVARCHAR(50),
					cat			NVARCHAR(50),
					subcat		NVARCHAR(50),
					maintenance NVARCHAR(50)
				);
	
				SET @end_time = GETDATE();


				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();

				PRINT '>> Truncating Table: bronze.crm_cust_info';

				TRUNCATE TABLE bronze.crm_cust_info

				PRINT '>>Inserting Table: bronze.crm_cust_info'

				BULK INSERT bronze.crm_cust_info
				FROM 'C:\Users\justi\OneDrive\Desktop\datasets\source_crm\cust_info.csv'
				WITH(

					FIRSTROW =			2,
					FIELDTERMINATOR =	',',
					TABLOCK
				);

				SET @end_time = GETDATE();


				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();

				PRINT '>> Truncating Table: bronze.crm_prd_info';

				TRUNCATE TABLE bronze.crm_prd_info 
	
				PRINT '>>Inserting Table:bronze.crm_prd_info';

				BULK INSERT bronze.crm_prd_info
				FROM 'C:\Users\justi\OneDrive\Desktop\datasets\source_crm\prd_info.csv'
				WITH(
		
					FIRSTROW =			2,
					FIELDTERMINATOR =	',',
					TABLOCK
				);

				SET @end_time = GETDATE();

	
				PRINT '>> Truncating Table:bronze.crm_sales_details';
	
				TRUNCATE TABLE bronze.crm_sales_details

				PRINT '>>Inserting Table:bronze.crm_sales_details';

				BULK INSERT bronze.crm_sales_details
				FROM 'C:\Users\justi\OneDrive\Desktop\datasets\source_crm\sales_details.csv'
				WITH(

					FIRSTROW =			2,
					FIELDTERMINATOR =	',',
					TABLOCK
				);

				SET @end_time = GETDATE();


				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();


				PRINT '>> Truncating Table:bronze.erp_cust_az12';

				TRUNCATE TABLE bronze.erp_cust_az12

	
				PRINT '>>Inserting Table:bronze.erp_cust_az12';

				BULK INSERT bronze.erp_cust_az12
				FROM 'C:\Users\justi\OneDrive\Desktop\datasets\source_erp\cust_az12.csv'
				WITH(

					FIRSTROW =			2,
					FIELDTERMINATOR =	',',
					TABLOCK
				);

				SET @end_time = GETDATE();


				PRINT '>> Truncating Table:bronze.erp_loc_a101'; 
	
				TRUNCATE TABLE bronze.erp_loc_a101

				PRINT '>>Inserting Table:bronze.erp_loc_a101';

				BULK INSERT bronze.erp_loc_a101
				FROM 'C:\SQLData\LOC_A101.csv'
				WITH(

					FIRSTROW = 2,
					FIELDTERMINATOR = ',',
					TABLOCK
				);

				SET @end_time = GETDATE();

					
				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();


				PRINT '>> Truncating Table:bronze.erp_px_cat_g1v2';

				TRUNCATE TABLE bronze.erp_px_cat_g1v2

				BULK INSERT bronze.erp_px_cat_g1v2
				FROM 'C:\SQLData\PX_CAT_G1V2.csv'
				WITH(

					FIRSTROW = 2,
					FIELDTERMINATOR = ',',
					TABLOCK
					);

				SET @end_time = GETDATE();

	END TRY
	 BEGIN CATCH 

	 PRINT '=====================================================================================';
	 PRINT 'ERROR OCCURED DURING LOADING THE LAODING OF BRONZE LAYER';
	 PRINT 'Error Message' + ERROR_MESSAGE();
	 PRINT 'Error Message' + CAST(Error_Number() AS NVARCHAR);
	 PRINT 'Error Message' + CAST(Error_State() AS NVARCHAR);	 
	 PRINT '=====================================================================================';

	END CATCH

END






