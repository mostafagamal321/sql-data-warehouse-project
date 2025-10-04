/* 
=================================================================================
=================================================================================
                      CREATE DATABASE AND SCHEMAS 
=================================================================================
=================================================================================
SCRIPT Purpose ?: 
This script creates a new database named 'Datawarehouse' after checking if it already exists.
if the database exists , it is dropped and recreated. additionally , the script sets up three schemas
within the database : bronze , sliver  , gold 


WARNING !!!!!!!: 
Running this script will drop the enitre database 'DataWarehouse' if it exists
all data in the database will permanently deleted . make sure you have a proper 
backups before running this script 

*/

DO
$$
BEGIN
   IF EXISTS (SELECT FROM pg_database WHERE datname = 'datawarehouse') THEN
      PERFORM pg_terminate_backend(pid)
      FROM pg_stat_activity
      WHERE datname = 'datawarehouse';
   END IF;
END
$$;

-- Drop the database if it exists
DROP DATABASE IF EXISTS datawarehouse;

-- Create the database again
CREATE DATABASE datawarehouse;
-- Drop the database if it exists
DROP DATABASE IF EXISTS datawarehouse;

-- Create the database again
CREATE DATABASE datawarehouse;



-- creating the bronze layer of the arch ---
CREATE SCHEMA Bronze;
-- creating the sliver layer of the arch ---
CREATE SCHEMA Sliver;
-- creating the gold layer of the arch ---
CREATE SCHEMA Gold;
