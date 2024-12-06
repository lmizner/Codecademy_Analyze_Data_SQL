-- Start by getting a feel for the met table.
-- What are the column names?
SELECT *
FROM met
LIMIT 10;


-- How many pieces are in the American Decorative Art collection?
SELECT COUNT(*)
FROM met;


-- Celery was considered a luxurious snack in the Victorian era (around the 1800s). Wealthy families served stalks of it in intricate glass vases.
-- Don’t believe it?
-- Count the number of pieces where the category includes ‘celery’.
SELECT COUNT(*)
FROM met
WHERE category LIKE '%celery%';


-- Find the title and medium of the oldest piece(s) in the collection.
SELECT title, medium, MIN(date)
FROM met;

SELECT title, medium, date
FROM met
WHERE date LIKE '%1600%';


-- Not every American decoration is from the Americas… where are they are coming from?
-- Find the top 10 countries with the most pieces in the collection.
SELECT country, COUNT(*)
FROM met
GROUP BY country
ORDER BY COUNT(*) DESC
LIMIT 10;


-- There are all kinds of American decorative art in the Met’s collection.
-- Find the categories HAVING more than 100 pieces.
SELECT category, COUNT(*)
FROM met
GROUP BY category
HAVING COUNT(*) > 100;


-- Lastly, let’s look at some bling!
-- Count the number of pieces where the medium contains ‘gold’ or ‘silver’.
-- And sort in descending order.
SELECT medium, COUNT(*)
FROM met
WHERE medium LIKE '%gold%'
  OR medium LIKE '%silver%'
GROUP BY medium
ORDER BY COUNT(*) DESC;


