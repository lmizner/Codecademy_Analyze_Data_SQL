-- To help users find their perfect frame, Warby Parker has a Style Quiz that has the following questions:

-- 1. “What are you looking for?”
-- 2. “What’s your fit?”
-- 3. “Which shapes do you like?”
-- 4. “Which colors do you like?”
-- 5. “When was your last eye exam?”

-- The users’ responses are stored in a table called survey.
-- Select all columns from the first 10 rows. What columns does the table have?
SELECT *
FROM survey
LIMIT 10;


-- Users will “give up” at different points in the survey.
-- Let’s analyze how many users move from Question 1 to Question 2, etc.
-- Create a quiz funnel using the GROUP BY command.
-- What is the number of responses for each question?
SELECT question, 
  COUNT(DISTINCT(user_id))
FROM survey
GROUP BY question
ORDER BY question;


-- Calculate the percentage of users who answer each question.
-- Which question(s) of the quiz have a lower completion rates?
-- What do you think is the reason?
WITH total_users AS (
  SELECT COUNT(DISTINCT user_id) AS total_user_count
  FROM survey
)
SELECT 
  question, 
  COUNT(DISTINCT user_id) AS user_count, 
  ROUND((COUNT(DISTINCT user_id) * 100.0) / (SELECT total_user_count FROM total_users), 2) AS response_percentage
FROM survey
GROUP BY question
ORDER BY question;




-- Warby Parker’s purchase funnel is:
-- Take the Style Quiz → Home Try-On → Purchase the Perfect Pair of Glasses
-- During the Home Try-On stage, we will be conducting an A/B Test:
--     - 50% of the users will get 3 pairs to try on
--     - 50% of the users will get 5 pairs to try on

-- Let’s find out whether or not users who get more pairs to try on at home will be more likely to make a purchase.
-- The data will be distributed across three tables:
--     - quiz
--     - home_try_on
--     - purchase

-- Examine the first five rows of each table
-- What are the column names?
SELECT * 
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;


-- We’d like to create a new table. Each row will represent a single user from the browse table:
--     - If the user has any entries in home_try_on, then is_home_try_on will be True.
--     - number_of_pairs comes from home_try_on table
--     - If the user has any entries in purchase, then is_purchase will be True.

-- Use a LEFT JOIN to combine the three tables, starting with the top of the funnel (quiz) and ending with the bottom of the funnel (purchase).
-- Select only the first 10 rows from this table (otherwise, the query will run really slowly).
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;




