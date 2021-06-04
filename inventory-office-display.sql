
/****** Script for SelectTopNRows command from SSMS  ******/

SELECT TOP (1000) [product_id],
                  [manufacturer_name],
                  [product_name],
                  [product_type_name],
                  [product_description],
                  [year_of_release],
                  [# Figures in Product],
                  [action_figure_id],
                  [action_figure_description],
                  [likeness],
                  [storage_location]
FROM [joebase].[dbo].[office_storage_locations];

SELECT storage_location AS "Storage Location",
       COUNT(*) AS "Count"
FROM office_storage_locations
GROUP BY storage_location WITH ROLLUP;