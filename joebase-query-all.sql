
SELECT manufacturer.manufacturer_name [Manufacturer],
       product.product_name [Product],
       product.product_description [Product Description],
       product.year_of_release [Release Year],
       format(product.purchase_price, '$####.00') [Purchase Price],
	   [Purchase Retailer].retailer_name [Purchased From],
	   [Exclusive Retailer].retailer_name [Exclsive To],
	   action_figure.action_figure_description
FROM product
     RIGHT JOIN manufacturer ON product.manufacturer_id = manufacturer.manufacturer_id
	 LEFT JOIN retailer [Purchase Retailer] on product.purchased_from_retailer_id = [Purchase Retailer].retailer_id
	 LEFT JOIN retailer [Exclusive Retailer] on product.exclusive_to_retailer_id = [Exclusive Retailer].retailer_id
	 JOIN action_figure on product.product_id = action_figure.product_id
ORDER BY manufacturer.manufacturer_name,
         product.product_name;

-- select * from product