SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty,
accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;


SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id
-- this is to join three tables...web_events, accounts, orders

SELECT web_events.channel, accounts.name, orders.total
-- This is to select only some choice lines from the tables we've joined






