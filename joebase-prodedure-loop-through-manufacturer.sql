
-- Report shell to loop through the global list of manufacturers
CREATE OR ALTER PROCEDURE loop_through_manufacturer AS
BEGIN
	DECLARE @manufacturer_id INT,
		@manufacturer_name NVARCHAR(128);

	DECLARE csr_manufacturer 
		CURSOR FOR
			SELECT manufacturer.manufacturer_id, manufacturer.manufacturer_name
			FROM manufacturer
			ORDER by manufacturer.manufacturer_name;

	OPEN csr_manufacturer;
	FETCH NEXT FROM csr_manufacturer
		INTO @manufacturer_id, @manufacturer_name;

	DECLARE @indent_manufacturer NVARCHAR(1024) = '';
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT(@indent_manufacturer + @manufacturer_name);


		PRINT('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
		FETCH NEXT FROM csr_manufacturer
			INTO @manufacturer_id, @manufacturer_name;
	END;
	CLOSE csr_manufacturer;
	DEALLOCATE csr_manufacturer;
END; -- PROCEDURE loop_through_manufacturer
