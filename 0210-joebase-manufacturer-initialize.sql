
/*
** JOEBASE - The Action Figure Database
** joebase-manufacturer-initialize: This file loads the manufacturer lookup table values.
**
** Copyright Leonard Armstrong, 2018
** IST659
*/

USE joebase;

----------------------------------------------------------------------------------------------------
-- DELETE SECTION
-- Ensure the table is clean before (re)initializing.
----------------------------------------------------------------------------------------------------

DELETE manufacturer
GO

----------------------------------------------------------------------------------------------------
-- DATA INITIALIZATION SECTION
-- Values were generated from a list of unique manufacturer values from the original Joebase Excel
-- spreadsheet.
----------------------------------------------------------------------------------------------------

INSERT INTO manufacturer (manufacturer_name)
  VALUES
   ('** Unknown **'),
   ('21st Century Toys'),
   ('3R'),
   ('Adventure Gear'),
   ('Armoury'),
   ('Bandai'),
   ('bbi'),
   ('Blitzkrieg Toyz'),
   ('Chronicle Books'),
   ('Cotswold Collectibles'),
   ('Custom'),
   ('DC Direct'),
   ('DiD'),
   ('Dragon'),
   ('Drastic Plastic'),
   ('Dreams and Visions'),
   ('Dynamite'),
   ('Enterbay'),
   ('Ertl'),
   ('Figures Toy Company'),
   ('Forever Fun'),
   ('Formative'),
   ('G.I. Joe Collector''s Club'),
   ('Hasbro'),
   ('Hero Builders'),
   ('Hero Production'),
   ('Hot Toys'),
   ('Ideal'),
   ('In the Past Toys'),
   ('Jakks Pacific'),
   ('Kenner'),
   ('Kings Toys'),
   ('Lanard'),
   ('Majestic Studios'),
   ('Majic Productions'),
   ('Marx'),
   ('Mattel'),
   ('Medicom'),
   ('Modeller''s Loft'),
   ('N2 Toys'),
   ('Old Joe Infirmary'),
   ('Palisades'),
   ('Palitoy'),
   ('Playing Mantis'),
   ('Product Enterprises'),
   ('Project ARE'),
   ('Round 2'),
   ('Sideshow'),
   ('Takara'),
   ('Toy Biz'),
   ('Toypresidents'),
   ('Toys McCoy'),
   ('Triad Toys'),
   ('Twinch Squad'),
   ('Valor USA'),
   ('ZC World')
GO

----------------------------------------------------------------------------------------------------
-- POST-LOAD VERIFICATION SECTION
----------------------------------------------------------------------------------------------------

SELECT * FROM manufacturer;
GO