-- Run a query to select all the information in our new data table streams.
-- What are the column names?
SELECT *
FROM streams;


-- Let’s look at a window function that uses LAG. We will look at the artist’s current number of streams and their streams from the previous week.
-- LAG takes up to three arguments:
--     - column (required)
--     - offset (optional, default 1 row offset)
--     - default (optional, what to replace default null values with)
SELECT artist,
  week,
  streams_millions,
  LAG(streams_millions, 1, 0) OVER (
    ORDER BY week 
  ) previous_week_streams 
FROM streams 
WHERE artist = 'Lady Gaga';


-- Displaying the previous row value in each row can be useful, but for our purposes let’s change our LAG function to instead show the change in streams for Lady Gaga per week.
-- To do this, we just need to subtract the current week’s streams_millions by our LAG function value (which is returning the previous week’s streams_millions).
SELECT artist,
  week,
  streams_millions,
  streams_millions - LAG(streams_millions, 1, streams_millions) OVER ( 
    ORDER BY week 
  ) streams_millions_change
FROM streams 
WHERE artist = 'Lady Gaga';


-- Build upon our current query to use PARTITION BY to show the change in streams for “Lady Gaga” as well as the change in chart position.
SELECT artist,
  week,
  streams_millions,
  streams_millions - LAG(streams_millions, 1, streams_millions) OVER ( 
    PARTITION BY artist
    ORDER BY week 
  ) AS 'streams_millions_change',
  chart_position,
  LAG(chart_position, 1, chart_position) OVER ( 
    PARTITION BY artist
    ORDER BY week 
) - chart_position AS 'chart_position_change'
FROM streams
WHERE artist = 'Lady Gaga';


-- Because LEAD looks to future rows, we need to flip how we subtract in order to find the streams_millions_change.
-- We will subtract the current row’s streams_millions from the next row’s streams_millions in order to see an accurate reflection of how the number of streams has changed.
SELECT artist,
  week,
  streams_millions,
  LEAD(streams_millions, 1) OVER (
    PARTITION BY artist
    ORDER BY week
  ) - streams_millions AS 'streams_millions_change'
FROM streams;


-- Now modify your query to make it return the chart_position and chart_position_change as well, like we did for LAG.
SELECT artist,
  week,
  streams_millions,
  LEAD(streams_millions, 1) OVER (
    PARTITION BY artist
    ORDER BY week
  ) - streams_millions AS 'streams_millions_change',
  chart_position,
  chart_position - LEAD(chart_position, 1) OVER ( 
    PARTITION BY artist
    ORDER BY week 
) AS 'chart_position_change'
FROM streams;


-- Here is a query that uses the ROW_NUMBER function, which is quite easy!
-- All we need is to write ROW_NUMBER() OVER and then the column you’d like to number by
SELECT ROW_NUMBER() OVER (
    ORDER BY streams_millions
  ) AS 'row_num', 
  artist, 
  week,
  streams_millions
FROM streams;


-- Modify our query to return the results with row_num = 1 being the most streams.
SELECT ROW_NUMBER() OVER (
    ORDER BY streams_millions DESC
  ) AS 'row_num', 
  artist, 
  week,
  streams_millions
FROM streams;


-- Run the following query. What happened to our first 3 results?
SELECT RANK() OVER (
    ORDER BY streams_millions
  ) AS 'rank', 
  artist, 
  week,
  streams_millions
FROM streams;


-- Now modify your query to return the results so that the streams are ranked with 1 being the most streams in our dataset.
SELECT RANK() OVER (
    ORDER BY streams_millions DESC
  ) AS 'rank', 
  artist, 
  week,
  streams_millions
FROM streams;


-- Lastly, modify the query that it is partitioning our results by week so we can see the most streamed artist of each week.
SELECT RANK() OVER (
    PARTITION BY week
    ORDER BY streams_millions DESC
  ) AS 'rank', 
  artist, 
  week,
  streams_millions
FROM streams;


-- Think about the following:
--     - What does each NTILE represent?
--     - If you’re in weekly_streams_group 1, are you the most or least streamed artist?
--     - What artists make up the most streamed grouping?
SELECT NTILE(5) OVER (
    ORDER BY streams_millions DESC
  ) AS 'weekly_streams_group', 
  artist, 
  week,
  streams_millions
FROM streams;


-- Change our NTILE query to be a quartile, name the column quartile and run the query. How does this change our resultant data? What artists are now in the top quartile?
SELECT NTILE(4) OVER (
    ORDER BY streams_millions DESC
  ) AS 'quartile', 
  artist, 
  week,
  streams_millions
FROM streams;


-- Now change our query to also PARTITION BY week.
-- How does this change our data?
SELECT NTILE(4) OVER (
    PARTITION BY week
    ORDER BY streams_millions DESC
  ) AS 'quartile', 
  artist, 
  week,
  streams_millions
FROM streams;




