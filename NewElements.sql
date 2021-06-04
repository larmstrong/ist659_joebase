
CREATE OR ALTER PROCEDURE NewOneSixthScaleActionFigureProduct (
	@product_name               NVARCHAR(128),
	@product_description        NVARCHAR(1024),
	@manufacturer_id            INT,
	@year_of_release            INT, 
	@purchase_price             DECIMAL(19,4),
	@purchased_from_retailer_id INT,
	@exclusive_to_retailer_id   INT,
	@action_figure_description  NVARCHAR(1024),
	@storage_location           VARCHAR(32),
	@likeness                   NVARCHAR(128)) 
AS
BEGIN
	DECLARE @one_sixth_scale_figure_id INT;
	SELECT @one_sixth_scale_figure_id = product_type.product_type_id
	FROM product_type
	WHERE product_type.product_type_name = '1:6 figure';

	INSERT INTO product (product_name,  product_type_id,            product_description,  year_of_release,  purchase_price,  manufacturer_id,  purchased_from_retailer_id,  exclusive_to_retailer_id)
		VALUES          (@product_name, @one_sixth_scale_figure_id, @product_description, @year_of_release, @purchase_price, @manufacturer_id, @purchased_from_retailer_id, @exclusive_to_retailer_id);
	DECLARE @new_product_id INT = SCOPE_IDENTITY();
	PRINT(@new_product_id);

	INSERT INTO action_figure (product_id,      action_figure_description,  storage_location,  likeness)
		VALUES                (@new_product_id, @action_figure_description, @storage_location, @likeness);

	RETURN @new_product_id;
END; -- NewProduct
GO

DECLARE @m_id INT = dbo.getManufacturerID('Hot Toys');
DECLARE @r_id INT = dbo.getRetailerID('Sideshow Collectibles');
PRINT(@m_id)
PRINT(@r_id)
EXECUTE NewOneSixthScaleActionFigureProduct
	@product_name = 'Batman (Batman v. Superman)',
	@product_description = 'Batman in standard costume from movie Batman v. Superman',
	@manufacturer_id = @m_id,
	@year_of_release = 2016,
	@purchase_price = 234.99,
	@purchased_from_retailer_id = @r_id,
	@exclusive_to_retailer_id = NULL,
	@action_figure_description = 'Wonder Woman in standard costume from movie Batman v. Superman',
	@storage_location = 'desk.left.top.upper',
	@likeness = 'Gal Gadot';
GO

