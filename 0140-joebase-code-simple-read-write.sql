
/*
** JOEBASE - The Action Figure Database
** joebase-code-simple-read-write: This file creates the basic insert procedures and read functions
**   for Joebase tables.
**
** Copyright Leonard Armstrong, 2018
** IST659
*/

USE joebase;
GO

----------------------------------------------------------------------------------------------------
-- ACTION FIGURE TABLES ROUTINES
----------------------------------------------------------------------------------------------------

-- Insert a new action_figure record
CREATE OR ALTER PROCEDURE insertActionFigureRecord (
	@action_figure_description	NVARCHAR(1024),
	@storage_location			VARCHAR(32),
	@likeness					NVARCHAR(128),
	@product_id					INT) AS
BEGIN
	INSERT INTO action_figure (action_figure_description, storage_location, likeness, product_id)
	VALUES (@action_figure_description, ISNULL(@storage_location, 'TBD'), @likeness, @product_id);

	RETURN SCOPE_IDENTITY();
END; -- insertActionFigureRecord
GO

-- Update the likeness value of an existing action figure
CREATE OR ALTER PROCEDURE updateActionFigureLikeness (
	@action_figure_id INT, 
	@likeness NVARCHAR(128)) AS
BEGIN
	UPDATE action_figure
	SET action_figure.likeness = @likeness 
	WHERE action_figure.action_figure_id = @action_figure_id;

	RETURN SCOPE_IDENTITY();
END; -- updateActionFigureLikeness
GO

-- Update the storage location value of an existing action figure
CREATE OR ALTER PROCEDURE updateActionFigureStorageLocation (
	@action_figure_id INT, 
	@storage_location NVARCHAR(32)) AS
BEGIN
	UPDATE action_figure
	SET action_figure.storage_location = @storage_location 
	WHERE action_figure.action_figure_id = @action_figure_id;

	RETURN SCOPE_IDENTITY();
END; -- updateActionFigureStorageLocation
GO

-- Get the count of action figures for an input product
-- This function implements the Number of Figures attribute from the conceptual model's Product
-- entity
CREATE OR ALTER FUNCTION getCountOfActionFiguresInProduct (@product_id INT)
RETURNS INT AS
BEGIN
	DECLARE @result INT;

	SELECT @result = COUNT(action_figure.product_id)
	FROM action_figure
	WHERE action_figure.product_id = @product_id;

	RETURN @result;
END; -- getCountOfActionFiguresInProduct 
GO

----------------------------------------------------------------------------------------------------
-- GENRE TABLE ROUTINES
----------------------------------------------------------------------------------------------------

-- Insert a new genre record
CREATE OR ALTER PROCEDURE insertGenreRecord (@genre_name NVARCHAR(128)) AS
BEGIN
	INSERT INTO genre (genre_name)
	VALUES (@genre_name);
	RETURN SCOPE_IDENTITY();
END; -- insertGenreRecord
GO

-- Get the ID of a genre record given an input genre name.
-- This is non-problematic since genre name must be unique.
CREATE OR ALTER FUNCTION getGenreID (@genre_name NVARCHAR(128))
RETURNS INT AS
BEGIN
	DECLARE @result INT;

	SELECT @result = genre.genre_id
	FROM genre
	WHERE genre.genre_name = @genre_name;

	RETURN @result;
END; -- getGenreID
GO

----------------------------------------------------------------------------------------------------
-- MANUFACTURER TABLE ROUTINES
----------------------------------------------------------------------------------------------------

-- Insert a new manufacturer record
CREATE OR ALTER PROCEDURE insertManufacturerRecord (@manufacturer_name NVARCHAR(128)) AS
BEGIN
	INSERT INTO manufacturer (manufacturer_name)
	VALUES (@manufacturer_name);
	RETURN SCOPE_IDENTITY();
END; -- insertManufacturerRecord
GO

-- Get the ID of a manufacturer record given an input manufacturer name.
-- This is non-problematic since manufacturer name must be unique.
CREATE OR ALTER FUNCTION getManufacturerID (@manufacturer_name NVARCHAR(128))
RETURNS INT AS
BEGIN
	DECLARE @result INT;

	SELECT @result = manufacturer.manufacturer_id
	FROM manufacturer
	WHERE manufacturer.manufacturer_name = @manufacturer_name;

	RETURN @result;
END; -- getManufacturerID
GO

----------------------------------------------------------------------------------------------------
-- PRODUCT_TYPE ROUTINES
----------------------------------------------------------------------------------------------------

-- Get a product_id given an input product name and manufacturer_id.
-- This is non-problematic as the manufacturer_id/problem_name combination must be unique.
CREATE OR ALTER FUNCTION getProductID (@product_name NVARCHAR(128), @manufacturer_id INT)
RETURNS INT AS
BEGIN
	DECLARE @result INT;

	SELECT @result = product.product_id
	FROM product
	WHERE product.product_name = @product_name
		AND product.manufacturer_id = @manufacturer_id;

	RETURN @result;
END; -- getProductTypeID
GO

-- Insert a new product record
CREATE OR ALTER PROCEDURE insertProductRecord (
	@product_name				NVARCHAR(128),
	@product_type				INT,
	@product_description		NVARCHAR(1024),
	@year_of_release			INT,
	@purchase_price				DECIMAL(19,4),
	@purchased_from_retailer_id INT,
	@exclusive_to_retailer_id	INT,
	@manufacturer_id			INT
	) AS
BEGIN
	INSERT INTO product (product_name, product_type_id, product_description, year_of_release,
		purchase_price, purchased_from_retailer_id, exclusive_to_retailer_id, manufacturer_id)
	VALUES(@product_name, @product_type, @product_description, @year_of_release, @purchase_price,
		@purchased_from_retailer_id, @exclusive_to_retailer_id, @manufacturer_id);

	RETURN SCOPE_IDENTITY();
END; -- insertProductRecord
GO

-- Update the exclusive_to_retailer_id using a retailer_id as input.
CREATE OR ALTER PROCEDURE updateProductExclusiveRetailerByRetailerID (
	@product_id INT,
	@exclusive_to_retailer_id INT) AS
BEGIN
	UPDATE product
	SET product.exclusive_to_retailer_id = @exclusive_to_retailer_id
	WHERE product.product_id = @product_id;

	RETURN SCOPE_IDENTITY();
END; -- updateProductExclusiveRetailerByID
GO

-- Update the exclusive_to_retailer_id using a retailer_name as input.
CREATE OR ALTER PROCEDURE updateProductExclusiveRetailerByRetailerName (
	@product_id INT,
	@exclusive_to_retailer_name NVARCHAR(128)) AS
BEGIN
	DECLARE @result INT;
	DECLARE @exclusive_retailer_id INT = dbo.getRetailerId(@exclusive_to_retailer_name);
    EXECUTE @result = dbo.updateProductExclusiveRetailerByRetailerID @product_id = @product_id, @exclusive_to_retailer_id = @exclusive_retailer_id;
	RETURN @result;
END; -- updateProductExclusiveRetailerByID
GO

----------------------------------------------------------------------------------------------------
-- PRODUCT GENRE ROUTINES
----------------------------------------------------------------------------------------------------

-- Insert a new product genre record.
CREATE OR ALTER PROCEDURE insertProductGenreRecord (@product_id INT, @genre_id INT) AS
BEGIN
	INSERT INTO product_genre (product_id, genre_id)
	VALUES (@product_id, @genre_id);

	RETURN SCOPE_IDENTITY();
END; -- insertProductGenreRecord
GO


----------------------------------------------------------------------------------------------------
-- PRODUCT_SERIES ROUTINES
----------------------------------------------------------------------------------------------------

-- Insert a new product_series record, linking a product to a series.
CREATE OR ALTER PROCEDURE insertProductSeriesRecord (@product_id INT, @series_id INT) AS
BEGIN
	INSERT INTO product_series(product_id, series_id)
	VALUES (@product_id, @series_id);

	RETURN SCOPE_IDENTITY();
END; -- insertProductSeriesRecord
GO

----------------------------------------------------------------------------------------------------
-- PRODUCT_TYPE ROUTINES
----------------------------------------------------------------------------------------------------

-- Get a product_type ID given an input product_type name.
-- This is non-problematic as problem_type_name must be unique.
CREATE OR ALTER FUNCTION getProductTypeID (@product_type_name NVARCHAR(128))
RETURNS INT AS
BEGIN
	DECLARE @result INT;

	SELECT @result = product_type.product_type_id
	FROM product_type
	WHERE product_type.product_type_name = @product_type_name;

	RETURN @result;
END; -- getProductTypeID
GO

----------------------------------------------------------------------------------------------------
-- RETAILER ROUTINES
----------------------------------------------------------------------------------------------------

-- Get a retailer_id given an input reatiler_name.
-- This is non-problematic as retailer_name must be unique.
CREATE OR ALTER FUNCTION getRetailerID (@retailer_name NVARCHAR(128))
RETURNS INT AS
BEGIN
	DECLARE @result INT;

	SELECT @result = retailer.retailer_id
	FROM retailer
	WHERE retailer.retailer_name = @retailer_name;

	RETURN @result;
END; -- getRetailerID
GO

----------------------------------------------------------------------------------------------------
-- SERIES
----------------------------------------------------------------------------------------------------

-- Insert a new series record for a specific manufacturer.
CREATE OR ALTER PROCEDURE insertSeriesRecord (
	@manufacturer_id INT, 
	@series_name NVARCHAR(128),
	@series_description NVARCHAR(1024)) AS
BEGIN
	INSERT INTO series (manufacturer_id, series_name, series_description)
	VALUES (@manufacturer_id, @series_name, @series_description);
	RETURN SCOPE_IDENTITY();
END; -- insertGenreRecord
GO

-- Get a series_id given an input manufacturer (ID) and series name.
-- This is non-problematic as series name must be unique for a given manufacturer.
CREATE OR ALTER FUNCTION getSeriesID (@manufacturer_ID INT, @series_name NVARCHAR(128))
RETURNS INT AS
BEGIN
	DECLARE @result INT;

	SELECT @result = series.series_id
	FROM series
	WHERE  series.manufacturer_id = @manufacturer_id
		AND series.series_name = @series_name;

	RETURN @result;
END; -- getRetailerID
GO
