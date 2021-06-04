
USE [joebase]
GO
-- Create a master view of the data to be processed
CREATE OR ALTER VIEW temp_action_figure_data_master AS
	SELECT -- Product fields
		temp_action_figures_v2.id									temp_af_id,
		temp_action_figures_v2.product								product_name, 
		temp_action_figures_v2.Keywords								product_description, 
		temp_action_figures_v2.[Year of Release]					year_of_release,
		temp_action_figures_v2.[Purchase Price]						purchase_price,
		dbo.getRetailerID(temp_action_figures_v2.[Purchased From])	purchased_from_retailer_id,
		temp_action_figures_v2.[Purchased From]						purchased_from_retailer_name,
		dbo.getRetailerID(temp_action_figures_v2.[Exclusive To])	exclusive_to_retailer_id,
		temp_action_figures_v2.[Exclusive To]						exclusive_to_retailer_name,
		dbo.getManufacturerID(temp_action_figures_v2.Producer)		manufacturer_id,
		temp_action_figures_v2.Producer								manufacturer_name,
		-- Action figure fields
		temp_action_figures_v2.[# Figs]								number_of_figures,
		FORMAT(temp_action_figures_v2.Location, '00.00')			storage_location,
		temp_action_figures_v2.Likeness								likeness,
		-- Series fields
		temp_action_figures_v2.[Series 1]							series_name_1,
		temp_action_figures_v2.[Series 2]							series_name_2,
		temp_action_figures_v2.[Series 3]							series_name_3,
		temp_action_figures_v2.[Series 4]							series_name_4,
		-- Genre fields
		temp_action_figures_v2.[Primary Genre]						genre_name_1,
		temp_action_figures_v2.[Secondary Genre]					genre_name_2
	FROM temp_action_figures_v2;
GO

----------------------------------------------------------------------------------------------------
-- VARIABLE DECLARATIONS

-- Determine and save the product type to be used for all action figure products being inserted.
DECLARE @action_figure_product_type_id INT = dbo.getProductTypeID('1:6 figure');

-- Temporary variables
DECLARE @id								INT;
DECLARE @product_name					NVARCHAR(128);
DECLARE @product_description			NVARCHAR(1024);
DECLARE @year_of_release				INT;
DECLARE @purchase_price					DECIMAL(19,4);
DECLARE @purchased_from_retailer_id		INT;
DECLARE @purchased_from_retailer_name	NVARCHAR(128);
DECLARE @exclusive_to_retailer_id		INT;
DECLARE @exclusive_to_retailer_name		NVARCHAR(128);
DECLARE @manufacturer_id				INT;
DECLARE @manufacturer_name				NVARCHAR(128);
DECLARE @af_number_of_figures			INT;
-- Action figure related fields
DECLARE @af_storage_location			VARCHAR(32);
DECLARE @af_likeness					NVARCHAR(128);
-- Series related fields
DECLARE @series_name_1					NVARCHAR(128);
DECLARE @series_id_1					INT;
DECLARE @series_name_2					NVARCHAR(128);
DECLARE @series_id_2					INT;
DECLARE @series_name_3					NVARCHAR(128);
DECLARE @series_id_3					INT;
DECLARE @series_name_4					NVARCHAR(128);
DECLARE @series_id_4					INT;
-- Genre-related fields
DECLARE @genre_name_1					NVARCHAR(128);
DECLARE @genre_id_1						INT;
DECLARE @genre_name_2					NVARCHAR(128);
DECLARE @genre_id_2						INT;

----------------------------------------------------------------------------------------------------
DECLARE csr_TempActionFigure CURSOR FOR
	SELECT
		-- product fields
		temp_af_id, product_name,  product_description,  year_of_release, purchase_price,
		purchased_from_retailer_id, purchased_from_retailer_name,
		exclusive_to_retailer_id, exclusive_to_retailer_name, 
		manufacturer_id, manufacturer_name,
		-- action_figure fields
		number_of_figures, storage_location, likeness,
		-- series fields
		series_name_1, series_name_2, series_name_3, series_name_4,
		-- genre fields
		genre_name_1, genre_name_2
	FROM temp_action_figure_data_master;

-- Everything is declared, let's clear out the tables being inserted into
DELETE product_series;
DELETE product_genre;
DELETE action_figure;
DELETE product;


-- Loop through the lines items in the temporary imported Excel table
OPEN csr_TempActionFigure;
FETCH NEXT
FROM csr_TempActionFigure
INTO -- Product fields
	@id, @product_name, @product_description, @year_of_release, @purchase_price,
	@purchased_from_retailer_id, @purchased_from_retailer_name, 
	@exclusive_to_retailer_id, @exclusive_to_retailer_name, 
	@manufacturer_id, @manufacturer_name, 
	-- Action figure fields
	@af_number_of_figures, @af_storage_location, @af_likeness,
	-- Series fields
	@series_name_1, @series_name_2, @series_name_3, @series_name_4,
	-- Genre fields
	@genre_name_1, @genre_name_2;

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT(FORMAT(@id, '###') + @manufacturer_name + ' ' + @product_name);

	-- Create the product record
	EXECUTE @id = dbo.insertProductRecord @product_name, @action_figure_product_type_id,
		@product_description, @year_of_release, @purchase_price, 
		@purchased_from_retailer_id, @exclusive_to_retailer_id, @manufacturer_id;

	-- Now create the related action_figure record(s)
	DECLARE @i INT = 1
	WHILE @i <= @af_number_of_figures
	BEGIN
		DECLARE @action_figure_description NVARCHAR(1024) = NULL;
		IF @af_number_of_figures > 1
			SET @action_figure_description = 'Figure ' + FORMAT(@i, '##') + ' of ' + FORMAT(@af_number_of_figures, '##') + ' duplicate figures'
		EXECUTE insertActionFigureRecord @action_figure_description, @af_storage_location, @af_likeness, @id; 
		SET @i = @i + 1;
	END; -- While <= @number of figures

	-- Do series link
	SET @series_id_1 = dbo.getSeriesID(@manufacturer_id, @series_name_1);
	IF (@series_id_1 IS NOT NULL)
		EXECUTE dbo.insertProductSeriesRecord @id, @series_id_1;
	SET @series_id_2 = dbo.getSeriesID(@manufacturer_id, @series_name_2);
	IF (@series_id_2 IS NOT NULL)
		EXECUTE dbo.insertProductSeriesRecord @id, @series_id_2;
	SET @series_id_3 = dbo.getSeriesID(@manufacturer_id, @series_name_3);
	IF (@series_id_3 IS NOT NULL)
		EXECUTE dbo.insertProductSeriesRecord @id, @series_id_3;
	SET @series_id_4 = dbo.getSeriesID(@manufacturer_id, @series_name_4);
	IF (@series_id_4 IS NOT NULL)
		EXECUTE dbo.insertProductSeriesRecord @id, @series_id_4;

	-- Do genre link
	SET @genre_id_1 = dbo.getGenreID(@genre_name_1);
	IF (@genre_id_1 IS NOT NULL)
		EXECUTE dbo.insertProductGenreRecord @id, @genre_id_1;
	SET @genre_id_2 = dbo.getGenreID(@genre_name_2);
	IF (@genre_id_2 IS NOT NULL)
		EXECUTE dbo.insertProductGenreRecord @id, @genre_id_2;

	FETCH NEXT
	FROM csr_TempActionFigure
	INTO -- Product fields
		@id, @product_name, @product_description, @year_of_release, @purchase_price,
		@purchased_from_retailer_id, @purchased_from_retailer_name, 
		@exclusive_to_retailer_id, @exclusive_to_retailer_name, 
		@manufacturer_id, @manufacturer_name, 
		-- Action figure fields
		@af_number_of_figures, @af_storage_location, @af_likeness,
		-- Series fields
		@series_name_1, @series_name_2, @series_name_3, @series_name_4,
		-- Genre fields
		@genre_name_1, @genre_name_2;

END; -- While Fetch

CLOSE csr_TempActionFigure;
DEALLOCATE csr_TempActionFigure;
GO

SELECT * 
FROM product
GO

SELECT *
FROM action_figure
GO

SELECT manufacturer.manufacturer_name, product.product_name, series.series_name
FROM product
	JOIN product_series ON product.product_id = product_series.product_id
	JOIN series ON product_series.series_id = series.series_id
	JOIN manufacturer ON product.manufacturer_id = manufacturer.manufacturer_id;
GO

SELECT product.product_name, genre.genre_name
FROM product
	JOIN product_genre ON product.product_id = product_genre.product_id
	JOIN genre ON product_genre.genre_id = genre.genre_id
GO

