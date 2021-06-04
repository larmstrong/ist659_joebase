SELECT *
FROM temp_action_figures_v2;


-- Find duplicate figures
SELECT *
FROM temp_action_figures_v2
WHERE Producer + ', ' + Product IN
(
    SELECT Producer+', '+Product
    --       COUNT(Producer + Product)
    FROM temp_action_figures_v2
    GROUP BY Producer,
             Product
    HAVING COUNT(Producer + Product) > 1
);

-- Find multi-figure sets
SELECT *
FROM temp_action_figures_v2
WHERE Producer + ', ' + Product IN
(
    SELECT Producer+', '+Product
    --       COUNT(Producer + Product)
    FROM temp_action_figures_v2
    GROUP BY Producer,
             Product
    HAVING COUNT(Producer + Product) > 1
);

select producer, substring(product, 1, 25), count(*)
from temp_action_figures_v2
group by producer, substring(product, 1, 25)
having count(*) > 1
order by producer, substring(product, 1, 25)

SELECT Producer,
       Product,
       COUNT(Producer + Product)
FROM temp_action_figures_v2
GROUP BY Producer,
         Product
HAVING COUNT(Producer + Product) > 1;

