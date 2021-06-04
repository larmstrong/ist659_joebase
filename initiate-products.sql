/****** Script for SelectTopNRows command from SSMS  ******/

DECLARE @id				INT,
	@v_manufacturer		NVARCHAR(256),
	@v_product			NVARCHAR(1024),
	@v_location			NVARCHAR(256),
	@v_num_figures		DECIMAL(38,0),
    @v_series_1			NVARCHAR(256),
    @v_series_2			NVARCHAR(256),
	@v_series_3			NVARCHAR(256),
	@v_series_4			NVARCHAR(256),
	@v_genre_1			NVARCHAR(256),
	@v_genre_2			NVARCHAR(256),
	@v_likeness			NVARCHAR(256),
	@v_year				DECIMAL(38,0),
    @v_retailer			NVARCHAR(256),
    @v_purchase_price	DECIMAL(19,4),
    @v_exclusive		NVARCHAR(256),
	@v_description		NVARCHAR(1024);

-- We know all products entered at this time will be of type 1:6 action figure so let's just set that pointer now.
DECLARE @v_product_type_1_6_action_figure_id INT = NULL;
SELECT @v_product_type_1_6_action_figure_id = product_type.product_type_id
	FROM product_type
	WHERE product_type.product_type_name = '1:6 figure'

-- Declare primary cursor to pull data from a temp table created from the original Excel data file.
DECLARE csr_action_figures CURSOR FOR
	SELECT id, Producer, Product,
		FORMAT([Location], '00.00')	AS cv_figure_location, -- Location is pulled in as an integer value but should be a two-digit-DOT-two-digit character string.
		[# Figs], [Series 1], [Series 2], [Series 3], [Series 4], [Primary Genre], [Secondary Genre], [Likeness], [Year of Release],
		[Purchased From], [Purchase Price]	AS cv_purchase_price, [Exclusive To], [Keywords]
	FROM temp_action_figures_v2;

-- Clean out the product and action_figure tables
DELETE action_figure;
DELETE product;

-- Initialize the cursor...
DECLARE @row INT = 0;
OPEN csr_action_figures
FETCH NEXT 
	FROM csr_action_figures	
	INTO @id, @v_manufacturer, @v_product, @v_location, @v_num_figures,
		@v_series_1, @v_series_2, @v_series_3, @v_series_4, @v_genre_1, @v_genre_2,
		@v_likeness, @v_year, @v_retailer, @v_purchase_price, @v_exclusive, @v_description;

-- Loop through all rows in the Excel sheet...
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @row = @row  + 1
		PRINT 'Processing row ( ' + FORMAT(@row, '####') + '): ' + @v_product;

		-- Get manufacturer key
		DECLARE @v_manufacturer_id INT;
		SELECT @v_manufacturer_id = manufacturer.manufacturer_id
		FROM manufacturer
		WHERE manufacturer.manufacturer_name = @v_manufacturer;
		PRINT '    Manufacturer: ' + FORMAT(@v_manufacturer_id, '####') + ' (' + @v_manufacturer + ')';

		-- Get up to 4 series keys
		DECLARE @v_series_id_1 INT = NULL, @v_series_id_2 INT = NULL, @v_series_id_3 INT = NULL, @v_series_id_4 INT = NULL;

		IF (@v_series_1 IS NOT NULL)
			BEGIN
				SELECT @v_series_id_1 = series_id
				FROM series
				WHERE series.series_name = @v_series_1;
				PRINT '    Series 1: ' + FORMAT(@v_series_id_1, '####') + ' (' + @v_series_1 + ')';
			END;
	
		IF (@v_series_2 IS NOT NULL)
			BEGIN
				SELECT @v_series_id_2 = series_id
				FROM series
				WHERE series.series_name = @v_series_2;
				PRINT '    Series 2: ' + FORMAT(@v_series_id_2, '####') + ' (' + @v_series_2 + ')';
			END;

		IF (@v_series_3 IS NOT NULL)
			BEGIN
				SELECT @v_series_id_3 = series_id
				FROM series
				WHERE series.series_name = @v_series_3;
				PRINT '    Series 3: ' + FORMAT(@v_series_id_3, '####') + ' (' + @v_series_3 + ')';
			END;

		IF (@v_series_4 IS NOT NULL)
			BEGIN
				SELECT @v_series_id_4 = series_id
				FROM series
				WHERE series.series_name = @v_series_4;
				PRINT '    Series 4: ' + FORMAT(@v_series_id_4, '####') + ' (' + @v_series_4 + ')';
			END;

		-- Get up to 2 genre keys
		DECLARE @v_genre_id_1 INT = NULL, @v_genre_id_2 INT = NULL;

		IF (@v_genre_1 IS NOT NULL)
			BEGIN
				SELECT @v_genre_id_1 = genre_id
				FROM genre
				WHERE genre.genre_name = @v_genre_1;
				PRINT '    Genre 1: ' + FORMAT(@v_genre_id_1, '####') + ' (' + @v_genre_1 + ')';
			END;
	
		IF (@v_genre_2 IS NOT NULL)
			BEGIN
				SELECT @v_genre_id_2 = genre_id
				FROM genre
				WHERE genre.genre_name = @v_genre_2;
				PRINT '    Genre 2: ' + FORMAT(@v_genre_id_2, '####') + ' (' + @v_genre_2 + ')';
			END;

		-- Get the retailer key
		DECLARE @v_retailer_id INT = NULL;
		IF (@v_retailer IS NOT NULL)
			BEGIN
				SELECT @v_retailer_id = retailer.retailer_id
				FROM retailer
				WHERE retailer.retailer_name = @v_retailer;
				PRINT '    Retailer: ' + FORMAT(@v_retailer_id, '####') + ' (' + @v_retailer + ')';
			END;

		DECLARE @v_exclusive_retailer_id INT = NULL;
		IF (@v_exclusive IS NOT NULL)
		BEGIN
			SELECT @v_exclusive_retailer_id = retailer.retailer_id
			FROM retailer
			WHERE retailer.retailer_name = @v_exclusive;
			PRINT '    Exclusive to: ' + FORMAT(@v_exclusive_retailer_id, '####') + ' (' + @v_exclusive + ')';
		END

		-- Ready to create the product and action_figure tables

		-- Create the product table entry
		INSERT INTO product(product_name, product_type_id, product_description, year_of_release, purchase_price, purchased_from_retailer_id, manufacturer_id, exclusive_to_retailer_id)
		VALUES(@v_product, @v_product_type_1_6_action_figure_id, @v_description, IIF(@v_year = 0, NULL, @v_year), @v_purchase_price, @v_retailer_id, @v_manufacturer_id, @v_exclusive_retailer_id);
		-- Determine the newly created key
		DECLARE @v_product_id INT = SCOPE_IDENTITY();
		-- Save it in temp_action_figures_2
		--UPDATE temp_action_figures_v2 
	
		-- Create 1 entry for each duplicate figure for the product.
		DECLARE @i INT = 0;
		-- Loop throught the number of duplicate figures.
		WHILE @i < @v_num_figures
		BEGIN
			SET @i = @i + 1;
			DECLARE @af_descr_supplement NVARCHAR(255) = NULL;
			-- Supplement the action figure description with a "Figure x of y" line of text.
			IF @v_num_figures > 1 
			BEGIN
				SET @af_descr_supplement = @v_description;
				IF @v_description IS NOT NULL
					SET @af_descr_supplement = @af_descr_supplement + CHAR(13);
				SET @af_descr_supplement = @af_descr_supplement + ('Figure ' + FORMAT(@i, '##') + ' of ' + FORMAT(@v_num_figures, '##') + ' replica products.')
			END; 
			-- Insert into the action figure table.
			INSERT INTO action_figure (action_figure_description, storage_location, likeness, product_id)
			VALUES (@af_descr_supplement, @v_location, @v_likeness, @v_product_id);
		END;

		FETCH NEXT 
			FROM csr_action_figures	
			INTO @id, @v_manufacturer, @v_product, @v_location, @v_num_figures,
				@v_series_1, @v_series_2, @v_series_3, @v_series_4, @v_genre_1, @v_genre_2,
				@v_likeness, @v_year, @v_retailer, @v_purchase_price, @v_exclusive, @v_description;

	END;

CLOSE csr_action_figures;
DEALLOCATE csr_action_figures;
