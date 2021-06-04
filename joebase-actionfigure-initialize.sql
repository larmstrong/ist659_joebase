DELETE action_figure
GO

DECLARE @storagelocation VARCHAR(32)
DECLARE @likeness NVARCHAR(128)
SELECT @storagelocation = [Location], @likeness = Likeness
FROM temp_action_figures

INSERT INTO action_figure(action_figure_description, storage_location, likeness, product_id)
SELECT t.Product + '. ' + t.Keywords, t.[Location], t.Likeness
FROM temp_action_figures t

