-- Before moving on, take a look at the data in the bakery table.
-- In the code editor, write the query to select the first 5 rows.
-- What are the column names?
SELECT *
FROM bakery
LIMIT 5;


-- And now take a look at the data in the guesses table.
-- Delete the old query and write a new query to select the first 5 rows of guesses.
-- What are the column names?
SELECT *
FROM guesses
LIMIT 5;


-- From the bakery table, compute the total cost (price times quantity) of each order.
SELECT price * quantity
FROM bakery;


-- A school holds an event every month where a glass jar is filled with jelly beans, and students can guess how many jelly beans are contained in the jar.
-- Students who make the closest guess win a pack of new notebooks.
-- Using the guesses table with the ABS() function, write a query to find out how close each student’s guess is to the actual number of jelly beans in the jar,
-- which is 804. Select the first name and the absolute difference of each guess from 804.
-- How close are each of the guesses?
SELECT first_name, ABS(guess - 804)
FROM guesses;


-- Find out the absolute value of the difference between the average guess of all students from the actual jelly bean count, which is 804.
-- Is the average guess close to the actual count?
SELECT ABS(AVG(guess) - 804)
FROM guesses;


-- From the bakery table, we want to determine the final price of each order after the discount is applied.
-- However, the value of each discount is currently stored as TEXT, like '1.00 off', so you will need to convert them into numerical values.
-- Utilize CAST() to convert the values of the discount column into REAL values. 
-- Select the item_name column and the total cost of each order, after applying the discount for each item.
SELECT item_name, (price - CAST(discount AS REAL)) * quantity
FROM bakery;


-- Write a query to select just the dates for each order’s order_date column from the bakery table.
SELECT DATE(order_date)
FROM bakery;


-- For each order in the bakery table, the order will be ready for pick up 2 days after the order is made, at 7:00AM, 7 days a week. The order will always be ready 2 days after the order, no matter what time of day the order was made.
-- Utilizing the date and time functions and some modifiers, find out when each order can be picked up.
SELECT DATETIME(order_date, 'start of day', '+2 days', '+7 hours')
FROM bakery;


-- The owners of the bakery want to find out what day most people placed orders.
-- Use STRFTIME() with the COUNT() function to find out how many orders were made on each day. Show the results in descending order based on the daily number of orders.
SELECT strftime('%d', order_date) AS 'order_day',
  COUNT(*) 
FROM bakery 
GROUP BY 1
ORDER BY 2 DESC;













