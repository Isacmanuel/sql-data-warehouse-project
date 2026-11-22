TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info 
FROM '/var/opt/mssql/data/cust_info.csv'
WITH(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
