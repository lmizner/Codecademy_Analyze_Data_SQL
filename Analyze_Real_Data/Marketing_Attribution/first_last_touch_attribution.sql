-- Select the first 10 rows of the page_visits table. Make sure you understand the significance of each column before moving on!
SELECT *
FROM page_visits
LIMIT 10;


-- Find June’s rows in the table! Select all columns from the page_visits table, using a WHERE clause with:
--     - user_id equals 10069 and
--     - utm_source equals 'buzzfeed'
SELECT *
FROM page_visits
WHERE user_id = 10069
  AND utm_source = 'buzzfeed';


-- Find all of June’s rows, using a WHERE clause with just user_id.
SELECT *
FROM page_visits
WHERE user_id = 10069;


-- June’s sister also visited CoolTShirts.com!
-- Select all columns from the page_visits table, using a WHERE clause with user_id = 10329 .
-- What are her first- and last-touch attributions?
SELECT *
FROM page_visits
WHERE user_id = 10329;


-- Find all last touches. Your query will look similar to the first_touch query above.
SELECT user_id,
  MAX(timestamp) AS 'last_touch_at'
FROM page_visits
GROUP BY user_id;


-- Make sure June’s last touch at 08:13:01 is in the data.
-- Add a WHERE clause for user_id = 10069 to your existing query. 
SELECT user_id,
  MAX(timestamp) AS 'last_touch_at'
FROM page_visits
WHERE user_id = 10069
GROUP BY user_id;


-- Write the LAST-touch attribution query and run it.
WITH last_touch AS(
  SELECT user_id, 
    MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id
)
SELECT last_touch.user_id,
  last_touch.last_touch_at,
  page_visits.utm_source
FROM last_touch
JOIN page_visits
  ON last_touch.user_id = page_visits.user_id
  AND last_touch.last_touch_at = page_visits.timestamp;


-- Make sure June’s last touch at 08:13:01 is still there!
-- Add a WHERE clause for user_id = 10069 to your existing query. 
WITH last_touch AS(
  SELECT user_id, 
    MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id
)
SELECT last_touch.user_id,
  last_touch.last_touch_at,
  page_visits.utm_source
FROM last_touch
JOIN page_visits
  ON last_touch.user_id = page_visits.user_id
  AND last_touch.last_touch_at = page_visits.timestamp
WHERE last_touch.user_id = 10069;
















