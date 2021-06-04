
----------------------------------------------------------------------------------------------------
-- Add a new series
----------------------------------------------------------------------------------------------------

-- Get the manufacturer
DECLARE @the_manufacturer_id INT = dbo.getManufacturerID('Hot Toys');

-- Create the series 
EXECUTE insertSeriesRecord 
	@manufacturer_id = @the_manufacturer_id,
	@series_name = 'Ant-Man and the Wasp',
	@series_description = 'Marvel Studio''s "Ant-Man and the Wasp movie."';
DECLARE @series1 INT = SCOPE_IDENTITY();
/*
EXECUTE insertSeriesRecord 
	@manufacturer_id = @the_manufacturer_id,
	@series_name = 'Barbie® Fashion Model Collection',
	@series_description = 'Barbie® Fashion Model Collection';
DECLARE @series2 INT = SCOPE_IDENTITY();
*/

--DECLARE @series1 INT = dbo.getSeriesID(@the_manufacturer_id, 'Batman v. Superman');
--DECLARE @series2 INT = dbo.getSeriesID(@the_manufacturer_id, 'D.C. Comics');
--DECLARE @series3 INT = dbo.getSeriesID(@the_manufacturer_id, 'Movie Masterpiece Series');
print(@series1)
--print(@series2)
--print(@series3)

-- Get the product IDs
DECLARE @product1 INT = dbo.getProductID('Batman (Batman v. Superman)', @the_manufacturer_id);
DECLARE @product2 INT = dbo.getProductID('Wonder Woman (Batman v. Superman)', @the_manufacturer_id);
--DECLARE @product3 INT = dbo.getProductID('Don Draper (Ken)', @the_manufacturer_id);
--DECLARE @product4 INT = dbo.getProductID('Roger Sterling (Ken)', @the_manufacturer_id);

print(@product1)
print(@product2)
--print(@product3)
--print(@product4)

-- Create the product_series records
--EXECUTE insertProductSeriesRecord @product_id = @product1, @series_id = @series1;
--EXECUTE insertProductSeriesRecord @product_id = @product1, @series_id = @series2;
--EXECUTE insertProductSeriesRecord @product_id = @product1, @series_id = @series3;
--EXECUTE insertProductSeriesRecord @product_id = @product2, @series_id = @series1;
--EXECUTE insertProductSeriesRecord @product_id = @product2, @series_id = @series2;
EXECUTE insertProductSeriesRecord @product_id = @product2, @series_id = @series3;
--EXECUTE insertProductSeriesRecord @product_id = @product3, @series_id = @series1;
--EXECUTE insertProductSeriesRecord @product_id = @product3, @series_id = @series2;
--EXECUTE insertProductSeriesRecord @product_id = @product4, @series_id = @series1;
--EXECUTE insertProductSeriesRecord @product_id = @product4, @series_id = @series2;
GO
