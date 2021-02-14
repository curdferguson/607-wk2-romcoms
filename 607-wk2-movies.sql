/*
  607-wk2-movies.sql
  Tyler Frankenberg
*/

/* Step 1: Begin by creating a table to house the survey data */

DROP TABLE IF EXISTS movies;
CREATE TABLE movies 
(
  id                           INT        NOT NULL,
  The_Shape_of_Water           INT        NULL,
  The_Big_Sick                 INT        NULL,
  Call_Me_By_Your_Name         INT        NULL,
  Carol                        INT        NULL,
  Before_Midnight              INT        NULL,
  The_Artist                   INT        NULL,
  Her                          INT        NULL,
  Ash_is_Purest_White          INT        NULL,
  Only_Yesterday               INT        NULL,
  Sideways                     INT        NULL,
  The_Princess_Bride           INT        NULL,
  Beauty_And_The_Beast         INT        NULL
);

SELECT * FROM movies;

/* Step 2: Load the data from cx_movies.csv into movies */

LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cx_movies.csv' 
	INTO TABLE movies
	FIELDS TERMINATED BY ',' 
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES

-- Set column correspondene & NULL Handling...
(@id, @The_Shape_of_Water, @The_Big_Sick, @Call_Me_By_Your_Name, @Carol, @Before_Midnight, @The_Artist, @Her, @Ash_is_Purest_White, @Only_Yesterday, @Sideways, @The_Princess_Bride, @Beauty_and_the_Beast)
SET id = @id,
	The_Shape_of_Water = IF(@The_Shape_of_Water = '', NULL, @The_Shape_of_Water),
    The_Big_Sick = IF(@The_Big_Sick = '', NULL, @The_Big_Sick),
    Call_Me_By_Your_Name = IF(@Call_Me_By_Your_Name = '', NULL, @Call_Me_By_Your_Name),
    Carol = IF(@Carol = '', NULL, @Carol),
    Before_Midnight = IF(@Before_Midnight = '', NULL, @Before_Midnight),
    The_Artist = IF(@The_Artist = '', NULL, @The_Artist),
    Her = IF(@Her = '', NULL, @Her),
    Ash_is_Purest_White = IF(@Ash_is_Purest_White = '', NULL, @Ash_is_Purest_White),
    Only_Yesterday = IF(@Only_Yesterday = '', NULL, @Only_Yesterday),
    Sideways = IF(@Sideways = '', NULL, @Sideways),
    The_Princess_Bride = IF(@The_Princess_Bride = '', NULL, @The_Princess_Bride),
    Beauty_and_the_Beast = IF(@Beauty_and_the_Beast = '', NULL, @Beauty_and_the_Beast)
;
-- Code from https://dba.stackexchange.com/a/97892 was used as a template for the above NULL handling.

SELECT * FROM movies;

/* Step 3: Use a View to store the average rating of only the movies who had at least 3 ratings */

DROP VIEW IF EXISTS averages;
CREATE VIEW averages AS SELECT 
	CASE WHEN(SUM(ISNULL(The_Shape_of_Water)) <= 4) THEN AVG(The_Shape_of_Water) ELSE NULL END AS The_Shape_of_Water,
    CASE WHEN(SUM(ISNULL(The_Big_Sick)) <= 4) THEN AVG(The_Big_Sick) ELSE NULL END AS The_Big_Sick,
    CASE WHEN(SUM(ISNULL(Call_Me_By_Your_Name)) <= 4) THEN AVG(Call_Me_By_Your_Name) ELSE NULL END AS Call_Me_By_Your_Name,
    CASE WHEN(SUM(ISNULL(Carol)) <= 4) THEN AVG(Carol) ELSE NULL END AS Carol,
    CASE WHEN(SUM(ISNULL(Before_Midnight)) <= 4) THEN AVG(Before_Midnight) ELSE NULL END AS Before_Midnight,
    CASE WHEN(SUM(ISNULL(The_Artist)) <= 4) THEN AVG(The_Artist) ELSE NULL END AS The_Artist,
	CASE WHEN(SUM(ISNULL(Her)) <= 4) THEN AVG(Her) ELSE NULL END AS Her,
    CASE WHEN(SUM(ISNULL(Ash_is_Purest_White)) <= 4) THEN AVG(Ash_is_Purest_White) ELSE NULL END AS Ash_is_Purest_White,
    CASE WHEN(SUM(ISNULL(Only_Yesterday)) <= 4) THEN AVG(Only_Yesterday) ELSE NULL END AS Only_Yesterday,
    CASE WHEN(SUM(ISNULL(Sideways)) <= 4) THEN AVG(Sideways) ELSE NULL END AS Sideways,
    CASE WHEN(SUM(ISNULL(The_Princess_Bride)) <= 4) THEN AVG(The_Princess_Bride) ELSE NULL END AS The_Princess_Bride,
    CASE WHEN(SUM(ISNULL(Beauty_and_the_Beast)) <= 4) THEN AVG(Beauty_and_the_Beast) ELSE NULL END AS Beauty_and_the_Beast
    FROM movies; 

SELECT * FROM averages;

/* Step 4: Use a separate view to store the number of ratings for each of the movies that had at least 3 ratings */
DROP VIEW IF EXISTS counts;
CREATE VIEW counts AS SELECT 
	CASE WHEN(SUM(ISNULL(The_Shape_of_Water)) <= 4) THEN COUNT(The_Shape_of_Water) ELSE NULL END AS The_Shape_of_Water,
    CASE WHEN(SUM(ISNULL(The_Big_Sick)) <= 4) THEN COUNT(The_Big_Sick) ELSE NULL END AS The_Big_Sick,
    CASE WHEN(SUM(ISNULL(Call_Me_By_Your_Name)) <= 4) THEN COUNT(Call_Me_By_Your_Name) ELSE NULL END AS Call_Me_By_Your_Name,
    CASE WHEN(SUM(ISNULL(Carol)) <= 4) THEN COUNT(Carol) ELSE NULL END AS Carol,
    CASE WHEN(SUM(ISNULL(Before_Midnight)) <= 4) THEN COUNT(Before_Midnight) ELSE NULL END AS Before_Midnight,
    CASE WHEN(SUM(ISNULL(The_Artist)) <= 4) THEN COUNT(The_Artist) ELSE NULL END AS The_Artist,
	CASE WHEN(SUM(ISNULL(Her)) <= 4) THEN COUNT(Her) ELSE NULL END AS Her,
    CASE WHEN(SUM(ISNULL(Ash_is_Purest_White)) <= 4) THEN COUNT(Ash_is_Purest_White) ELSE NULL END AS Ash_is_Purest_White,
    CASE WHEN(SUM(ISNULL(Only_Yesterday)) <= 4) THEN COUNT(Only_Yesterday) ELSE NULL END AS Only_Yesterday,
    CASE WHEN(SUM(ISNULL(Sideways)) <= 4) THEN COUNT(Sideways) ELSE NULL END AS Sideways,
    CASE WHEN(SUM(ISNULL(The_Princess_Bride)) <= 4) THEN COUNT(The_Princess_Bride) ELSE NULL END AS The_Princess_Bride,
    CASE WHEN(SUM(ISNULL(Beauty_and_the_Beast)) <= 4) THEN COUNT(Beauty_and_the_Beast) ELSE NULL END AS Beauty_and_the_Beast
    FROM movies;

SELECT * FROM counts;

/* Step 5: Use a third and final view to select the count and average together for each of the five movies with at least 3 responses */

DROP VIEW IF EXISTS relevant;
CREATE VIEW relevant AS SELECT
	counts.The_Big_Sick AS TBS_Count, 
	averages.The_Big_Sick AS TBS_AV,
    counts.Her AS Her_Count,
    averages.Her AS Her_AV, 
    counts.Sideways AS Sideways_Count,
    averages.Sideways AS Sideways_AV,
    counts.The_Princess_Bride AS TPB_Count,
    averages.The_Princess_Bride AS TPB_AV, 
    counts.Beauty_and_the_Beast AS Beauty_Count,
    averages.Beauty_and_the_Beast AS Beauty_AV 
FROM averages, counts;

/* Export to CSV by SELECTing into an OUTFILE */
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/wk2-relevant-movies.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
FROM relevant;
