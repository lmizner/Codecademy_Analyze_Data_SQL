-- Challenge 1
-- Find the number of girls who were named Lillian for the full span of time of the database.

SELECT year, number
FROM babies
WHERE name = 'Lillian';


-- Challenge 2
-- Find 20 distinct names that start with ‘S’.

SELECT DISTINCT name
FROM babies
WHERE name LIKE 'S%'
LIMIT 20;


-- Challenge 3
-- What are the top 10 names in 1880?

SELECT name, gender, number
FROM babies
WHERE year = 1880
ORDER BY number DESC
LIMIT 10;

