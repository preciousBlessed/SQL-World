-- SQL DATA CLEANING
-- Assume a table where we implement the following code...
SELECT first_name,
    last_name,
    phone_number,
    LEFT(phone_number, 3) AS area_code,
    RIGHT(phone_number, 8) AS phone_number_only,
    RIGHT(phone_number, LENGTH(phone_number) - 4) AS phone_number_alt
FROM demo.customers_data


-- FIRST QUIZZES
-- left and right quizzes:

-- 1.
-- In the accounts table, there is a column holding the website for each company.
-- The last three digits specify what type of web address they are using. A list of extensions
-- (and pricing) is provided here. Pull these extensions and provide how many of each website type
-- exist in the accounts table.

SELECT LEFT(website, 3) AS domain, COUNT(*) tally
FROM accounts
GROUP BY 1

-- OR

SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- 2.
-- There is much debate about how much the name (or even the first letter of a company name) matters.
-- Use the accounts table to pull the first letter of each company name to see the distribution of company
-- names that begin with each letter (or number).

SELECT LEFT(name, 1) AS first_symbol
FROM accounts

-- OR
SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- 3.
-- Use the accounts table and a CASE statement to create two groups: one group of company names that start
-- with a number and a second group of those company names that start with a letter. What proportion of
-- company names start with a letter?

WITH t1 AS (SELECT CASE WHEN Left(name, 1) IN
('A','B','C','E','F','G','H','I','J','K','L','M','N','O','P',
'Q','R','S','T','U','V','W','X','Y','Z') THEN 'Group 1' ELSE 'Group 2' END AS Groupings, COUNT(*) frequency
FROM accounts
GROUP BY 1)

SELECT groupings, SUM(frequency)/351 as prop
FROM t1
GROUP BY 1

-- OR
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                          THEN 1 ELSE 0 END AS num, 
            CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                          THEN 0 ELSE 1 END AS letter
         FROM accounts) t1;


-- 4.
-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel,
-- and what percent start with anything else?

WITH t1 AS (SELECT CASE WHEN Left(name, 1) IN
('A','E','I','O','U') THEN 'Group 1' ELSE 'Group 2' END AS Groupings, COUNT(*) frequency
FROM accounts
GROUP BY 1)

SELECT groupings, SUM(frequency)/351 as prop
FROM t1
GROUP BY 1

-- OR
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                           THEN 1 ELSE 0 END AS vowels, 
             CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                          THEN 0 ELSE 1 END AS other
            FROM accounts) t1;

-- OR: NOT IN approach...
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                           THEN 1 ELSE 0 END AS vowels, 
             CASE WHEN LEFT(UPPER(name), 1) NOT IN ('A','E','I','O','U') 
                          THEN 1 ELSE 0 END AS other
            FROM accounts) t1;



-- NEW QUIZZES ON POSITION, STRPOS, LOWER, UPPER
-- 1.
-- Use the accounts table to create first and last name columns that hold the first and last names
-- for the primary_poc.

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) as first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) as last_name
FROM accounts

-- 2.
-- Now see if you can do the same thing for every rep name in the sales_reps table.
-- Again provide first and last name columns.

SELECT LEFT(name, STRPOS(name, ' ') - 1) as first_name,
RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) as last_name
FROM sales_reps



-- NEW QUIZZES ON CONCAT
-- 1.
-- Each company in the accounts table wants to create an email address for each primary_poc. The email
-- address should be the first name of the primary_poc . last name primary_poc @ company name .com.

WITH tab1 AS (SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) as first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) as last_name, name
FROM accounts)

SELECT LOWER(first_name || '.' || last_name || '@' || name || '.com') AS poc_email
FROM tab1

-- 2.
-- You may have noticed that in the previous solution some of the company names include spaces,
-- which will certainly not work in an email address. See if you can create an email address that
-- will work by removing all of the spaces in the account name, but otherwise your solution should be
-- just as in question 1. Some helpful documentation is here.

WITH tab1 AS (SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) as first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) as last_name, name
FROM accounts)

SELECT LOWER(first_name || '.' || last_name || '@' ||
             replace(name, ' ', '') || '.com') AS poc_email
FROM tab1

-- 3.

-- We would also like to create an initial password, which they will change after their first log in.
-- The first password will be the first letter of the primary_poc's first name (lowercase), then the last
-- letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter
-- of their last name (lowercase), the number of letters in their first name, the number of letters in
-- their last name, and then the name of the company they are working with, all capitalized with no spaces.

-- This is the hardest and brainiest I've ever done!!!

WITH tab1 AS (SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) as first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) as last_name, name AS nom
FROM accounts),
      tab2 AS (SELECT LOWER(LEFT(first_name, 1)) ||
                      LOWER(RIGHT(first_name, 1)) ||
                      LOWER(LEFT(last_name, 1)) ||
                      LOWER(RIGHT(last_name, 1)) ||
                      LENGTH(first_name) || LENGTH(last_name) ||
                      UPPER(replace(nom, ' ', '')) AS initial_Password, nom as nam
FROM tab1)

SELECT LOWER(first_name || '.' || last_name || '@' || 
             replace(nom, ' ', '') || '.com') AS poc_email, initial_Password
FROM tab1
JOIN tab2 ON tab2.nam = tab1.nom

-- OR

WITH t1 AS (
    SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;


-- new QUIZ ON CAST

-- 1.
-- For this set of quiz questions, you are going to be working with a single table in the environment
-- below. This is a different dataset than Parch & Posey, as all of the data in that particular dataset
-- were already clean.

-- Task List
-- Tasks to complete:

SELECT *, CAST(SUBSTR(date, 1, STRPOS(date, ' ') - 1) AS DATE) dateNew
FROM sf_crime_data
LIMIT 10






-- NEW QUIZ ON WINDOWS FUNCTION

-- 1.
-- Using Derek's previous video as an example, create another running total. This time, create a running
-- total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table
-- should have two columns: one with the amount being added for each new row, and a second with the running
--  total.

SELECT
standard_amt_usd,
SUM(standard_amt_usd) OVER(ORDER BY occurred_at) AS running_total
FROM orders


-- 2.
-- Now, modify your query from the previous quiz to include partitions. Still create a running total of
-- standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by
-- year and partition by that same year-truncated occurred_at variable. Your final table should have
-- three columns: One with the amount being added for each row, one for the truncated date, and a final
-- column with the running total within each year.

SELECT standard_amt_usd,
DATE_TRUNC('year', occurred_at) AS year,
SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders


-- NEW QUIZ
-- RANK() AND ROW_NUMBER()

-- 1.
-- Select the id, account_id, and total variable from the orders table, then create a column called
-- total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account
-- using a partition. Your final table should have these four columns.

SELECT id, account_id, total,
RANK() OVER(PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders

-- lesson
SELECT id, account_id, standard_qty,
	DATE_TRUNC('month', occurred_at) AS month,
	DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS dense_rank,
	SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS sum_stan_qty,
	COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS count_stan_qty,
	AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS avg_stan_qty,
	MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS min_stan_qty,
	MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS max_stan_qty

FROM orders

-- Same function above with Aliases

SELECT id, account_id, standard_qty,
	DATE_TRUNC('month', occurred_at) AS month,
	DENSE_RANK() OVER main_window AS dense_rank,
	SUM(standard_qty) OVER main_window AS sum_stan_qty,
	COUNT(standard_qty) OVER main_window AS count_stan_qty,
	AVG(standard_qty) OVER main_window AS avg_stan_qty,
	MIN(standard_qty) OVER main_window AS min_stan_qty,
	MAX(standard_qty) OVER main_window AS max_stan_qty

FROM orders
WINDOW mian_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at))

-- NEW-QUIZ
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER main_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER main_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER main_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER main_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER main_window AS max_total_amt_usd
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))



-- NEW QUIZ ON LEAD AND LAG

-- 1.
-- In the previous video, Derek outlines how to compare a row to a previous or subsequent row.
-- This technique can be useful when analyzing time-based events. Imagine you're an analyst at
-- Parch & Posey and you want to determine how the current order's total revenue ("total" meaning
-- from sales of all types of paper) compares to the next order's total revenue.

-- Modify Derek's query from the previous video in the SQL Explorer below to perform this analysis.
-- You'll need to use occurred_at and total_amt_usd in the orders table along with LEAD to do so.
-- In your query results, there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.

SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at, SUM(total_amt_usd)
  FROM orders
  GROUP BY 1
 ) sub

-- I added SUM(total_amt_usd) was it really necessary?


-- NEW QUIZ ON PERCENTILES

-- 1.
-- Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of
-- standard_qty for their orders. Your resulting table should have the account_id, the occurred_at time
-- for each order, the total amount of standard_qty paper purchased, and one of four levels in a
-- standard_quartile column.

SELECT account_id,
	occurred_at,
    standard_qty,
    NTILE(4) OVER (ORDER BY standard_qty) AS standard_quartile
FROM orders
ORDER BY standard_qty DESC

-- Correction
SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders 
 ORDER BY account_id DESC

-- 2.
-- Use the NTILE functionality to divide the accounts into two levels in terms of the amount of
-- gloss_qty for their orders. Your resulting table should have the account_id, the occurred_at time
-- for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half
-- column.

SELECT account_id,
	occurred_at,
    gloss_qty,
    NTILE(2) OVER (ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY gloss_qty DESC

-- Correction
SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
  FROM orders 
 ORDER BY account_id DESC


-- 3.
-- Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the
-- amount of total_amt_usd for their orders. Your resulting table should have the account_id, the
-- occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of
-- 100 levels in a total_percentile column.

SELECT account_id,
	occurred_at,
    total_amt_usd,
    NTILE(100) OVER (ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY total_amt_usd DESC

-- CORRECTION
SELECT account_id,
	occurred_at,
    total_amt_usd,
    NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY account_id DESC



-- NEW QUIZ ON ADVANCED JOINS
-- 1.

SELECT *
FROM accounts
FULL OUTER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
WHERE sales_reps.id IS NULL OR accounts.sales_rep_id IS NULL