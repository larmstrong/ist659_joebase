
/*
** JOEBASE - The Action Figure Database
** joebase-prodducttype-initialize: This file loads the product type values.
**
** Copyright Leonard Armstrong, 2018
** IST659
*/

USE joebase;

----------------------------------------------------------------------------------------------------
-- DELETE SECTION
-- Ensure the table is clean before (re)initializing.
----------------------------------------------------------------------------------------------------

DELETE product_type;
GO

----------------------------------------------------------------------------------------------------
-- DATA INITIALIZATION SECTION
-- Values were generated from a list of product types envisioned to be managed by the early versions
-- of Joebase.
----------------------------------------------------------------------------------------------------

INSERT INTO product_type(product_type_name, product_type_description)
VALUES
	('1:6 figure',    '1:6 scale action figure or set with one or more action figures'),
	('1:6 accessory', '1:6 scale accessory and/or outfit set that does not include an action figure'),
	('1:6 vehicle',   '1:6 scale motor vehicle, watercraft, aircraft, spacecraft or other form of transportation')
GO

----------------------------------------------------------------------------------------------------
-- POST-LOAD VERIFICATION SECTION
----------------------------------------------------------------------------------------------------

SELECT *
FROM product_type;
GO