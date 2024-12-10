-- Take a look at the first 100 rows of data in the subscriptions table. How many different segments do you see?
SELECT *
FROM subscriptions
LIMIT 100;


-- Determine the range of months of data provided. Which months will you be able to calculate churn for?
SELECT MIN(subscription_start), 
  MAX(subscription_start)
FROM subscriptions;


-- You’ll be calculating the churn rate for both segments (87 and 30) over the first 3 months of 2017
-- (you can’t calculate it for December, since there are no subscription_end values yet). 
-- To get started, create a temporary table of months.
WITH months AS (
    SELECT
        '2017-01-01' AS first_day,
        '2017-01-31' AS last_day
    UNION
    SELECT
        '2017-02-01' AS first_day,
        '2017-02-28' AS last_day
    UNION
    SELECT
        '2017-03-01' AS first_day,
        '2017-03-31' AS last_day
)
SELECT * FROM months;


-- Create a temporary table, cross_join, from subscriptions and your months. Be sure to SELECT every column.
WITH months AS (
    SELECT
        '2017-01-01' AS first_day,
        '2017-01-31' AS last_day
    UNION
    SELECT
        '2017-02-01' AS first_day,
        '2017-02-28' AS last_day
    UNION
    SELECT
        '2017-03-01' AS first_day,
        '2017-03-31' AS last_day
),
cross_join AS (
    SELECT 
        subscriptions.*,
        months.*
    FROM 
        subscriptions
    CROSS JOIN 
        months
)
SELECT * FROM cross_join;


-- Create a temporary table, status, from the cross_join table you created. This table should contain:
--     - id selected from cross_join
--     - month as an alias of first_day
--     - is_active_87 created using a CASE WHEN to find any users from segment 87 who existed prior to the beginning of the month. This is 1 if true and 0 otherwise.
--     - is_active_30 created using a CASE WHEN to find any users from segment 30 who existed prior to the beginning of the month. This is 1 if true and 0 otherwise.
WITH months AS (
    SELECT
        '2017-01-01' AS first_day,
        '2017-01-31' AS last_day
    UNION
    SELECT
        '2017-02-01' AS first_day,
        '2017-02-28' AS last_day
    UNION
    SELECT
        '2017-03-01' AS first_day,
        '2017-03-31' AS last_day
),
cross_join AS (
    SELECT 
        subscriptions.*,
        months.*
    FROM 
        subscriptions
    CROSS JOIN 
        months
),
status AS (
    SELECT
        cross_join.id,
        cross_join.first_day AS month,
        CASE 
            WHEN cross_join.segment = 87 
                 AND cross_join.subscription_start <= cross_join.first_day 
                 AND (cross_join.subscription_end IS NULL OR cross_join.subscription_end >= cross_join.first_day) 
            THEN 1 ELSE 0 
        END AS is_active_87,
        CASE 
            WHEN cross_join.segment = 30 
                 AND cross_join.subscription_start <= cross_join.first_day 
                 AND (cross_join.subscription_end IS NULL OR cross_join.subscription_end >= cross_join.first_day) 
            THEN 1 ELSE 0 
        END AS is_active_30
    FROM 
        cross_join
)
SELECT * FROM status;


-- Add an is_canceled_87 and an is_canceled_30 column to the status temporary table. This should be 1 if the subscription is canceled during the month and 0 otherwise.
WITH months AS (
    SELECT
        '2017-01-01' AS first_day,
        '2017-01-31' AS last_day
    UNION
    SELECT
        '2017-02-01' AS first_day,
        '2017-02-28' AS last_day
    UNION
    SELECT
        '2017-03-01' AS first_day,
        '2017-03-31' AS last_day
),
cross_join AS (
    SELECT 
        subscriptions.*,
        months.*
    FROM 
        subscriptions
    CROSS JOIN 
        months
),
status AS (
    SELECT
        cross_join.id,
        cross_join.first_day AS month,
        CASE 
            WHEN cross_join.segment = 87 
                 AND cross_join.subscription_start <= cross_join.first_day 
                 AND (cross_join.subscription_end IS NULL OR cross_join.subscription_end >= cross_join.first_day) 
            THEN 1 ELSE 0 
        END AS is_active_87,
        CASE 
            WHEN cross_join.segment = 30 
                 AND cross_join.subscription_start <= cross_join.first_day 
                 AND (cross_join.subscription_end IS NULL OR cross_join.subscription_end >= cross_join.first_day) 
            THEN 1 ELSE 0 
        END AS is_active_30,
        CASE 
            WHEN cross_join.segment = 87 
                 AND cross_join.subscription_end >= cross_join.first_day 
                 AND cross_join.subscription_end <= cross_join.last_day 
            THEN 1 ELSE 0 
        END AS is_canceled_87,
        CASE 
            WHEN cross_join.segment = 30 
                 AND cross_join.subscription_end >= cross_join.first_day 
                 AND cross_join.subscription_end <= cross_join.last_day 
            THEN 1 ELSE 0 
        END AS is_canceled_30
    FROM 
        cross_join
)
SELECT * FROM status;



-- Create a status_aggregate temporary table that is a SUM of the active and canceled subscriptions for each segment, for each month.
-- The resulting columns should be:
--     - sum_active_87
--     - sum_active_30
--     - sum_canceled_87
--     - sum_canceled_30
WITH months AS (
    SELECT
        '2017-01-01' AS first_day,
        '2017-01-31' AS last_day
    UNION
    SELECT
        '2017-02-01' AS first_day,
        '2017-02-28' AS last_day
    UNION
    SELECT
        '2017-03-01' AS first_day,
        '2017-03-31' AS last_day
),
cross_join AS (
    SELECT 
        subscriptions.*,
        months.*
    FROM 
        subscriptions
    CROSS JOIN 
        months
),
status AS (
    SELECT
        cross_join.id,
        cross_join.first_day AS month,
        
        -- is_active columns
        CASE 
            WHEN cross_join.segment = 87 
                 AND cross_join.subscription_start <= cross_join.first_day 
                 AND (cross_join.subscription_end IS NULL OR cross_join.subscription_end >= cross_join.first_day) 
            THEN 1 ELSE 0 
        END AS is_active_87,
        CASE 
            WHEN cross_join.segment = 30 
                 AND cross_join.subscription_start <= cross_join.first_day 
                 AND (cross_join.subscription_end IS NULL OR cross_join.subscription_end >= cross_join.first_day) 
            THEN 1 ELSE 0 
        END AS is_active_30,
        
        -- is_canceled columns
        CASE 
            WHEN cross_join.segment = 87 
                 AND cross_join.subscription_end >= cross_join.first_day 
                 AND cross_join.subscription_end <= cross_join.last_day 
            THEN 1 ELSE 0 
        END AS is_canceled_87,
        CASE 
            WHEN cross_join.segment = 30 
                 AND cross_join.subscription_end >= cross_join.first_day 
                 AND cross_join.subscription_end <= cross_join.last_day 
            THEN 1 ELSE 0 
        END AS is_canceled_30
    FROM 
        cross_join
),
status_aggregate AS (
    SELECT
        month,
        SUM(is_active_87) AS sum_active_87,
        SUM(is_active_30) AS sum_active_30,
        SUM(is_canceled_87) AS sum_canceled_87,
        SUM(is_canceled_30) AS sum_canceled_30
    FROM 
        status
    GROUP BY 
        month
    ORDER BY 
        month
)
SELECT * FROM status_aggregate;


-- Calculate the churn rates for the two segments over the three month period. Which segment has a lower churn rate?
WITH months AS (
    SELECT
        '2017-01-01' AS first_day,
        '2017-01-31' AS last_day
    UNION
    SELECT
        '2017-02-01' AS first_day,
        '2017-02-28' AS last_day
    UNION
    SELECT
        '2017-03-01' AS first_day,
        '2017-03-31' AS last_day
),
cross_join AS (
    SELECT 
        subscriptions.*,
        months.*
    FROM 
        subscriptions
    CROSS JOIN 
        months
),
status AS (
    SELECT
        cross_join.id,
        cross_join.first_day AS month,
        
        -- is_active columns
        CASE 
            WHEN cross_join.segment = 87 
                 AND cross_join.subscription_start <= cross_join.first_day 
                 AND (cross_join.subscription_end IS NULL OR cross_join.subscription_end >= cross_join.first_day) 
            THEN 1 ELSE 0 
        END AS is_active_87,
        CASE 
            WHEN cross_join.segment = 30 
                 AND cross_join.subscription_start <= cross_join.first_day 
                 AND (cross_join.subscription_end IS NULL OR cross_join.subscription_end >= cross_join.first_day) 
            THEN 1 ELSE 0 
        END AS is_active_30,
        
        -- is_canceled columns
        CASE 
            WHEN cross_join.segment = 87 
                 AND cross_join.subscription_end >= cross_join.first_day 
                 AND cross_join.subscription_end <= cross_join.last_day 
            THEN 1 ELSE 0 
        END AS is_canceled_87,
        CASE 
            WHEN cross_join.segment = 30 
                 AND cross_join.subscription_end >= cross_join.first_day 
                 AND cross_join.subscription_end <= cross_join.last_day 
            THEN 1 ELSE 0 
        END AS is_canceled_30
    FROM 
        cross_join
),
status_aggregate AS (
    SELECT
        month,
        SUM(is_active_87) AS sum_active_87,
        SUM(is_active_30) AS sum_active_30,
        SUM(is_canceled_87) AS sum_canceled_87,
        SUM(is_canceled_30) AS sum_canceled_30
    FROM 
        status
    GROUP BY 
        month
),
churn_rates AS (
    SELECT
        '87' AS segment,
        SUM(sum_canceled_87) AS total_canceled,
        SUM(sum_active_87) AS total_active,
        ROUND(SUM(sum_canceled_87) * 1.0 / NULLIF(SUM(sum_active_87), 0), 4) AS churn_rate
    FROM 
        status_aggregate
    UNION ALL
    SELECT
        '30' AS segment,
        SUM(sum_canceled_30) AS total_canceled,
        SUM(sum_active_30) AS total_active,
        ROUND(SUM(sum_canceled_30) * 1.0 / NULLIF(SUM(sum_active_30), 0), 4) AS churn_rate
    FROM 
        status_aggregate
)
SELECT * FROM churn_rates;








