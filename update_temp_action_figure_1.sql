/* Script of manual updates performed after the Excel files was pulled into a temporary table. */

-- Move keywords value accidentally stored in Exclusive field
UPDATE temp_action_figures_v2
SET [Exclusive To] = null,
  Keywords = 'White haired figure;'
WHERE Producer = 'Dreams and Visions'
  AND Product = 'U.S. Navy Ordinance'

-- Move Keywords value accidentally held in Exclusive field and...
-- fix a type in the product name.
UPDATE temp_action_figures_v2
SET [Exclusive To] = null,
  Keywords = 'MMS #297',
  Product = 'Luke Skywalker (from A New Hope)'
WHERE Producer = 'Hot Toys'
  AND Product = 'Luke Skywalker (fron A New Hope)'