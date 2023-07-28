-- Example
-- In a quiz question in the previous Basic SQL lesson, you saw this question:
-- Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for 
-- standard paper for each order. Limit the results to the first 10 orders, and include the id and 
-- account_id fields. NOTE - you will be thrown an error with the correct solution to this question. 
-- This is for a division by zero. You will learn how to get a solution without an error to this query 
-- when you learn about CASE statements in a later section.


-- Let's see how we can use the CASE statement to get around this error.

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;
-- Now, let's use a CASE statement. This way any time the standard_qty is zero, we will return 0, and otherwise we will return the unit_price.

SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;
-- Now the first part of the statement will catch any of those division by zero values that were causing the 
-- error, and the other components will compute the division as necessary. You will notice, we essentially 
-- charge all of our accounts 4.99 for standard paper. It makes sense this doesn't fluctuate, and it is more 
-- accurate than adding 1 in the denominator like our quick fix might have been in the earlier lesson.
-- You can try it yourself using the environment below.


-- USE OF WITH statement
WITH events AS (SELECT DATE_TRUNC('day', occurred_at) AS day,
    channel, COUNT(*) AS events_count
    FROM web_events
    GROUP BY 1, 2
)

SELECT channel, AVG(events_count) AS avg_event_count
FROM events
GROUP BY 1
ORDER BY 2 DESC


-- 6.
WITH all_times as (SELECT AVG(total_amt_usd) avg_all
FROM orders),

percompany as (SELECT name, AVG(total_amt_usd) avg_per
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 1
HAVING AVG(total_amt_usd) > (SELECT AVG(total_amt_usd) avg_all
FROM orders)
ORDER BY 2 DESC
)

SELECT AVG(avg_per) as life_time_avg
FROM percompany

-- 5.
WITH top10 AS (SELECT accounts.name, SUM(orders.total_amt_usd)
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10)

SELECT AVG(sum) 
FROM top10

-- 4.
WITH sum_table AS (SELECT accounts.id as iden, SUM(total_amt_usd) bestSum
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1)

SELECT account_id, channel, COUNT(*) as numberOfEvents
FROM web_events
GROUP BY 1,2
HAVING account_id = (SELECT iden
FROM sum_table)
ORDER BY 2,3 DESC

-- 3.
WITH t1 AS (
      SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
      FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 1), 
t2 AS (
      SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (SELECT total FROM t1))
SELECT COUNT(*)
FROM t2;

-- 4.
WITH t1 AS (
      SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 5.
WITH t1 AS (
      SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 10)
SELECT AVG(tot_spent)
FROM t1;

-- 6.
WITH t1 AS ( SELECT AVG(o.total_amt_usd) avg_all
FROM orders o JOIN accounts a ON a.id = o.account_id),
t2 AS ( SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
FROM orders o GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt) FROM t2;
