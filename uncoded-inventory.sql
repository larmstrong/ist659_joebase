-- Bozed storage

SELECT product.product_id, manufacturer_name, product.product_name, action_figure.action_figure_id, action_figure.action_figure_description, action_figure.storage_location
FROM product
JOIN action_figure ON product.product_id = action_figure.product_id
LEFT JOIN manufacturer ON product.manufacturer_id = manufacturer.manufacturer_id
WHERE action_figure.storage_location like '__.__'
  AND action_figure.storage_location not like '__.00'
ORDER by action_figure.storage_location, manufacturer.manufacturer_name, product.product_name
GO

SELECT storage_location, COUNT(action_figure_id)
FROM product_action_figure
WHERE storage_location like '__.__'
  AND storage_location not like '__.00'
GROUP BY storage_location
GO

SELECT *
FROM product_action_figure
WHERE storage_location like '__.00'
  OR storage_location NOT LIKE '%.%.%';
GO