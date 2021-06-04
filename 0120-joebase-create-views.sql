
/*
** JOEBASE - The Action Figure Database
** joebase-create-views: This file creates common data views for Joebase.
**
** Copyright Leonard Armstrong, 2018
** IST659
*/

USE joebase;
GO

----------------------------------------------------------------------------------------------------
-- This section defines actual database views.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- VIEW: product_details
-- Provides a "human_readable" version of a product record, substituting names for id values
-- Used to populate the following joebase application components: (1) the master list in the
-- products tab; (2) the Current Product detail block of the Products tab.

CREATE OR ALTER VIEW product_details AS
	SELECT
		product.product_id,
		manufacturer.manufacturer_name,
		product.product_name,
		product_type.product_type_name,
		product.product_description,
		product.year_of_release,
		FORMAT(product.purchase_price, '$ ###.00') [Cost],
		purchase_retailer.retailer_name [Purchase Retailer Name],
		exclusive_retailer.retailer_name [Exclusive Retailer Name],
		dbo.getCountOfActionFiguresInProduct(product.product_id) [# Figures in Product]
	FROM product
		JOIN product_type ON product.product_type_id = product_type.product_type_id
		LEFT JOIN manufacturer ON product.manufacturer_id = manufacturer.manufacturer_id
		LEFT JOIN retailer purchase_retailer ON product.purchased_from_retailer_id = purchase_retailer.retailer_id
		LEFT JOIN retailer exclusive_retailer ON product.exclusive_to_retailer_id = exclusive_retailer.retailer_id;
GO

SELECT * FROM product_details
GO

----------------------------------------------------------------------------------------------------
-- VIEW: genre_details
-- Provides a list of all genres along with the count of action figures for each genre.
-- Used to populate the joebase application genre tab.


CREATE OR ALTER VIEW genre_details AS
	SELECT genre.genre_id as 'Genre ID', 
		genre.genre_name as 'Genre Name', 
		COUNT(product_genre.genre_id) AS 'Count of Products'
	FROM genre
	LEFT JOIN product_genre ON genre.genre_id = product_genre.genre_id
	GROUP BY genre.genre_id, genre.genre_name;
GO

SELECT *
FROM genre_details;
GO

----------------------------------------------------------------------------------------------------
-- VIEW: product_action_figures
-- Provides a "human_readable" version of a product record with its associated action figures.
-- Used to populate the following joebase application components: (1) the action figures detail
-- list in the products tab; 


CREATE OR ALTER VIEW product_action_figure AS
	SELECT
		product.product_id,
		manufacturer.manufacturer_name,
		product.product_name,
		product_type.product_type_name,
		product.product_description,
		product.year_of_release,
		dbo.getCountOfActionFiguresInProduct(product.product_id) [# Figures in Product],
		action_figure.action_figure_id,
		action_figure.action_figure_description,
		action_figure.likeness,
		action_figure.storage_location
	FROM product
		JOIN product_type ON product.product_type_id = product_type.product_type_id
		LEFT JOIN manufacturer ON product.manufacturer_id = manufacturer.manufacturer_id
		JOIN action_figure ON product.product_id = action_figure.product_id
GO

SELECT * FROM product_action_figure;
GO

----------------------------------------------------------------------------------------------------
-- VIEW: all_product_series_details
-- Provides a list-based alternateive to the parameterized product_series_details view that give the
-- entire list of all series for all products.

CREATE OR ALTER VIEW all_product_series_details AS
	SELECT product.product_id,
		product.product_name,
		product.product_description, 
		manufacturer.manufacturer_name, 
		product_series.product_series_id,
		series.series_id,
		series.series_name
	FROM product
	JOIN product_series ON product.product_id = product_series.product_id
	JOIN series ON product.manufacturer_id = series.manufacturer_id
		AND product_series.series_id = series.series_id
	JOIN manufacturer on product.manufacturer_id = manufacturer.manufacturer_id;
GO

SELECT * FROM all_product_series_details;
GO

----------------------------------------------------------------------------------------------------
-- VIEW: all_product_series_details
-- Provides a list-based alternateive to the parameterized product_series_details view that give the
-- entire list of all series for all products.

CREATE OR ALTER VIEW all_manufacturer_series_details AS
	SELECT series.manufacturer_id,
		manufacturer.manufacturer_name,
		series.series_id,
		series.series_name,
		series.series_description
	FROM series
	JOIN manufacturer ON series.manufacturer_id = manufacturer.manufacturer_id;
GO

SELECT * FROM all_manufacturer_series_details;
GO

----------------------------------------------------------------------------------------------------
-- VIEW: office_storage_locations
-- Provides a figures and their office storage locations. Figures are only returned if they are on
--  display in the office.

CREATE OR ALTER VIEW office_storage_locations AS
	SELECT *
	FROM product_action_figure
	WHERE product_action_figure.storage_location IS NOT NULL
		AND ISNUMERIC(LEFT(product_action_figure.storage_location, 1)) = 0
		AND product_action_figure.storage_location LIKE '%.%';
GO

SELECT * FROM office_storage_locations;
GO

----------------------------------------------------------------------------------------------------
-- This section defines parmaterized database views. Since, in fact, T-SQL does not support
-- parameterized views, a function returning a TABLE is used.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

-- FUNCTION (Serving as a parameterized VIEW): product_genre_details
-- Provides a "human_readable" list of genres for a given input product_id
-- Used to populate the Genres panel of the Joebase application Products tab.

CREATE OR ALTER FUNCTION product_genre_details (@product_id INT) 
RETURNS TABLE AS
RETURN
(
	SELECT genre.genre_id, genre.genre_name
	FROM product_genre
	JOIN genre ON product_genre.genre_id = genre.genre_id
	WHERE product_genre.product_id = @product_id
);
GO

SELECT * FROM product_genre_details(12);
GO

----------------------------------------------------------------------------------------------------

-- FUNCTION (Serving as a parameterized VIEW): product_series_details
-- Provides a "human_readable" list of series for a given input product_id

CREATE OR ALTER FUNCTION product_series_details (@product_id INT) 
RETURNS TABLE AS
RETURN
(
	SELECT series.series_id, series.series_name
	FROM product_series
	JOIN series ON product_series.series_id = series.series_id
	WHERE product_series.product_id = @product_id
)
GO

SELECT * FROM product_series_details(160)
GO

----------------------------------------------------------------------------------------------------
