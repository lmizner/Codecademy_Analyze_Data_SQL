-- Let’s see what these tables contain by running the following commands.
SELECT *
FROM places;

SELECT * 
FROM reviews;



-- If each dollar sign ($) represents $10, how could you find all places that cost $20 or less?
SELECT *
FROM places
WHERE price_point = '$'
  OR price_point = '$$';



-- What columns can be used to JOIN these two tables?

-- The foreign key here is place_id in the reviews table.



-- Let’s explore how the places on Welp stand up to reviewers.
-- Write a query to do an INNER JOIN on the two tables to show all reviews for restaurants that have at least one review.
SELECT *
FROM places
JOIN reviews
  ON places.id = reviews.place_id;



-- You probably noticed all the extra information in your results.
-- Modify your previous query to select only the most important columns in order to display a log of reviews by selecting the following:
--     - From the places table: name, average_rating
--     - From the reviews table: username, rating, review_date, note
SELECT places.name,
  places.average_rating, 
  reviews.username, 
  reviews.rating, 
  reviews.review_date, 
  reviews.note
FROM places
JOIN reviews
  ON places.id = reviews.place_id;



-- Now write a query to do a LEFT JOIN on the tables, selecting the same columns as the previous question.
-- How are the results of this query different? Would this or the INNER JOIN be more useful for a log of reviews?
SELECT places.name,
  places.average_rating, 
  reviews.username, 
  reviews.rating, 
  reviews.review_date, 
  reviews.note
FROM places
LEFT JOIN reviews
  ON places.id = reviews.place_id;



-- What about the places without reviews in our dataset?
-- Write a query to find all the ids of places that currently do not have any reviews in our reviews table.
SELECT places.name,
  places.average_rating, 
  reviews.username, 
  reviews.rating, 
  reviews.review_date, 
  reviews.note
FROM places
LEFT JOIN reviews
  ON places.id = reviews.place_id
WHERE reviews.place_id IS NULL;



-- Sometimes on Welp, there are some old reviews that aren’t useful anymore.
-- Write a query using the WITH clause to select all the reviews that happened in 2020. JOIN the places to your WITH query to see a log of all reviews from 2020.
WITH reviews_2020 AS (
  SELECT *
  FROM reviews
  WHERE strftime("%Y", review_date) = '2020'
)
SELECT *
FROM places
JOIN reviews_2020
  ON places.id = reviews_2020.place_id;



-- Businesses want to be on the lookout for …ahem… difficult reviewers. Write a query that finds the reviewer with the most reviews that are BELOW the average rating for places.
SELECT reviews.username, COUNT(*) AS review_count
FROM reviews
JOIN places
  ON reviews.place_id = places.id
WHERE reviews.rating < (
    SELECT AVG(average_rating)
    FROM places
)
GROUP BY reviews.username
ORDER BY review_count DESC
LIMIT 1;





