
/*
** JOEBASE - The Action Figure Database
** joebase-create-userss: This file creates logins and users for Joebase.
**
** Copyright Leonard Armstrong, 2018
** IST659
*/

----------------------------------------------------------------------------------------------------
-- JOEBASE_ADMIN
-- Priviledged administrative user. Expected to have expanded priviledges as time goes on.
----------------------------------------------------------------------------------------------------

IF NOT EXISTS (
	SELECT *
	FROM [sys].[server_principals]
	WHERE [sys].[server_principals].[name] = N'joebase_admin'
		AND [sys].[server_principals].[type] = 'S')
BEGIN
	PRINT 'Creating LOGIN for joebase_admin...'
	USE [master]
	CREATE LOGIN [joebase_admin] WITH PASSWORD=N'HWvpNyF2t7', DEFAULT_DATABASE=[joebase], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

	PRINT 'Creating USER for joebase_admin...'
	USE [joebase]
	CREATE USER [joebase_admin] FOR LOGIN [joebase_admin] WITH DEFAULT_SCHEMA=[dbo]

	PRINT 'Establishing GRANTS for joebase_admin...'
	GRANT SELECT
	ON product_details
	TO [joebase_admin];

	GRANT SELECT
	ON product_genre_details
	TO [joebase_admin];

	GRANT SELECT
	ON product_series_details
	TO [joebase_admin];
END
ELSE
	PRINT 'User joebase_admin already exists';

----------------------------------------------------------------------------------------------------
-- JOEBASE_USER
-- General user. Expected to have limited priviledges as time goes on.
----------------------------------------------------------------------------------------------------

IF NOT EXISTS (
	SELECT *
	FROM [sys].[server_principals]
	WHERE [sys].[server_principals].[name] = N'joebase_user'
		AND [sys].[server_principals].[type] = 'S')
BEGIN
	PRINT 'Creating LOGIN for joebase_user...'
	USE [master]
	CREATE LOGIN [joebase_user] WITH PASSWORD=N'HWvpNyF2t7', DEFAULT_DATABASE=[joebase], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

	PRINT 'Creating USER for joebase_user...'
	USE [joebase]
	CREATE USER [joebase_user] FOR LOGIN [joebase_user] WITH DEFAULT_SCHEMA=[dbo]

	PRINT 'Establishing GRANTS for joebase_user...'
	GRANT SELECT
	ON product_details
	TO [joebase_user];

	GRANT SELECT
	ON product_genre_details
	TO [joebase_user];

	GRANT SELECT
	ON product_series_details
	TO [joebase_user];
END
ELSE
	PRINT 'User joebase_user already exists';