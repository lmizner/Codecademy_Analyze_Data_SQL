-- Challenge 7
-- Order the table by title (from A-Z).
-- Select only the title and publisher columns.

SELECT title, publisher
FROM news
ORDER BY title ASC;


-- Challenge 8
-- Which article names have the word 'bitcoin' in it?
-- Select all the columns.

SELECT *
FROM news
WHERE title LIKE '%bitcoin%';


-- Challenge 9
-- The category column contains the article category:
-- 'b' stands for Business
-- 't' stands for Technology
-- What are the 20 business articles published most recently?
-- Select all the columns.

SELECT *
FROM news
WHERE category = 'b'
ORDER BY timestamp DESC
LIMIT 20;
