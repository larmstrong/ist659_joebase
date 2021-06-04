
----------------------------------------------------------------------------------------------------
-- MASTER BUILD SCRIPT
-- This is a SQL Command Mode script that is the master control program (apologies to TRON) for 
-- building the Joebase database.
----------------------------------------------------------------------------------------------------

-- Set the location of the Joebase code home.
:setvar path "X:\Education\Syracuse\2018-0406-IST-659-DataAdminConcepts_DBMgmnt\joebase\Joebase"

----------------------------------------------------------------------------------------------------
-- DATABASE CREATION SECTION
-- Create the primay database and table structures, users, and views
----------------------------------------------------------------------------------------------------
PRINT('Creating the database definition...')
:r $(path)\0110-joebase-create-db.sql
GO

PRINT('Creating database views...')
:r $(path)\0120-joebase-create-views.sql
GO

PRINT('Creating users...')
:r $(path)\0130-joebase-create-users.sql
GO

----------------------------------------------------------------------------------------------------
-- CODE CREATION SECTION
-- Create the stored procedures and functions for Joebase
----------------------------------------------------------------------------------------------------

PRINT ('Creating Joebase code...')
:r $(path)\joebase-code-simply-read-write.sql
GO

----------------------------------------------------------------------------------------------------
-- DATA INITIALIZATION SECTION
-- Initialize the data in the database
--
-- NOTE: In addition to the data loaded and/or manipulated in the scripts below, over 450 raw data
-- records from an Excel file were loaded into SQL Server via SQL Server Management Studio's Import
-- Data Wizard. These were stored in a new, joebase temporary table "temp_action_figure_v2". 
----------------------------------------------------------------------------------------------------

-- Create the lookup table of known manufacturers.
PRINT 'Creating manufacturer lookup table...'
:r $(path)\0210-joebase-manufacturer-initialize.sql
GO

-- Create the lookup table of all known retailers. 
-- Note: This is the union of known retailers from which I have purchased a product and the union
-- of retailers who have had exclusive product sales.
PRINT 'Creating retailer lookup table...'
:r $(path)\0220-joebase-retailer-initialize.sql
GO

-- Create the genere lookup table 
PRINT 'Creating genre lookup table...'
:r $(path)\0230-joebase-genre-initialize.sql
GO

-- Create the product type lookup table
PRINT 'Creating product type lookup table...'
:r $(path)\0240-joebase-producttype-initialize.sql
GO

-- Create the series lookup table, including the manufacturer-series relationships.
PRINT 'Creating series and manufacturer\_series lookup tables...'
:r $(path)\0250-joebase-series-initialize.sql
GO

-- Create the remaining tables: product, action-figure, etc. These tables are driven from analysis
-- of the imported temp_action_figure_v2 table. 
PRINT 'Creating the products and putting it all together.'
:r $(path)\0260-joebase-product-initialize.sql
GO
