/*
   May 28, 20188:37:39 PM
   User: 
   Server: LA-PARALLELSWIN
   Database: joebase
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.temp_action_figures_v2 ADD
	product_table_key int NULL
GO
ALTER TABLE dbo.temp_action_figures_v2
	DROP COLUMN F17, SQL
GO
ALTER TABLE dbo.temp_action_figures_v2 SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
