-- Remove all mistakes where Primary Genre = Secondary Genre
UPDATE temp_action_figures_v2
SET temp_action_figures_v2.[Secondary Genre] = NULL
WHERE temp_action_figures_v2.[Primary Genre] = temp_action_figures_v2.[Secondary Genre];
GO