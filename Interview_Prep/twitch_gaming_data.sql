-- Start by getting a feel for the stream table and the chat table.
-- Select the first 20 rows from each of the two tables.
-- What are the column names?
SELECT *
FROM stream
LIMIT 20;

SELECT *
FROM chat
LIMIT 20;


-- What are the unique games in the stream table?
SELECT DISTINCT(game)
FROM stream;


-- What are the unique channels in the stream table?
SELECT DISTINCT(channel)
FROM stream;


-- What are the most popular games in the stream table?
-- Create a list of games and their number of viewers using GROUP BY.
SELECT game, COUNT(*)
FROM stream
GROUP BY game
ORDER BY COUNT(*) DESC;


-- These are some big numbers from the game League of Legends (also known as LoL).
-- Where are these LoL stream viewers located?
-- Create a list of countries and their number of LoL viewers using WHERE and GROUP BY.
SELECT country, COUNT(*)
FROM stream
WHERE game = 'League of Legends'
GROUP BY 1
ORDER BY 2 DESC;


-- The player column contains the source the user is using to view the stream (site, iphone, android, etc).
-- Create a list of players and their number of streamers.
SELECT player, COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;


-- Create a new column named genre for each of the games.
-- Group the games into their genres: Multiplayer Online Battle Arena (MOBA), First Person Shooter (FPS), Survival, and Other.
-- Using CASE, your logic should be:
--     - If League of Legends → MOBA
--     - If Dota 2 → MOBA
--     - If Heroes of the Storm → MOBA
--     - If Counter-Strike: Global Offensive → FPS
--     - If DayZ → Survival
--     - If ARK: Survival Evolved → Survival
--     - Else → Other
-- Use GROUP BY and ORDER BY to showcase only the unique game titles.
SELECT game,
 CASE
  WHEN game = 'Dota 2'
      THEN 'MOBA'
  WHEN game = 'League of Legends' 
      THEN 'MOBA'
  WHEN game = 'Heroes of the Storm'
      THEN 'MOBA'
    WHEN game = 'Counter-Strike: Global Offensive'
      THEN 'FPS'
    WHEN game = 'DayZ'
      THEN 'Survival'
    WHEN game = 'ARK: Survival Evolved'
      THEN 'Survival'
  ELSE 'Other'
  END AS 'genre',
  COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 3 DESC;


-- Before we get started, let’s run this query and take a look at the time column from the stream table:
SELECT time
FROM stream
LIMIT 10;


-- SQLite comes with a strftime() function - a very powerful function that allows you to return a formatted date.
-- It takes two arguments:
--     - strftime(format, column)
-- Let’s test this function out:
SELECT time,
   strftime('%S', time)
FROM stream
GROUP BY 1
LIMIT 20;


-- Okay, now we understand how strftime() works. Let’s write a query that returns two columns: 
--     - The hours of the time column
--     - The view count for each hour
-- Lastly, filter the result with only the users in your country using a WHERE clause.
SELECT strftime('%H', time),
   COUNT(*)
FROM stream
WHERE country = 'US'
GROUP BY 1;


-- The stream table and the chat table share a column: device_id.
-- Let’s join the two tables on that column.
SELECT *
FROM stream
JOIN chat
  ON stream.device_id = chat.device_id;




