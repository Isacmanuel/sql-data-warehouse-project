/*
===============================================================================
Stored procedure: Loand bronze layer (Source -> Bronze)
===============================================================================
Script purpose: 
This stored procedure loads data into the bronze schema from external csv files.
It performs the following actions:
-Truncates the bronze tables before loading data.
-Uses the Bulk Insert command to load data from csv files to bronze tables.

Parameters: 
None.
This stored procedure does not accept any parameter or return any values.

Usage example:
EXEC bronze.load_bronze;
=================================================================================

*/
CREATE or ALTER PROCEDURE bronze.load_bronze AS
DECLARE @start_time DATETIME,@end_time DATETIME, @start_time_total DATETIME,@end_time_total DATETIME;

BEGIN
BEGIN TRY
SET @start_time_total = GETDATE();
PRINT '=========================================================================';
PRINT 'Loading the bronze layer';
PRINT '=========================================================================';

PRINT 'Loading CRM tables';
PRINT '--------------------------------------------------------------------------';

SET @start_time = GETDATE();
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info 
FROM '/var/opt/mssql/data/cust_info.csv'
WITH(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
SET @end_time = GETDATE();
PRINT '>>Load duration: ' + CAST (DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
PRINT '---------------------------------------------------------------------------'


SET @start_time = GETDATE();
TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
FROM '/var/opt/mssql/data/prd_info.csv'
WITH(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
SET @end_time = GETDATE();
PRINT '>>Load duration: ' + CAST (DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
PRINT '----------------------------------------------------------------------------'


SET @start_time = GETDATE();
TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT bronze.crm_sales_details
FROM '/var/opt/mssql/data/sales_details.csv'
WITH(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
SET @end_time = GETDATE();
PRINT '>>Load duration: ' + CAST (DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
PRINT '-----------------------------------------------------------------------------'

PRINT 'Loading ERP tables';
PRINT '-----------------------------------------------------------------------------';

SET @start_time = GETDATE();
TRUNCATE TABLE bronze.erp_cust_az12;
BULK INSERT bronze.erp_cust_az12
FROM '/var/opt/mssql/data/CUST_AZ12.csv'
WITH(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
SET @end_time = GETDATE();
PRINT '>>Load duration: ' + CAST (DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
PRINT '-----------------------------------------------------------------------------'


SET @start_time = GETDATE();
TRUNCATE TABLE bronze.erp_loc_a101;
BULK INSERT bronze.erp_loc_a101
FROM '/var/opt/mssql/data/loc_a101.csv'
WITH(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
SET @end_time = GETDATE();
PRINT '>>Load duration: ' + CAST (DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
PRINT '-------------------------------------------------------------------------------'


SET @start_time = GETDATE();
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
BULK INSERT bronze.erp_px_cat_g1v2
FROM '/var/opt/mssql/data/PX_CAT_G1V2.csv'
WITH(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
SET @end_time = GETDATE();
PRINT '>>Load duration: ' + CAST (DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
PRINT '------------------------------------------------------------------------------';


SET @end_time_total = GETDATE();
PRINT 'Loanding bronze layer is completed';
PRINT '>>Load duration of the whole process: ' + CAST (DATEDIFF(second, @start_time_total,@end_time_total) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------------------------------------------------------';

END TRY
 BEGIN CATCH
  PRINT'==============================================================================';
  PRINT'Error occured during loading bronze layer';
  PRINT'Error message '+ ERROR_MESSAGE();
  PRINT'Error message '+ CAST (ERROR_NUMBER() AS NVARCHAR);
  PRINT'Error message '+ CAST (ERROR_STATE() AS NVARCHAR);
  PRINT'==============================================================================';
 END CATCH
END

