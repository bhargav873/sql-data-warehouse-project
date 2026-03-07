-- Create a new database

CREATE DATABASE DataWareHouse;

-- Start using newly created database 

USE DataWareHouse;

-- Create our layers schema (bronze, silver, and gold)

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

-- The schemas are now created. You can verify by navigating to datawareHouse>securities>schema.
