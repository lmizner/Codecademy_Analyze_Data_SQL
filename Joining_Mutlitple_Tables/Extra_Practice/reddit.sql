-- Let’s start by examining the three tables.
-- Write queries to select the rows from each table. Because some of the tables have many rows, select just the first 10 rows from each.
-- What are the column names of each table?
SELECT *
FROM users
LIMIT 10;

SELECT *
FROM posts
LIMIT 10;

SELECT *
FROM subreddits
LIMIT 10;



-- What is the primary key for each table? Can you identify any foreign keys?

-- The primary key of users table is id.
-- The primary key of posts table is id.
-- The primary key of subreddits table is id.
-- The posts table has foreign keys user_id and subreddit_id.



-- Write a query to count how many different subreddits there are.
SELECT COUNT(*) AS 'subreddit_count'
FROM subreddits;



-- Write a few more queries to figure out the following information:
-- What user has the highest score?
-- What post has the highest score?
-- What are the top 5 subreddits with the highest subscriber_count?
SELECT username, MAX(score)
FROM users;

SELECT title, MAX(score)
FROM posts;

SELECT name
FROM subreddits
ORDER BY subscriber_count DESC
LIMIT 5;



-- Now let’s join the data from the different tables to find out some more information.
-- Use a LEFT JOIN with the users and posts tables to find out how many posts each user has made. 
-- Have the users table as the left table and order the data by the number of posts in descending order.
SELECT users.username, COUNT(*) AS 'posts_made'
FROM users
LEFT JOIN posts
  ON users.id = posts.user_id
GROUP BY users.id
ORDER BY 2 DESC;
 


-- Over time, posts may be removed and users might delete their accounts.
-- We only want to see existing posts where the users are still active, so use an INNER JOIN to write a query to get these posts.
-- Have the posts table as the left table.
SELECT *
FROM posts
INNER JOIN users
  ON posts.user_id = users.id;



-- Some new posts have been added to Reddit!
-- Stack the new posts2 table under the existing posts table to see them.
SELECT *
FROM posts
UNION
SELECT *
FROM posts2;



-- Now you need to find out which subreddits have the most popular posts. We’ll say that a post is popular if it has a score of at least 5000. We’ll do this using a WITH and a JOIN.
-- First, you’ll need to create the temporary table that we’ll nest in the WITH clause by writing a query to select all the posts that have a score of at least 5000.
-- Next, place the previous query within a WITH clause, and alias this table as popular_posts.
-- Finally, utilize an INNER JOIN to join this table with the subreddits table, with subreddits as the left table.
-- Select the subreddit name, the title and score of each post, and order the results by each popular post’s score in descending order.
WITH popular_posts AS (
  SELECT *
  FROM posts
  WHERE score >= 5000
)
SELECT subreddits.name,
  popular_posts.title,
  popular_posts.score
FROM subreddits
INNER JOIN popular_posts
  ON subreddits.id = popular_posts.subreddit_id
ORDER BY popular_posts.score DESC;



-- Next, you need to find out the highest scoring post for each subreddit.
-- Do this by using an INNER JOIN, with posts as the left table.
SELECT posts.title,
  subreddits.name,
  MAX(posts.score) AS 'highest_score'
FROM posts
INNER JOIN subreddits
  ON posts.subreddit_id = subreddits.id
GROUP BY subreddits.id;



-- Finally, you need to write a query to calculate the average score of all the posts for each subreddit.
-- Consider utilizing a JOIN, AVG, and GROUP BY to accomplish this, with the subreddits table as the left table.
SELECT subreddits.name,
  AVG(posts.score ) AS 'average_score'
FROM subreddits
INNER JOIN posts
  ON subreddits.id = posts.subreddit_id
GROUP BY subreddits.name
ORDER BY 2 DESC;







