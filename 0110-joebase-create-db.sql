
/*
** JOEBASE - The Action Figure Database
** joebase-create-db: This file created the primary database table structures for Joebase.
**
** Copyright Leonard Armstrong, 2018
** IST659
*/

USE joebase;
GO

----------------------------------------------------------------------------------------------------
-- DROP Section
-- Ensure the database is cleared of any residual data, tables, etc. before recreating.
----------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS product_product_image;
GO

DROP TABLE IF EXISTS action_figure_genre;
GO

DROP TABLE IF EXISTS action_figure;
GO

DROP TABLE IF EXISTS product_series;
GO

DROP TABLE IF EXISTS product_genre
GO

DROP TABLE IF EXISTS product;
GO

DROP TABLE IF EXISTS product_type;
GO

DROP TABLE IF EXISTS product_image;
GO

DROP TABLE IF EXISTS genre;
GO

DROP TABLE IF EXISTS series;
GO

DROP TABLE IF EXISTS retailer;
GO

DROP TABLE IF EXISTS manufacturer;
GO

----------------------------------------------------------------------------------------------------
-- CREATE Section
-- Create all tables and table constraints requrired for Joebase
----------------------------------------------------------------------------------------------------

-- manufacturer: Lookup table for all producers of action figure products. 
CREATE TABLE manufacturer
(
	manufacturer_id		INT IDENTITY PRIMARY KEY,		-- DB identifier of record
	manufacturer_name	NVARCHAR(128) UNIQUE NOT NULL	-- Human identifier of record
);
GO

-- retailer: Lookup table for all retailers of action figure products. 
CREATE TABLE retailer
(
	retailer_id		INT IDENTITY PRIMARY KEY,			-- DB identifier of record
	retailer_name	NVARCHAR(128) UNIQUE NOT NULL,		-- Human identifier of record
	retailer_url	VARCHAR(2048)						-- Online presence of retailer
);
GO

-- Primary classification system of action figure products according to the theme(s) they portray
CREATE TABLE genre
( 
	genre_id	INT IDENTITY PRIMARY KEY,				-- DB identifier of record
	genre_name	NVARCHAR(128) UNIQUE NOT NULL			-- Human identifier of record
);
GO

-- Elexctronic images of action figure products
CREATE TABLE product_image
(
	product_image_id			INT IDENTITY PRIMARY KEY,
														-- DB identifier of record
	url							VARCHAR(2048) NOT NULL,	-- Electronic "home" of image
	product_image_description	NVARCHAR(1024),			-- Human-readable description of image content
	product_image_credit		NVARCHAR(1024)			-- Acknowledgement of image producer/owner/copyright holder.
);
GO

-- Type classification of products (scale, figure vs. accessory set, vehicle, etc.)
CREATE TABLE product_type
(
	product_type_id          INT IDENTITY PRIMARY KEY,	-- DB identifier of record
	product_type_name        VARCHAR(128) UNIQUE NOT NULL,
														-- Human identifier of record
	product_type_description NVARCHAR(1024)				-- Extended description of the product type
);
GO

-- Series classifier for products. Products may be part of multiple series. Series may also include brand labels.
CREATE TABLE series
(
	series_id			INT IDENTITY PRIMARY KEY,		-- DB identifier of series
	manufacturer_id		INT NOT NULL FOREIGN KEY REFERENCES manufacturer(manufacturer_id),
														-- Manufaturer owner of series
	series_name			NVARCHAR(128) NOT NULL,			-- Human name of series
	series_description	NVARCHAR(1024),					-- Extended description of series

	CONSTRAINT u1_series UNIQUE (series_name, manufacturer_id)
														-- Each series name must be unique to its manufacturer
);
GO

-- Primary listing of products
CREATE TABLE product
(
	product_id					INT IDENTITY PRIMARY KEY,
														-- DB identifier of product record
	product_name				NVARCHAR(128) NOT NULL,	-- Human identifer or product record
	product_type_id				INT FOREIGN KEY REFERENCES product_type(product_type_id),
														-- Type of product
	product_description			NVARCHAR(1024),			-- Extended description and notes about product
	year_of_release				INT,					-- Year product was released for sale by its manufacturer
	purchase_price				DECIMAL(19,4),			-- Price the owner paid for the product
	purchased_from_retailer_id	INT FOREIGN KEY REFERENCES retailer(retailer_id),
														-- Retailer from whom the owner purchased the product
	manufacturer_id				INT FOREIGN KEY REFERENCES manufacturer(manufacturer_id),
														-- Product's manufacturer
	exclusive_to_retailer_id	 INT FOREIGN KEY REFERENCES retailer(retailer_id),
														-- Retailer that initially had exclusive sales rights to the product

	CONSTRAINT u1_product UNIQUE (product_name, manufacturer_id)
														-- Allow only one unique product name from a manufacturer. 
														-- If a manufacturer produces two products with the same name we
														--  require that the product name have something unique to distinguish it
														-- in the data record. If we have duplicates (which is the case for my
														-- collection) the we will have one product with multiple figures.
														-- The figures' descriptions will indicate that they are duplicates. 
);
GO

-- Relationship(s) of products to specific series.
CREATE TABLE product_series
(
	product_series_id	INT IDENTITY PRIMARY KEY,		-- DB identifier of record
	product_id			INT FOREIGN KEY REFERENCES product(product_id),
														-- Product identifier
	series_id			INT FOREIGN KEY REFERENCES series(series_id),
														-- Associated series identifier

	-- Each product/seies combination must be unique.
	CONSTRAINT u1_product_series UNIQUE (product_id, series_id) 
);

-- Relationships of products to specific generes
CREATE TABLE product_genre
(
	product_genre_id	INT IDENTITY PRIMARY KEY,		-- DB indentifier of record
	product_id			INT FOREIGN KEY REFERENCES product(product_id),
														-- Product identifier
	genre_id			INT FOREIGN KEY REFERENCES genre(genre_id),
														-- Associated genre identifier
  
  	-- Each product/genre combination must be unique.
	CONSTRAINT u1_product_genre UNIQUE (product_id, genre_id) 
);
GO

-- Individiual action figures within a product offering
CREATE TABLE action_figure
(
  action_figure_id			INT IDENTITY PRIMARY KEY,	-- DB identifier of record
  action_figure_description	NVARCHAR(1024),				-- Detailed description (if needed) of action figure.
  storage_location			VARCHAR(32) NOT NULL,		-- Location where the action figure is stored or displayed
  likeness					NVARCHAR(128),				-- Celebrity or historic figure  the action figure resembles
  product_id				INT FOREIGN KEY REFERENCES product(product_id)
														-- Product to which the action figure belongs
);
GO

-- Relationship(s) of products to images
CREATE TABLE product_product_image
(
  product_product_image_id	INT IDENTITY PRIMARY KEY,	-- DB indentifier of record
  product_id				INT FOREIGN KEY REFERENCES product(product_id),
														-- Product identifier
  product_image_id			INT FOREIGN KEY REFERENCES product_image(product_image_id),
														-- Associated image identifier
  
  -- Each image may be associated with a single product at most one time. 
  CONSTRAINT u1_product_product_image UNIQUE (product_id, product_image_id) 
);
GO