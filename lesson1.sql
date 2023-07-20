-- lEARNING TO USE THE LIMIT CLAUSE to limit the number of rows that will be displayed durung a query.
SELECT occured_at, account_id, channel
FROM web_events
LIMIT 15;