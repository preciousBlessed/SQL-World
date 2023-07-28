SELECT accounts.primary_poc, web_events.channel, web_events.occurred_at
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
WHERE a.name = 'Walmart';


-- Important to note here that without the ALIAS, the name columns would return only one name column
SELECT sales_reps.name SRName, accounts.name ACName, region.name RGName
FROM sales_reps
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
JOIN region
ON sales_reps.region_id = region.id
ORDER BY accounts.name


--Another exercise
SELECT region.name regionName, accounts.name accountName,
orders.total_amt_usd/(orders.total+0.001) AS unitPrice
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region
ON sales_reps.region_id = region.id

-- Left JOIN
SELECT a.id, a.name, o.total
FROM orders O
LEFT JOIN accounts a
ON O.account_id = a.id

-- Right JOIN
SELECT a.id, a.name, o.total
FROM orders O
RIGHT JOIN accounts a
ON O.account_id = a.id

-- Interchanging Left and Right Join by playing with the FROM and JOIN statements
SELECT a.id, a.name, o.total
FROM accounts a
LEFT JOIN orders o
ON O.account_id = a.id


-- MORE EXERCISE FROM LAST QUIZ ON JOINS
-- 1.
--- Provide a table that provides the region for each sales_rep along with their associated accounts.
-- This time only for the Midwest region. Your final table should include three columns: the region name,
-- the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.---
SELECT region.name regionName, sales_reps.name salesRepName, accounts.name acctName
FROM sales_reps 
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
WHERE region.name = 'Midwest'
ORDER BY accounts.name

-- 2.
-- Provide a table that provides the region for each sales_rep along with their associated accounts.
-- This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
-- Your final table should include three columns: the region name, the sales rep name, and the account name.
-- Sort the accounts alphabetically (A-Z) according to account name.
SELECT region.name regionName, sales_reps.name salesRepName, accounts.name acctName
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
WHERE sales_reps.name LIKE 'S%' AND region.name = 'Midwest'
ORDER BY accounts.name

-- 3.
-- Provide a table that provides the region for each sales_rep along with their associated accounts. 
-- This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
-- Your final table should include three columns: the region name, the sales rep name, and the account name. 
-- Sort the accounts alphabetically (A-Z) according to account name.
SELECT region.name regionName, sales_reps.name salesRepName, accounts.name acctName
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
WHERE sales_reps.name LIKE '% K%' AND region.name = 'Midwest'
ORDER BY accounts.name

-- 4.
-- Provide the name for each region for every order, as well as the account name and the unit price 
-- they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order 
-- quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. 
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
SELECT region.name regionName, accounts.name acctName, orders.total_amt_usd/(orders.total + 0.01) as unitPrice
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region
ON sales_reps.region_id = region.id
WHERE orders.standard_qty > 100
ORDER BY accounts.name

-- 5.
SELECT region.name regionName, accounts.name acctName, orders.total_amt_usd/(orders.total + 0.01) as unitPrice
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region
ON sales_reps.region_id = region.id
WHERE orders.standard_qty > 100 AND orders.poster_qty > 50
ORDER BY unitPrice

-- 6.
SELECT region.name regionName, accounts.name acctName, orders.total_amt_usd/(orders.total + 0.01) as unitPrice
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region
ON sales_reps.region_id = region.id
WHERE orders.standard_qty > 100 AND orders.poster_qty > 50
ORDER BY unitPrice DESC

-- 7.
-- What are the different channels used by account id 1001? Your final table should have 
-- only 2 columns: account name and the different channels. You can try SELECT DISTINCT to 
-- narrow down the results to only the unique values.
SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';

-- 8.
-- Find all the orders that occurred in 2015. Your final table should have 4 columns: 
-- occurred_at, account name, order total, and order total_amt_usd.
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at > '2015-01-01' AND o.occurred_at < '2015-12-31'

-- or
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;






-- EXERCISES ON GROUP-BY PART 2
-- For each account, determine the average amount of each type of paper they purchased across 
-- their orders. Your result should have four columns - one for the account 
-- name and one for the average quantity purchased for each of the paper types for each account.

SELECT accounts.name, AVG(orders.standard_qty) StandAvg,
AVG(orders.gloss_qty) GlossAvg, AVG(orders.poster_qty) PosterAvg
FROM accounts
JOIN orders ON orders.account_id = accounts.id
GROUP BY accounts.name


-- 
-- For each account, determine the average amount spent per order on each paper type. 
-- Your result should have four columns - one for the account name and one for the average 
-- amount spent on each paper type.
-- 
SELECT accounts.name, AVG(orders.standard_amt_usd) StandAvg,
AVG(orders.gloss_amt_usd) GlossAvg, AVG(orders.poster_amt_usd) PosterAvg
FROM accounts
JOIN orders ON orders.account_id = accounts.id
GROUP BY accounts.name




-- 3.Determine the number of times a particular channel was used in the web_events 
-- table for each sales rep. Your final table should have three columns - the name of 
-- the sales rep, the channel, and the number of occurrences. Order your table with 
-- the highest number of occurrences first.


SELECT sales_reps.name, channel, COUNT(web_events.channel) countMe
FROM web_events
JOIN accounts ON web_events.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
GROUP BY sales_reps.name, web_events.channel
ORDER BY countMe DESC

4.
-- This means, a particular user used this channel how many times?
-- Determine the number of times a particular channel was used in the web_events table 
-- for each region. Your final table should have three columns - the region name, the channel, 
-- and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT SUM(countMe)
FROM (SELECT region.name, channel, COUNT(web_events.channel) countMe
FROM web_events
JOIN accounts ON web_events.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN region ON sales_reps.region_id = region.id
GROUP BY region.name, web_events.channel
ORDER BY countMe desc) AS Tab
-- This means, this channel was accessed from this region how many times...
-- Now pay more attention to the inner query. I just enveloped it to count the result and
-- this gave me what I wanted, 9073




-- EXERCISE ON DISTINCT
-- 1.
-- Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

-- 2.
-- Have any sales reps worked on more than one account?
SELECT DISTINCT sales_reps.name, count(accounts.name)
FROM accounts
JOIN sales_reps on accounts.sales_rep_id = sales_reps.id
JOIN region on sales_reps.region_id = region.id
GROUP BY sales_reps.name


-- QUIZ ON HAVING
-- 1.
-- How many of the sales reps have more than 5 accounts that they manage?
SELECT COUNT(output)
FROM
(SELECT sales_reps.name, COUNT(*) accountsImanage
FROM accounts
JOIN sales_reps on accounts.sales_rep_id = sales_reps.id
JOIN region on sales_reps.region_id = region.id
GROUP BY sales_reps.name
HAVING COUNT(*) > 5) as output
-- result = 34


-- 2.
-- How many accounts have more than 20 orders?
SELECT COUNT(output)
FROM
(SELECT accounts.name, COUNT(*) ordersImade
FROM accounts
JOIN orders on orders.account_id = accounts.id
GROUP BY accounts.name
HAVING COUNT(*) > 20)  output
-- RESULT = 120

-- 3.
-- Which account has the most orders?
SELECT name
FROM(SELECT accounts.name, COUNT(*) ordersImade
FROM accounts
JOIN orders on orders.account_id = accounts.id
GROUP BY accounts.name
ORDER BY ordersImade desc) AS output
limit 1
-- returns Leucadia National

-- 4.
-- Which accounts spent more than 30,000 usd total across all orders?
SELECT accounts.name, SUM(orders.total_amt_usd) totalExpense
FROM accounts
JOIN orders on orders.account_id = accounts.id
GROUP BY accounts.name
HAVING SUM(orders.total_amt_usd) > 30000
ORDER BY totalExpense desc

-- 5.
-- Which accounts spent less than 1,000 usd total across all orders?
SELECT accounts.name, SUM(orders.total_amt_usd) totalExpense
FROM accounts
JOIN orders on orders.account_id = accounts.id
GROUP BY accounts.name
HAVING SUM(orders.total_amt_usd) < 1000
ORDER BY totalExpense desc

--6.
--Which account has spent the most with us?

SELECT name
FROM(SELECT accounts.name, SUM(orders.total_amt_usd) totalExpense
FROM accounts
JOIN orders on orders.account_id = accounts.id
GROUP BY accounts.name
ORDER BY totalExpense desc) AS output
limit 1
-- returns EOG Resources

-- 7.
-- Which account has spent the least with us?
SELECT name
FROM(SELECT accounts.name, SUM(orders.total_amt_usd) totalExpense
FROM accounts
JOIN orders on orders.account_id = accounts.id
GROUP BY accounts.name
ORDER BY totalExpense asc) AS output
limit 1
-- returns Nike

-- 8.
-- Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT accounts.name, web_events.channel, COUNT(web_events.channel) NumberOfEvents
FROM accounts
JOIN web_events on web_events.account_id = accounts.id
GROUP BY accounts.name, web_events.channel
HAVING web_events.channel = 'facebook' AND COUNT(web_events.channel) > 6
ORDER BY accounts.name, numberOfEvents
-- 46 OUTPUTS

--9.
-- Which account used facebook most as a channel?
SELECT name FROM (SELECT accounts.name, web_events.channel, COUNT(web_events.channel) NumberOfEvents
FROM accounts
JOIN web_events on web_events.account_id = accounts.id
GROUP BY accounts.name, web_events.channel
HAVING web_events.channel = 'facebook'
ORDER BY numberOfEvents desc) AS output
LIMIT 1
-- returns Gilead Sciences
-- This is like asking us to count all the times a paticular account accessed a particular channel


-- 10.
-- Which channel was most frequently used by most accounts?
SELECT channel FROM(SELECT web_events.channel, COUNT(web_events.channel) NumberOfEvents
FROM accounts
JOIN web_events on web_events.account_id = accounts.id
GROUP BY web_events.channel
ORDER BY NumberOfEvents DESC) output
LIMIT 1
-- RETURNS direct

-- This is like asking us to count all the times a paticular account accessed a particular channel



-- QUIZ ON DATE

-- 1.
-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
-- Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at), SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 2 DESC

-- -- 2.
-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly 
-- represented by the dataset?
SELECT DATE_PART('month', occurred_at), SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 2 DESC

-- 3.
-- Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly 
-- represented by the dataset?
SELECT DATE_PART('year', occurred_at), SUM(total)
FROM orders
GROUP BY 1
ORDER BY 2 DESC

-- The above is not really correct

SELECT DATE_PART('year', occurred_at), COUNT(total)
FROM orders
GROUP BY 1
ORDER BY 2 DESC

-- this is!

-- 4.
-- Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all 
-- months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 
-- December still has the most sales, but interestingly, November has the second most sales (but not the most
--  dollar sales. To make a fair comparison from one month to another 2017 and 2013 data were removed.


-- 5.
--  In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', occurred_at), SUM(gloss_amt_usd)
FROM orders
JOIN accounts ON orders.account_id = accounts.id
WHERE name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1


-- QUIZ ON CASE
-- 

-- 1.
-- Write a query to display for each order, the account ID, total amount of the order, and the level of 
-- the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
SELECT account_id, total_amt_usd, 
CASE WHEN total_amt_usd >= 3000 THEN 'large' WHEN total_amt_usd < 3000 THEN 'Small' END as level_of_order
FROM orders

-- 2.
-- Write a query to display the number of orders in each of three categories, based on the total number
--  of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 
--  'Less than 1000'.
SELECT
CASE WHEN total >= 2000 THEN 'Atleast 2000'
WHEN total >= 1000 and total < 2000 THEN 'Between 1000 and 2000'
WHEN total < 1000 THEN 'Less than 1000' END as total_group, COUNT(*)
FROM orders
GROUP BY 1

3.
-- We would like to understand 3 different levels of customers based on the amount associated with their 
-- purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater 
-- than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 
-- 100,000 usd. Provide a table that includes the level associated with each account. You should provide the 
-- account name, the total sales of all orders for the customer, and the level. Order with the top spending 
-- customers listed first.

SELECT accounts.name, SUM(orders.total_amt_usd) as total_sales_of_all_orders, 
CASE WHEN SUM(orders.total_amt_usd) > 200000 THEN 'Top'
WHEN SUM(orders.total_amt_usd) >= 100000 AND SUM(orders.total_amt_usd) < 200000 THEN 'Second'
WHEN SUM(orders.total_amt_usd) < 100000 THEN 'Lowest Level' END AS Level
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 1
ORDER BY 2 DESC



-- 4.
-- We would now like to perform a similar calculation to the first, but we want to obtain the total amount 
-- spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with 
-- the top spending customers listed first.

SELECT account_id, total_amt_usd, 
CASE WHEN total_amt_usd >= 3000 THEN 'Large' WHEN total_amt_usd < 3000 THEN 'Small' END AS level_of_order
FROM orders
WHERE occurred_at BETWEEN '2016-01-01' AND '2017-12-31'
ORDER BY 2 DESC

-- Not exactly

SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' 
GROUP BY 1
ORDER BY 2 DESC;


-- 5.
-- We would like to identify top performing sales reps, which are sales reps associated with more than 
-- 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or 
-- not depending on if they have more than 200 orders. Place the top sales people first in your final table.

SELECT sales_reps.name, COUNT(*) as number_of_orders,
CASE WHEN COUNT(*) > 200 THEN 'Top' ELSE 'Not' END AS check_against_200
FROM orders
JOIN accounts ON orders.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
GROUP BY sales_reps.name
ORDER BY 2 DESC


-- -- 6.
-- The previous didn't account for the middle, nor the dollar amount associated with the sales. 
-- Management decides they want to see these characteristics represented as well. We would like to 
-- identify top performing sales reps, which are sales reps associated with more than 200 orders or more 
-- than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 
-- Create a table with the sales rep name, the total number of orders, total sales across all orders, 
-- and a column with top, middle, or low depending on this criteria. Place the top sales people based on 
-- dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!

SELECT sales_reps.name, COUNT(1) as number_of_orders, SUM(orders.total_amt_usd) as Sales,
CASE WHEN COUNT(1) > 200 OR SUM(3) > 750000 THEN 'Top'
WHEN COUNT(1) > 150 OR SUM(3) > 500000 THEN 'Middle'
ELSE 'Low'
END AS check_against_criteria
FROM orders
JOIN accounts ON orders.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
GROUP BY sales_reps.name
ORDER BY 2 DESC



-- NEW QUIZ ON SUB-QUERIES
-- 1.
-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT name, regionName as MostSpender
FROM(SELECT sales_reps.name, region.name AS regionName, SUM(orders.total_amt_usd)
      FROM orders
      JOIN accounts ON orders.account_id = accounts.id
      JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
      JOIN region ON sales_reps.region_id = region.id
      GROUP BY 1, 2
      ORDER BY 3 DESC) sub
LIMIT 1

-- 2.
-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
SELECT totalorders
FROM (SELECT region.name, COUNT(*) totalorders
FROM orders
JOIN accounts ON orders.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN region ON sales_reps.region_id = region.id
GROUP BY 1
HAVING region.name = (SELECT regionname
FROM (SELECT regionname, SUM(sum) as totalDolzPerRegion
FROM(SELECT sales_reps.name, region.name AS regionName, SUM(orders.total_amt_usd)
      FROM orders
      JOIN accounts ON orders.account_id = accounts.id
      JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
      JOIN region ON sales_reps.region_id = region.id
      GROUP BY 1, 2
      ORDER BY 3 DESC) sub
GROUP BY 1
ORDER BY 2 DESC) sub2
LIMIT 1)) countme

--RETURNS 2357

-- or...
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
         SELECT MAX(total_amt)
         FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                 FROM sales_reps s
                 JOIN accounts a
                 ON a.sales_rep_id = s.id
                 JOIN orders o
                 ON o.account_id = a.id
                 JOIN region r
                 ON r.id = s.region_id
                 GROUP BY r.name) sub);

-- 3.
-- How many accounts had more total purchases than the account name which has bought the most
-- standard_qty paper throughout their lifetime as a customer?

SELECT COUNT(*)
FROM (SELECT accounts.name, SUM(orders.total) as totalPurchases
FROM accounts
JOIN orders ON orders.account_id = accounts.id
GROUP BY 1
HAVING SUM(orders.total) > 
(SELECT totalA
FROM (SELECT accounts.name, SUM(orders.standard_qty) total_stan_qty, SUM(accounts.total) totalA
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) sub1)) sub2b

-- 4.
-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
-- how many web_events did they have for each channel?
SELECT account_id, channel, COUNT(*) as numberOfEvents
FROM web_events
GROUP BY 1,2
HAVING account_id = (SELECT iden
  FROM(SELECT accounts.id as iden, SUM(total_amt_usd) bestSum
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) as sub1)
ORDER BY 2,3 DESC

-- 5.
-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total
-- spending accounts?

SELECT AVG(sum) 
FROM (SELECT accounts.name, SUM(orders.total_amt_usd)
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10) sub

-- returns 304846.969000000000


-- 6.

SELECT AVG(pertotalavg) AS Lifetimeavg
FROM (SELECT accounts.name, AVG(orders.total_amt_usd) pertotalavg
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 1
HAVING AVG(orders.total_amt_usd) > (SELECT AVG(total_amt_usd)
FROM orders
JOIN accounts ON orders.account_id = accounts.id)
ORDER BY 2 DESC) sub2

-- returns 4721.1397439971747168


