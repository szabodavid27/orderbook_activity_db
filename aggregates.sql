-- Your name and cohort here
/*	 name: Szabó Dávid, cohort: C402 Foundations of SRE	*/
/*
Aggregate Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     THEN records returned. 
*/

USE orderbook_activity_db;

-- #1: How many users do we have?
SELECT count(*) AS number_of_users
FROM	`user` u;
/*
7
ROWS=1
 */
-- #2: List the username, userid, and number of orders each user has placed.
SELECT 	u.uname AS username,
		u.userid,
		count(o.orderid) AS number_of_orders
FROM	`user` u
	INNER JOIN `order` o ON u.userid = o.userid
GROUP BY username, u.userid;
/*
admin	1	3
james	3	3
kendra	4	5
alice	5	8
robert	6	5
ROWS=5
 */
-- #3: List the username, symbol, and number of orders placed for each user and for each symbol. 
-- Sort results in alphabetical order by symbol.
SELECT	u.uname AS username,
		o.symbol,
		count(o.orderid) AS number_of_orders
FROM	`user` u
	INNER JOIN `order` o ON u.userid = o.userid
GROUP BY u.userid, u.uname, o.symbol
ORDER BY o.symbol;
/*
alice	A	5
james	A	1
robert	AAA	1
admin	AAPL	1
kendra	AAPL	1
ROWS=19
 */
-- #4: Perform the same query as the one above, but only include admin users.
SELECT	u.uname AS username,
		o.symbol,
		count(o.orderid) AS number_of_orders
FROM	`user` u
	INNER JOIN `order` o ON u.userid = o.userid
	INNER JOIN `userroles` ur ON u.userid = ur.userid
	INNER JOIN `role` r ON ur.roleid = r.roleid
WHERE	r.name = 'admin'
GROUP BY u.userid, u.uname, o.symbol
ORDER BY o.symbol;
/*
alice	A	5
admin	AAPL	1
alice	GOOG	1
admin	GS	1
alice	SPY	1
ROWS=7
 */
-- #5: List the username and the average absolute net order amount for each user with an order.
-- Round the result to the nearest hundredth and use an alias (averageTradePrice).
-- Sort the results by averageTradePrice with the largest value at the top.
SELECT	u.uname AS username,
		round(avg(o.shares * price), 2) AS averageTradePrice
FROM	`order` o
	INNER JOIN `user` u ON o.userid = u.userid
GROUP BY u.userid, u.uname
ORDER BY averageTradePrice DESC;
/*
admin	10774.87
alice	6000.47
james	1187.80
robert	536.92
kendra	-17109.53
ROWS=5
 */
-- #6: How many shares for each symbol does each user have?
-- Display the username and symbol with number of shares.
SELECT	u.uname AS username,
		o.symbol,
		sum(o.shares) AS number_of_shares
FROM	`order` o
	INNER JOIN `user` u ON o.userid = u.userid
GROUP BY u.userid, u.uname, o.symbol;
/*
admin	WLY	100
admin	GS	100
admin	AAPL	-15
alice	A	18
alice	SPY	100
ROWS=19
 */
-- #7: What symbols have at least 3 orders?
SELECT	symbol,
		count(orderid) AS number_of_orders
FROM 	`order`
GROUP BY symbol
HAVING 	count(orderid) >= 3;
/*
A	6
AAPL	3
WLY	3
ROWS=3
 */
-- #8: List all the symbols and absolute net fills that have fills exceeding $100.
-- Do not include the WLY symbol in the results.
-- Sort the results by highest net with the largest value at the top.
SELECT	symbol,
		sum(abs(share * price)) AS absolute_net_fill
FROM `fill`
WHERE 	symbol != 'WLY'
GROUP BY symbol
HAVING	sum(abs(share * price)) > 100
ORDER BY absolute_net_fill DESC;
/*
SPY	54859.50
AAPL	7038.00
GS	6112.60
A	2597.80
TLT	1978.60
ROWS=5
 */
-- #9: List the top five users with the greatest amount of outstanding orders.
-- Display the absolute amount filled, absolute amount ordered, and net outstanding.
-- Sort the results by the net outstanding amount with the largest value at the top.
SELECT	u.userid,
		u.uname AS username,
		sum(f.share * f.price) AS abs_amount_filled,
		sum(o.shares * o.price) AS abs_amount_ordered,
		sum(f.share * f.price) + sum(o.shares * o.price) AS net_outstanding
FROM	`user` u
	LEFT JOIN `fill` f ON u.userid = f.userid
	LEFT JOIN `order` o ON u.userid = o.userid
GROUP BY u.userid, u.uname
ORDER BY net_outstanding DESC
LIMIT	5;
/*
1	admin	-3996.60	96973.80	92977.20
3	james	928.80	7126.80	8055.60
6	robert	-15658.50	8053.80	-7604.70
5	alice	-221914.80	144011.16	-77903.64
4	kendra	159468.25	-256642.95	-97174.70
ROWS=5
 */