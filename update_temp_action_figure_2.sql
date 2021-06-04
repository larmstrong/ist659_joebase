/* Second clean-up script for temp_action_figure_2.                          */
/* This time to clean-up some of the retailer names in the exlcusive column. */

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Producer]
      ,[Product]
      ,[Location]
      ,[# Figs]
      ,[Series 1]
      ,[Series 2]
      ,[Series 3]
      ,[Series 4]
      ,[Primary Genre]
      ,[Secondary Genre]
      ,[Likeness]
      ,[Year of Release]
      ,[Purchased From]
      ,[Purchase Price]
      ,[Exclusive To]
      ,[Keywords]
      ,[F17]
      ,[SQL]
  FROM [joebase].[dbo].[temp_action_figures_v2]
  WHERE [Exclusive To] in ('JC Penney', 'Sideshow', 'Sideshow Exclusive Version',  'White haired figure;')

-- Make 'J.C. Penney consistent
UPDATE temp_action_figures_v2
SET [Exclusive To] = 'J.C. Penney'
WHERE [Exclusive To] = 'JC Penney';

-- Make all 'Sideshow' consistent.
UPDATE temp_action_figures_v2
SET [Exclusive To] = 'Sideshow Collectibles'
WHERE [Exclusive To] like 'Sideshow%';

SELECT DISTINCT [Exclusive To]
FROM [temp_action_figures_v2]
EXCEPT
SELECT DISTINCT retailer_name
FROM retailer;