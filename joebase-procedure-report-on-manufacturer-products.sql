

CREATE OR ALTER PROCEDURE report_on_manufacturer_products
	@param_manufacturer_id INT
AS
BEGIN
		DECLARE @product_id				INT, 
			@product_name				NVARCHAR(128),
			@product_type_id			INT,
			@product_description		NVARCHAR(1024),
			@year_of_release			INT,
			@purchase_price				DECIMAL(19,4),
			@purchased_from_retailer_id	INT,
			@exclusive_to_retailer_id	INT;

		DECLARE @max_product_name_length INT;
		SELECT @max_product_name_length = (LEN(product.product_name))
			FROM product;

		DECLARE csr_product
			CURSOR FOR
				SELECT product.product_id, product.product_name, product.product_type_id, product.product_description, 
					product.year_of_release,product.purchase_price, product.purchased_from_retailer_id, product.exclusive_to_retailer_id
				FROM product
				WHERE product.manufacturer_id = @param_manufacturer_id;

		OPEN csr_product;
		FETCH NEXT FROM csr_product 
			INTO @product_id, @product_name, @product_type_id, @product_description, @year_of_release, @purchase_price,	@purchased_from_retailer_id, @exclusive_to_retailer_id;
		DECLARE @indent_product NVARCHAR(1024) = CHAR(9);

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT(@indent_product + @product_name);

			FETCH NEXT FROM csr_product 
				INTO @product_id, @product_name, @product_type_id, @product_description, @year_of_release, @purchase_price,	@purchased_from_retailer_id, @exclusive_to_retailer_id;
		END;

		CLOSE csr_product;
		DEALLOCATE csr_product;
END;

-- EXECUTE loop_through_manufacturer;


--SELECT manufacturer.manufacturer_name, product.product_id, product.product_name, product_type.product_type_name, product.product_description, product.year_of_release, 
--	purchase_retailer.retailer_name [Purchase Retailer]
--FROM product
--JOIN product_type ON product.product_type_id = product_type.product_type_id
--JOIN manufacturer ON product.manufacturer_id = manufacturer.manufacturer_id
--JOIN retailer purchase_retailer ON product.purchased_from_retailer_id = purchase_retailer.retailer_id