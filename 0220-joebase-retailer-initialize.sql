
/*
** JOEBASE - The Action Figure Database
** joebase-retailer-initialize: This file loads the retailer lookup table values.
**
** Copyright Leonard Armstrong, 2018
** IST659
*/

USE joebase;

----------------------------------------------------------------------------------------------------
-- DELETE SECTION
-- Ensure the table is clean before (re)initializing.
----------------------------------------------------------------------------------------------------

DELETE retailer
GO

----------------------------------------------------------------------------------------------------
-- DATA INITIALIZATION SECTION
-- Values were generated from a list of unique retailer values from the original Joebase Excel
-- spreadsheet.
----------------------------------------------------------------------------------------------------

INSERT INTO retailer (retailer_name)
VALUES
	('2009 San Diego Comic Con'),
	('Adventure Gear'),
	('Amazon'),
	('Ames'),
	('Atlantique City'),
	('Barry Kay'),
	('Big Bad Toy Store'),
	('Booksmith'),
	('Connecticut Convention'),
	('Cotswold Collectibles'),
	('Dad'),
	('Disney Theme Parks'),
	('Don Levine at toy show in Pennsauken'),
	('Dreams and Visions'),
	('eBay'),
	('Eklyps'),
	('Entertainment Earth'),
	('FAO Schwarz'),
	('Figuretoy.com'),
	('G.I. Ace'),
	('G.I. Elic'),
	('G.I. Joe Collector''s Club'),
	('G.I. Joe Collector''s Convention'),
	('Gene''s Books'),
	('Gift'),
	('Gift basket'),
	('Hall of Heroes'),
	('Internet'),
	('J.C. Penney'),
	('KB Toys'),
	('LA Custom'),
	('Majic Productions'),
	('Meijers'),
	('merit-intl.com'),
	('Mikerian Mercantile Ltd.'),
	('Mom'),
	('Pennsauken Toy Show'),
	('Project ARE'),
	('Showcase Comics'),
	('Sideshow Collectibles'),
	('Small Blue Planet'),
	('Stormwatch Comics'),
	('Target'),
	('The Duffle Bag'),
	('Timewalker Toys'),
	('Toy Show in Pennsauken'),
	('Toys R Us'),
	('Urban Collector'),
	('US Navy Exchange'),
	('Wal-Mart'),
	('Walt Disney World'),
	('Zolocon')
GO

----------------------------------------------------------------------------------------------------
-- POST-LOAD VERIFICATION SECTION
----------------------------------------------------------------------------------------------------

SELECT *
FROM retailer;
GO