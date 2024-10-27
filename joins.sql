-- Your name and cohort here
/*	 name: Szabó Dávid, cohort: C402 Foundations of SRE	*/
/*
Join Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: Display the dateJoined and username for admin users.
SELECT	u.dateJoined, u.uname
FROM	`role` r
	INNER JOIN `userroles` ur ON r.roleid = ur.roleid
	INNER JOIN `user` u ON ur.userid = u.userid
WHERE 	r.name = 'admin';
/*
2023-02-14 13:13:28	admin
2023-04-01 13:13:28	wiley
2023-03-15 19:16:21	alice
ROWS=3
 */
-- #2: Display each absolute order net (share*price), status, symbol, trade date, and username.
-- Sort the results with largest the absolute order net (share*price) at the top.
-- Include only orders that were not canceled or partially canceled.
SELECT	o.shares * o.price AS absolute_order_net,
		o.status,
		o.symbol,
		CAST(o.orderTime AS date) AS trade_date,
		u.uname AS username
FROM	`order` o
	INNER JOIN `user` u ON o.userid = u.userid
WHERE 	o.status NOT IN ('canceled', 'canceled_partial_fill') 
ORDER BY absolute_order_net DESC;
/*
36573.00	partial_fill	SPY	2023-03-15	alice
3873.00	partial_fill	WLY	2023-03-15	admin
3873.00	pending	WLY	2023-03-15	james
3519.00	filled	AAPL	2023-03-15	robert
1298.90	filled	A	2023-03-15	alice
ROWS=20
 */
-- #3: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Note that filledShares are the opposite sign (+-) because they subtract from ordershares!
SELECT	o.orderid,
		o.symbol,
		o.status,
		o.shares AS order_shares,
		f.share AS filled_share,
		o.price AS price_for_order
FROM	`order` o
	INNER JOIN `fill` f ON o.orderid = f.orderid;
/*
1	WLY	partial_fill	100	-10	38.73
2	WLY	filled	-10	10	38.73
4	A	filled	10	-10	129.89
5	A	filled	-10	10	129.89
6	GS	canceled_partial_fill	100	-10	305.63
ROWS=14
 */
-- #4: Display all partial_fill orders and how many outstanding shares are left.
-- Also include the username, symbol, and orderid.
SELECT	u.uname,
		o.symbol,
		o.orderid,
		o.shares + f.share AS outstanding_shares
FROM	`order` o
	INNER JOIN `fill` f ON o.orderid = f.orderid
	INNER JOIN `user` u ON o.userid = u.userid
WHERE	o.status = 'partial_fill';
/*
admin	WLY	1	90
alice	SPY	11	25
ROWS=2
 */
-- #5: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Also include the username, role, absolute net amount of shares filled, and absolute net order.
-- Sort by the absolute net order with the largest value at the top.
SELECT	o.orderid,
		o.symbol,
		o.status,
		o.shares,
		f.share,
		o.price,
		u.uname,
		r.name,
		f.share * f.price AS absolute_net_amount_filled,
		o.shares * o.price AS absolute_net_order
FROM	`order` o
	INNER JOIN `fill` f ON o.orderid = f.orderid
	INNER JOIN `user` u ON o.userid = u.userid
	INNER JOIN `userroles` ur ON u.userid = ur.userid
	INNER JOIN `role` r ON ur.roleid = r.roleid;
/*
1	WLY	partial_fill	100	-10	38.73	admin	admin	-387.30	3873.00
2	WLY	filled	-10	10	38.73	robert	user	387.30	-387.30
4	A	filled	10	-10	129.89	alice	admin	-1298.90	1298.90
5	A	filled	-10	10	129.89	james	user	1298.90	-1298.90
6	GS	canceled_partial_fill	100	-10	305.63	admin	admin	-3056.30	30563.00
ROWS=14
 */
-- #6: Display the username and user role for users who have not placed an order.
SELECT 	u.uname AS username, r.name AS user_role
FROM	`user` u
	LEFT JOIN `order` o ON u.userid = o.userid
	INNER JOIN `userroles` ur ON u.userid = ur.userid
	INNER JOIN `role` r ON ur.roleid = r.roleid
WHERE	o.orderid IS NULL;
/*
sam	user
wiley	admin
ROWS=2
 */
-- #7: Display orderid, username, role, symbol, price, and number of shares for orders with no fills.
SELECT 	o.orderid,
		u.uname AS username,
		r.name AS role,
		o.symbol,
		o.price,
		abs(o.shares) AS number_of_shares
FROM	`order` o
	LEFT JOIN `fill` f ON o.orderid = f.orderid
	INNER JOIN `user` u ON o.userid = u.userid
	INNER JOIN `userroles` ur ON u.userid = ur.userid
	INNER JOIN `role` r ON ur.roleid = r.roleid
WHERE	f.orderid IS NULL;
/*
19	alice	admin	GOOG	100.82	100
21	alice	admin	A	129.89	1
22	alice	admin	A	129.89	2
23	alice	admin	A	129.89	5
24	alice	admin	A	129.89	2
ROWS=11
 */
-- #8: Display the symbol, username, role, and number of filled shares where the order symbol is WLY.
-- Include all orders, even if the order has no fills.
SELECT	f.symbol,
		u.uname AS username,
		r.name AS 'role',
		abs(f.share) AS number_of_filled_shares
FROM	`fill` f
	LEFT JOIN `user` u ON f.userid = u.userid
	LEFT JOIN `userroles` ur ON u.userid = ur.userid
	LEFT JOIN `role` r ON ur.roleid = r.roleid
WHERE	f.symbol = 'WLY';
/*
WLY	admin	admin	10
WLY	robert	user	10
ROWS=2
 */