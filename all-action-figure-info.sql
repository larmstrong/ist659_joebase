USE joebase;
GO

--DECLARE @mid INT = dbo.getManufacturerID('Hongkong COO MODEL');
DECLARE @pid INT = 29; -- dbo.getProductID('Gothic Knight', @mid);


SELECT *
FROM product_details
WHERE product_details.product_id = @pid

SELECT *
FROM product_action_figure
WHERE product_action_figure.product_id = @pid

select *
FROM product_genre_details(@pid)


select *
FROM product_series_details(@pid)

GO