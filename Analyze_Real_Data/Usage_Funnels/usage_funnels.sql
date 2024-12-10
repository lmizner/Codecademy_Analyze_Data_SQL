-- Start by getting a feel for the survey_responses table.
-- Select all columns for the first 10 records from survey_responses.
SELECT *
FROM survey_responses
LIMIT 10; 


-- Now, let’s build our first basic funnel!
-- Count the number of distinct user_id who answered each question_text.
-- You can do this by using a simple GROUP BY command.
-- What is the number of responses for each question?
SELECT question_text, 
  COUNT(DISTINCT(user_id))
FROM survey_responses
GROUP BY question_text;




-- Start by getting a feel for the onboarding_modals table.
-- Select all columns for the first 10 records from onboarding_modals.
SELECT *
FROM onboarding_modals
LIMIT 10;


-- Now, using GROUP BY, count the number of distinct user_id‘s for each value of modal_text.
-- This will tell us the number of users completing each step of the funnel.
-- This time, sort modal_text so that your funnel is in order.
SELECT modal_text, 
  COUNT(DISTINCT(user_id))
FROM onboarding_modals
GROUP BY modal_text
ORDER BY modal_text;



-- The previous query combined both the control and variant groups.
-- We can use a CASE statement within our COUNT() aggregate so that we only count user_ids whose ab_group is equal to ‘control’.
SELECT modal_text,
  COUNT(DISTINCT CASE
    WHEN ab_group = 'control' THEN user_id
    END) AS 'control_clicks'
FROM onboarding_modals
GROUP BY 1
ORDER BY 1;


-- Add an additional column to your previous query that counts the number of clicks from the variant group and alias it as ‘variant_clicks’.
SELECT modal_text,
  COUNT(DISTINCT CASE
    WHEN ab_group = 'control' THEN user_id
    END) AS 'control_clicks',
  COUNT(DISTINCT CASE
    WHEN ab_group = 'variant' THEN
    user_id
    END) AS 'variant_clicks'
FROM onboarding_modals
GROUP BY 1
ORDER BY 1;




-- Let’s examine each table. Note that each user has multiple rows representing the different items that she has placed in her cart.
-- What are the column names in each table?
SELECT *
FROM browse
LIMIT 5;

SELECT *
FROM checkout
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;


-- Start by selecting all rows (*) from the LEFT JOIN of:
--   - browse (aliased as b)
--   - checkout (aliased as c)
--   - purchase (aliased as p)
--   - Be sure to use this order to make sure that we get all of the rows.
-- LIMIT your results to the first 50 so that it loads quickly.
SELECT *
FROM browse AS 'b'
LEFT JOIN checkout AS 'c'
  ON c.user_id = b.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = c.user_id
LIMIT 50;


-- But we don’t want all of these columns in the result!
-- Instead of selecting all columns using *, let’s select these four:
--   - DISTINCT b.browse_date
--   - b.user_id
--   - c.user_id IS NOT NULL AS 'is_checkout'
--   - p.user_id IS NOT NULL AS 'is_purchase'
-- Edit your query so that you select these columns.
SELECT DISTINCT b.browse_date, 
  b.user_id, 
  c.user_id IS NOT NULL AS 'is_checkout',
  p.user_id IS NOT NULL AS 'is_purchase'
FROM browse AS 'b'
LEFT JOIN checkout AS 'c'
  ON c.user_id = b.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = c.user_id
LIMIT 50;


-- First, add a column that counts the total number of rows in funnels.
-- Alias this column as ‘num_browse’.
-- This is the number of users in the “browse” step of the funnel.
WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT COUNT(*) AS 'num_browse'
FROM funnels;


-- Second, add another column that sums the is_checkout in funnels.
-- Alias this column as ‘num_checkout’.
-- This is the number of users in the “checkout” step of the funnel.
WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT COUNT(*) AS 'num_browse',
  SUM(is_checkout) AS 'num_checkout'
FROM funnels;


-- Third, add another column that sums the is_purchase column in funnels.
-- Alias this column as ‘num_purchase’.
-- This is the number of users in the “purchase” step of the funnel.
WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT COUNT(*) AS 'num_browse',
  SUM(is_checkout) AS 'num_checkout',
  SUM(is_purchase) AS 'num_purchase'
FROM funnels;


-- Finally, let’s do add some more calculations to make the results more in depth.
-- Let’s add these two columns:  
--   - Percentage of users from browse to checkout
--   - Percentage of users from checkout to purchase
WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT COUNT(*) AS 'num_browse',
   SUM(is_checkout) AS 'num_checkout',
   SUM(is_purchase) AS 'num_purchase',
   1.0 * SUM(is_checkout) / COUNT(user_id) AS 'browse_to_checkout',
   1.0 * SUM(is_purchase) / SUM(is_checkout) AS 'checkout_to_purchase'
FROM funnels;


-- Edit the code so that the first column in the result is browse_date.
-- Then, use GROUP BY so that we calculate num_browse, num_checkout, and num_purchase for each browse_date.
-- Also be sure to ORDER BY browse_date.
WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT browse_date,
   COUNT(*) AS 'num_browse',
   SUM(is_checkout) AS 'num_checkout',
   SUM(is_purchase) AS 'num_purchase',
   1.0 * SUM(is_checkout) / COUNT(user_id) AS 'browse_to_checkout',
   1.0 * SUM(is_purchase) / SUM(is_checkout) AS 'checkout_to_purchase'
FROM funnels
GROUP BY browse_date
ORDER BY browse_date;









