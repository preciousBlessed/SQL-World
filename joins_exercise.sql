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

