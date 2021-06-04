DECLARE @product INT = 276;

SELECT *
FROM product_details
WHERE product_details.product_id = @product;

SELECT *
FROM product_action_figure
WHERE product_action_figure.product_id = @product;

SELECT *
FROM product_genre_details(@product);

SELECT *
FROM product_series_details(@product);

--select *
--from product
--where product_name like '%Superman%'

--select distinct storage_location, count(*)
--from action_figure
--group by storage_location


