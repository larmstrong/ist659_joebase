DECLARE @all_values_known BIT = 0;

IF (@all_values_known = 0)
	BEGIN
		SELECT * FROM manufacturer WHERE manufacturer_name like '%Toys Era%';
		SELECT * FROM retailer WHERE retailer_name like '%Sideshow%';
		SELECT * FROM genre
		WHERE genre_name like '%comics%'
			OR genre_name like '%tv%'
			OR genre_name like '%marv%';
		SELECT * FROM series
		WHERE manufacturer_id = 27
	END
ELSE
	BEGIN
		-- Initialize list parameters
		------------------------------
		-- Genres
		DECLARE @genres TABLE ( row_id INT NOT NULL PRIMARY KEY IDENTITY(1,1), genre_name NVARCHAR(128) );
		INSERT INTO @genres VALUES ('Sci-Fi'), ('TV/Film'), ('Marvel'), ('X-Men');
		DECLARE @genre_count INT = @@ROWCOUNT;
		PRINT('There are ' + CAST(@genre_count AS NVARCHAR) + ' genres to process,');

		-- Series
		DECLARE @series_list TABLE ( row_id INT NOT NULL PRIMARY KEY IDENTITY(1,1), series_id INT);
		--INSERT INTO @series_list VALUES (101), (158), (4160);
		DECLARE @series_count INT = @@ROWCOUNT;
		PRINT('There are ' + CAST(@series_count AS NVARCHAR) + ' series to process,');

		-- Initialize scalar parameters
		------------------------------
		DECLARE @manufacturer_name		   NVARCHAR(128)  = 'Toys Era'
		DECLARE @retailer_name             NVARCHAR(128)  = 'NeoGEEK Toys';
		DECLARE @prod_name                 NVARCHAR(128)  = 'The Cyclopstech';
		DECLARE @prod_description          NVARCHAR(1024) = 'Unlicensed Scott Scott Summers (Cyclops) from "X-Men: Apocalypse".'
		DECLARE @release_year              INT            = 2020;
		DECLARE @purchase_price            DECIMAL(19,4)  = 179.99;
		DECLARE @storage_loc               VARCHAR(32)    = 'desk.right.top.lower';
		DECLARE @action_figure_description NVARCHAR(1024) = 'Cyclops, Scott Summers from "X-Men: Apocalypse"'
		DECLARE @likeness_str              NVARCHAR(128)  = 'Tye Sheridan'; 

		-----------------------------------------------------------------------
		-- Process Item
		-----------------------------------------------------------------------

		DECLARE @manufacturer_id INT = dbo.getManufacturerID(@manufacturer_name);
		PRINT('Manufacturer_id for ' + @manufacturer_name + ' = ' + CAST(@manufacturer_id AS NVARCHAR(16)))

		DECLARE @retailer_id INT = dbo.getRetailerID(@retailer_name);
		PRINT('Retailer_id for ' + @retailer_name + ' = ' + CAST(@retailer_id AS NVARCHAR(16)))

		DECLARE @new_product_id INT;
		EXECUTE @new_product_id = NewOneSixthScaleActionFigureProduct
			@product_name = @prod_name,
			@product_description = @prod_description,
			@manufacturer_id = @manufacturer_id,
			@year_of_release = @release_year,
			@purchase_price = @purchase_price,
			@purchased_from_retailer_id = @retailer_id,
			@exclusive_to_retailer_id = NULL,
			@action_figure_description = @action_figure_description,
			@storage_location = @storage_loc,
			@likeness = @likeness_str;
		PRINT(@prod_name + ' product_id = ' + CAST(@new_product_id AS NVARCHAR(16)));

		DECLARE @i INT = 0;
		DECLARE @gname NVARCHAR(128);
		WHILE (@i < @genre_count)
		BEGIN
			SET @i = @i + 1;
			SELECT @gname = genre_name FROM @genres WHERE row_id = @i;
			DECLARE @g_id INT = dbo.getGenreID(@gname);
			PRINT('Genre_id for ' + @gname + ' = ' + CAST(@g_id AS NVARCHAR(16)));
			EXECUTE insertProductGenreRecord @product_id = @new_product_id, @genre_id = @g_id;
		END;

		DECLARE @j INT = 0;
		DECLARE @s_id INT;
		WHILE (@j < @series_count)
		BEGIN
			SET @j = @j + 1;
			SELECT @s_id = series_id FROM @series_list WHERE row_id = @j;
			EXECUTE insertProductSeriesRecord @product_id = @new_product_id, @series_id = @s_id;
		END;
	END; -- IF

GO
