-- Your name and cohort here
/* name: Szabó Dávid, cohort: C402 Foundations of SRE

Basic Selects

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: List all users, including username and dateJoined.
SELECT 	uname, dateJoined
FROM	`user`;
/*
admin	2023-02-14 13:13:28
wiley	2023-04-01 13:13:28
james	2023-03-15 19:15:48
kendra	2023-03-15 19:16:06
alice	2023-03-15 19:16:21
ROWS=7
 */
-- #2: List the username and datejoined from users with the newest users at the top.
SELECT	uname, dateJoined
FROM	`user`
ORDER BY dateJoined DESC;
/*
wiley	2023-04-01 13:13:28
sam	2023-03-15 19:16:59
robert	2023-03-15 19:16:43
alice	2023-03-15 19:16:21
kendra	2023-03-15 19:16:06
ROWS=7
 */
-- #3: List all usernames and dateJoined for users who joined in March 2023.
SELECT 	uname, dateJoined
FROM	`user`
WHERE	dateJoined BETWEEN '2023-03-01' AND '2023-03-31';
/*
james	2023-03-15 19:15:48
kendra	2023-03-15 19:16:06
alice	2023-03-15 19:16:21
robert	2023-03-15 19:16:43
sam	2023-03-15 19:16:59
ROWS=5
 */
-- #4: List the different role names a user can have.
SELECT	DISTINCT name
FROM	`role`;
/*
admin
it
user
ROWS=3
 */
-- #5: List all the orders.
SELECT	*
FROM	`order`;
/*
1	1	WLY	1	2023-03-15 19:20:35	100	38.73	partial_fill
2	6	WLY	2	2023-03-15 19:20:50	-10	38.73	filled
3	6	NFLX	2	2023-03-15 19:21:12	-100	243.15	pending
4	5	A	1	2023-03-15 19:21:31	10	129.89	filled
5	3	A	2	2023-03-15 19:21:39	-10	129.89	filled
ROWS=24
 */
-- #6: List all orders in March where the absolute net order amount is greater than 1000.
SELECT	*, shares * price AS absolute_net_order_amount
FROM	`order`
WHERE	orderTime BETWEEN '2023-03-01' AND '2023-03-31' AND
		shares * price > 1000;
/*
1	1	WLY	1	2023-03-15 19:20:35	100	38.73	partial_fill	3873.00
4	5	A	1	2023-03-15 19:21:31	10	129.89	filled	1298.90
6	1	GS	1	2023-03-15 19:22:11	100	305.63	canceled_partial_fill	30563.00
8	6	AAPL	1	2023-03-15 19:23:22	25	140.76	filled	3519.00
11	5	SPY	1	2023-03-15 19:24:21	100	365.73	partial_fill	36573.00
ROWS=8
 */
-- #7: List all the unique status types from orders.
SELECT DISTINCT status
FROM `order`;
/*
partial_fill
filled
pending
canceled_partial_fill
canceled
ROWS=5
 */
-- #8: List all pending and partial fill orders with oldest orders first.
SELECT 	*
FROM	`order`
WHERE	status IN ('pending', 'partial_fill')
ORDER BY orderTime ASC;
/*
1	1	WLY	1	2023-03-15 19:20:35	100	38.73	partial_fill
3	6	NFLX	2	2023-03-15 19:21:12	-100	243.15	pending
11	5	SPY	1	2023-03-15 19:24:21	100	365.73	partial_fill
12	4	QQQ	2	2023-03-15 19:24:32	-100	268.27	pending
13	4	QQQ	2	2023-03-15 19:24:32	-100	268.27	pending
ROWS=10
 */
-- #9: List the 10 most expensive financial products where the productType is stock.
-- Sort the results with the most expensive product at the top
SELECT 	name, price, productType
FROM	product
WHERE	productType = 'stock'
ORDER BY price DESC
LIMIT	10;
/*
Samsung Biologics Co.,Ltd.	830000.00	stock
Taekwang Industrial Co., Ltd.	715000.00	stock
Young Poong Corporation	630000.00	stock
Korea Zinc Company, Ltd.	616000.00	stock
Samsung SDI Co., Ltd.	605000.00	stock
ROWS=10
 */
-- #10: Display orderid, fillid, userid, symbol, and absolute net fill amount
-- from fills where the absolute net fill is greater than $1000.
-- Sort the results with the largest absolute net fill at the top.
SELECT 	orderid, fillid, userid, symbol, share * price AS absolute_net_fill_amount
FROM	`fill`
WHERE	share * price > 1000
ORDER BY absolute_net_fill_amount DESC;
/*
14	12	4	SPY	27429.75
7	6	4	GS	3056.30
10	10	1	AAPL	2111.40
9	8	4	AAPL	1407.60
5	4	3	A	1298.90
ROWS=5
 */