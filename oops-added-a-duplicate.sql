/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [product_id]
      ,[product_name]
      ,[product_type_id]
      ,[product_description]
      ,[year_of_release]
      ,[purchase_price]
      ,[purchased_from_retailer_id]
      ,[manufacturer_id]
      ,[exclusive_to_retailer_id]
  FROM [joebase].[dbo].[product]


DECLARE @product_id INT = 1446;

DELETE FROM product_genre
WHERE product_genre.product_id = @product_id;

DELETE FROM product_series
WHERE product_series.product_id = @product_id;

DELETE FROM action_figure 
WHERE action_figure.product_id = @product_id;

delete from product 
where product_id = @product_id;