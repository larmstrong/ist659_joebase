-- Add a new identity column to the temp_action_figure_v2 table
ALTER TABLE temp_action_figures_v2
	ADD id INT IDENTITY(1,1) NOT NULL