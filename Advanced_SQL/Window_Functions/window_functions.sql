-- Run a query to select all the information in our social_media table to see what data we have.
-- What are the column names?
SELECT *
FROM social_media;


-- Delete the query and write a new query to return the username column and the SUM of the total change_in_followers in our social_media table, that are from “instagram”.
-- Don’t forget to use WHERE and GROUP BY.
SELECT username, SUM(change_in_followers)
FROM social_media
WHERE username = 'instagram'
GROUP BY username;


-- Query to see the “running total” of Instagram’s change_in_followers for each month.
-- A running total is the sum of all the previous rows up to the current one.
SELECT month,
  change_in_followers,
  SUM(change_in_followers) OVER (
      ORDER BY month
   ) AS 'running_total'
FROM social_media
WHERE username = 'instagram';


-- In the code editor, modify the example window function:
--     - Use AVG instead of SUM.
--     - Change the name of the window function column to be running_avg instead of running_total.
SELECT month,
  change_in_followers,
  AVG(change_in_followers) OVER (
    ORDER BY month
  ) AS running_avg
FROM social_media
WHERE username = 'instagram';


-- Let’s now implement a more complex window function that utilizes SUM, COUNT and AVG.
SELECT month,
  change_in_followers,
  SUM(change_in_followers) OVER (
    ORDER BY month
  ) AS 'running_total',
  AVG(change_in_followers) OVER (
    ORDER BY month
  ) AS 'running_avg',
  COUNT(change_in_followers) OVER (
    ORDER BY month
  ) AS 'running_count'
FROM social_media
WHERE username = 'instagram';


-- Query below to see the total change in followers for each user.
SELECT username, 
  SUM(change_in_followers) AS 'total_follower_change'
FROM social_media
GROUP BY username;


-- If you modify the query to also return the month column, what happens?
-- (Make sure to add month between username and 'total_change_in_followers' and also add month in the GROUP BY.)
-- Are you still seeing the total changes for each account?
SELECT username,
  month,
  SUM(change_in_followers) AS 'total_change_in_followers'
FROM social_media
GROUP BY username, month;


-- Query using PARTITION BY. How does this change our results from the GROUP BY query we ran?
SELECT username,
  month,
  change_in_followers,
  SUM(change_in_followers) OVER (
    PARTITION BY username 
    ORDER BY month
  ) 'running_total_followers_change'
FROM social_media;


-- Utilizing PARTITION BY allowed us to find the total change in followers for each user up to the current month and display it next to the current month.
-- Modify the query to have it also return the average change in followers for each month and return this as running_avg_followers_change.
SELECT username,
  month,
  change_in_followers,
  SUM(change_in_followers) OVER (
    PARTITION BY username 
    ORDER BY month
  ) 'running_total_followers_change',
  AVG(change_in_followers) OVER (
    PARTITION BY username 
    ORDER BY month
  ) 'running_avg_followers_change'
FROM social_media;


-- Query the code and run it. What is the result?
SELECT username,
   posts,
   FIRST_VALUE (posts) OVER (
      PARTITION BY username 
      ORDER BY posts
   ) AS 'fewest_posts'
FROM social_media;


-- If FIRST_VALUE is returning the fewest posts, then LAST_VALUE should return the most posts for each user.
-- Update the query now to use LAST_VALUE instead of FIRST_VALUE.
-- Are we seeing the expected result?
SELECT username,
   posts,
   LAST_VALUE (posts) OVER (
      PARTITION BY username 
      ORDER BY posts
   ) AS 'fewest_posts'
FROM social_media;


-- We saw that LAST_VALUE didn’t work as we expected. This is because each row in our results set is the last row at the time it is outputted.
-- In order to get LAST_VALUE to show us the most posts for a user, we need to specify a frame for our window function.
SELECT username,
  posts,
  LAST_VALUE (posts) OVER (
    PARTITION BY username 
    ORDER BY posts
    RANGE BETWEEN UNBOUNDED PRECEDING AND 
    UNBOUNDED FOLLOWING
    ) most_posts
FROM social_media;









