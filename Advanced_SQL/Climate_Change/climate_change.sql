-- Let’s see what our table contains by running the following command
SELECT *
FROM state_climate;


-- Let’s start by looking at how the average temperature changes over time in each state.
-- Write a query that returns the state, year, tempf or tempc, and running_avg_temp (in either Celsius or Fahrenheit) for each state.
-- (The running_avg_temp should use a window function.)
SELECT state, year, tempf, 
  AVG(tempf) OVER (
    PARTITION BY state
    ORDER BY year
  ) AS running_avg_temp
FROM state_climate;


-- Now let’s explore the lowest temperatures for each state.
-- Write a query that returns state, year, tempf or tempc, and the lowest temperature (lowest_temp) for each state.
-- Are the lowest recorded temps for each state more recent or more historic?
SELECT state, year, tempf, 
    MIN(tempf) OVER (
        PARTITION BY state
    ) AS lowest_temp
FROM state_climate;


-- Like before, write a query that returns state, year, tempf or tempc, except now we will also return the highest temperature (highest_temp) for each state.
-- Are the highest recorded temps for each state more recent or more historic?
SELECT state,
  year,
  tempf AS highest_temp
FROM state_climate
WHERE tempf = (
  SELECT MAX(tempf) 
  FROM state_climate sc
  WHERE sc.state = state_climate.state
);


-- Let’s see how temperature has changed each year in each state.
-- Write a query to select the same columns but now you should write a window function that returns the change_in_temp from the previous year (no null values should be returned).
-- Which states and years saw the largest changes in temperature?
-- Is there a particular part of the United States that saw the largest yearly changes in temperature?
SELECT state,
  year,
  tempf,
  change_in_temp
FROM (SELECT state,
        year,
        tempf, 
        tempf - LAG(tempf) OVER (
          PARTITION BY state
          ORDER BY year
        ) AS change_in_temp
    FROM state_climate
) AS subquery
WHERE change_in_temp IS NOT NULL;


-- Write a query to return a rank of the coldest temperatures on record (coldest_rank) along with year, state, and tempf or tempc.
-- Are the coldest ranked years recent or historic? The coldest years should be from any state or year.
SELECT year,
  state,
  tempf, 
  RANK() OVER (
    ORDER BY tempf ASC
  ) AS coldest_rank
FROM state_climate
ORDER BY coldest_rank;


-- Modify your coldest_rank query to now instead return the warmest_rank for each state, meaning your query should return the warmest temp/year for each state. Again, are the warmest temperatures more recent or historic for each state?
SELECT year,
  state,
  tempf, 
  RANK() OVER (
    PARTITION BY state
    ORDER BY tempf DESC
  ) AS warmest_rank
FROM state_climate
ORDER BY state, warmest_rank;


-- Let’s now write a query that will return the average yearly temperatures in quartiles instead of in rankings for each state.
-- Your query should return quartile, year, state and tempf or tempc. The top quartile should be the coldest years.
-- Are the coldest years more recent or historic?
SELECT NTILE(4) OVER (
  PARTITION BY state
  ORDER BY tempf ASC
  ) AS quartile,
  year,
  state,
  tempf  
FROM state_climate
ORDER BY state, quartile;


-- Lastly, we will write a query that will return the average yearly temperatures in quintiles (5).
-- Your query should return quintile, year, state and tempf or tempc. The top quintile should be the coldest years overall, not by state.
-- What is different about the coldest quintile now?
SELECT NTILE(5) OVER (
  ORDER BY tempf ASC
  ) AS quintile,
  year,
  state,
  tempf 
FROM state_climate
ORDER BY quintile;





