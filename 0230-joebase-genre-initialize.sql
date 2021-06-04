
/*
** JOEBASE - The Action Figure Database
** joebase-genre-initialize: This file loads the genre lookup table values.
**
** Copyright Leonard Armstrong, 2018
** IST659
*/

USE joebase;

----------------------------------------------------------------------------------------------------
-- DELETE SECTION
-- Ensure the table is clean before (re)initializing.
----------------------------------------------------------------------------------------------------

DELETE FROM genre;
GO

----------------------------------------------------------------------------------------------------
-- DATA INITIALIZATION SECTION
-- Values were generated from a list of unique genre values from the original Joebase Excel
-- spreadsheet.
----------------------------------------------------------------------------------------------------

INSERT INTO genre(genre_name)
VALUES
	('Adventure'),
	('Air Force'),
	('Army'),
	('Astronaut'),
	('Celebrity'),
	('Civilian'),
	('Coast Guard'),
	('Comics'),
	('Fashion'),
	('Fire Fighter'),
	('Foreign'),
	('Horror'),
	('Marines'),
	('Martial Arts'),
	('Navy'),
	('Police'),
	('RAH/Cobra'),
	('Sci-Fi'),
	('Sports'),
	('Spy'),
	('TV/Film'),
	('Warrior'),
	('Western'),
	('World Leader')
GO

----------------------------------------------------------------------------------------------------
-- POST-LOAD VERIFICATION SECTION
----------------------------------------------------------------------------------------------------

SELECT *
FROM genre
GO