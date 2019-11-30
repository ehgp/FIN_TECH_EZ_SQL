# FIN_TECH_EZ_SQL
SQL queries designed for Fin-Tech Business applications


CREATE DATABASE testDB;
GO

USE testDB;
GO

CREATE TABLE TRADES(
DATES date,
FIRM varchar(4),
SYMBOL varchar(4),
SIDE varchar(1),
QUANTITY int,
PRICE int
)

INSERT INTO TRADES
VALUES('2/3/2014' , '1ABC','A123','B',200,41),
('2/4/2014' , '2BCD','B234','B',600,60),
('2/7/2014' , '1ABC','C345','S',600,70),
('2/10/2014' , '3CDE','C345','S',600,70),
('2/12/2014' , '4DEF','B234','B',200,62),
('2/14/2014' , '3CDE','B234','B',300,61),
('2/21/2014' , '1ABC','A123','B',300,40),
('2/24/2014' , '1ABC','A123','S',300,30),
('2/25/2014' , '4DEF','C345','B',2100,71),
('2/27/2014' , 'CDE','B234','S',1100,63);

SELECT * FROM TRADES

/* 1. SYMBOL A123 HAS DECREASED IN PRICE FROM 41 TO 30
SYMBOL B234 HAS INCREASED FROM 60 TO 63
SYMBOL C345 HAS INCREASED FROM 70 TO 71
FIRM 1ABC SOLD BACK STOCKS AT A LOSS OF $3K PURCHASED 3 DAYS AGO */

/*2Ai.*/
SELECT DISTINCT SYMBOL FROM TRADES

/*2Bi.*/
SELECT DISTINCT FIRM, SYMBOL FROM TRADES

/*2Ca.*/

select FIRM, SYMBOL, count(*) as Counted

from TRADES

group by FIRM, SYMBOL

/*3. For each firm,
their symbol they traded,
total dollar volume that they traded in that symbol*/



/* A. BR# BUSINESS REQUIREMENT   FUNCTIONAL SPECIFICATION
1      FOR EACH FIRM AND THE SYMBOL THEY TRADED       SELECT THE FIRM AND THE GROUP. GROUP BY FIRM AND SYMBOL
2      TOTAL DOLLAR VOLUME THAT THEY TRADED IN THAT SYMBOL    SUM THE QUANTITY TIMES THE PRICE OF EACH OF THOSE INDIVIDUAL FIRMS AND THE SYMBOLS THEY TRADED AND DISPLAY IN THE SELECT STATEMENT AS TOTAL_DOLLAR_VOLUME*/

/* B.  Assumption is that dollar values for sale and buy are both positive so as to quantify all of the dollars spent in the trade*/
Select FIRM, SYMBOL, SUM(QUANTITY*PRICE) AS TOTAL_DOLLAR_VOLUME
FROM TRADES
GROUP BY FIRM, SYMBOL


DROP DATABASE testDB ;  
GO  


/*You have a table named “TRADES” with the following six columns:
Column Name Data Type Description
Date DATE The calendar date on which the trade took place.
Firm VARCHAR(255

)

A symbol representing the Broker/Dealer who conducted the trade.

Symbol VARCHAR(10) The security traded.
Side VARCHAR(1) Denotes whether the trade was a buy (purchase) or a sell (sale) of a security.
Quantity BIGINT The number of shares involved in the trade.
Price DECIMAL(18,8

)

The dollar price per share traded.

You write a query looking for all trades in the month of August 2019. The query returns the following:
Questions:
1) Conduct an analysis of the data set returned by your query. Write a paragraph describing your
analysis. Please also note any questions or assumptions made about this data.
2) Your business user asks you to show them a table output that includes an additional column
categorizing the TRADES data into volume based Tiers, with a column named ‘Tier’. Quantities
between 0-250 will be considered ‘Small’, quantities greater than ‘Small’ but less than or equal
to 500 will be considered ‘Medium’, quantities greater than ‘Medium’ but less than or equal to
500 will be considered ‘Large’, and quantities greater than ‘Tier 3’ will be considered ‘Very
Large’ .
a. Please write the SQL query you would use to add the column to the table output.
b. Please show the exact results you expect based on your SQL query.
3) Your business user asks you to show them a table output summarizing the TRADES data (Buy
and Sell) on week-by-week basis.
a. Please write the SQL query you would use to query this table.
b. Please show the exact results you expect based on your SQL query.*/

CREATE DATABASE testDB;
GO

USE testDB;
GO

CREATE TABLE TRADES1 (
  DATE DATE,
  FIRM varchar(25),
  SYMBOL varchar(10),
  SIDE varchar(1),
  QUANTITY BIGINT,
  PRICE DECIMAL(18,8)
);

INSERT INTO TRADES1
VALUES('8/5/2019','ABC',123,'B',200,41),
('8/5/2019','CDE',456,'B',601,60),
('8/5/2019','ABC',789,'S',600,70),
('8/5/2019','CDE',789,'S',600,70),
('8/5/2019','FGH',456,'B',200,62),
('8/6/2019','3CDE',456,'X',300,61),
('8/8/2019','ABC',123,'B',300,40),
('8/9/2019','ABC',123,'S',300,30),
('8/9/2019','FGH',789,'B',2100,71),
('8/10/2019','CDE',456,'S',1100,63);

SELECT * FROM TRADES1

/* the market has seen some growth in two symbols 456 and 789, while symbol 123 had dropped in price. Symbol 123 has decreased in price from 41 to 30. Symbol 456 has increased from 60 to 63. 
Symbol 789 has increased from 70 to 71. Firm ABC sold back stocks on 08/09/2019 at a loss of $3K, which was purchased the previous day.*/


SELECT *,  CASE 
          WHEN TRADES1.QUANTITY >=0 AND TRADES1.QUANTITY <= 250 THEN 'SMALL'
          WHEN TRADES1.QUANTITY >250 AND TRADES1.QUANTITY <= 500 THEN 'MEDIUM'
          WHEN TRADES1.QUANTITY >500 AND TRADES1.QUANTITY <= 750 THEN 'LARGE'
		  WHEN TRADES1.QUANTITY >750 THEN 'VERY LARGE'
       END AS Tier
FROM TRADES1

SELECT DATEADD(DAY, -DATEDIFF(DAY, 0, TRADES1.DATE) % 7, TRADES1.DATE) AS [Week of],
  SUM(LEN(SIDE) - LEN(REPLACE(SIDE, 'B', '')))  AS CountBuy, SUM(LEN(SIDE) - LEN(REPLACE(SIDE, 'S', ''))) AS CountSell
FROM TRADES1
GROUP BY DATEADD(DAY, -DATEDIFF(DAY, 0, TRADES1.DATE) % 7, TRADES1.DATE)

/*Below is a snapshot of data from two tables: “Orders” and “Customers”, taken on 02/05/2016. You find
the following documentation:
The ORDERS table gets updated at the end of every day
The CUSTOMERS table gets updated at the end of every week
Question:
1) Your business user asks you to combine the details from these two tables in one table output,
without any duplicated columns.
A. Please write the query you would use to query this (note which language you are using).
B. Please show the exact results you expect based on your SQL query.
C. If you make assumptions to complete the task, please document them.
2) Through an investigation, your business user has learnt that there has been an order that was
processed successfully by mistake.
A. Please write the query you would use to validate (or disprove) this finding (note which
language you are using).
B. Please show the exact results you expect based on your SQL query.
C. If you make assumptions to complete the task, please document them.*/

CREATE DATABASE testDB;
GO

USE testDB;
GO
CREATE TABLE CUSTOMERS(
CUSTOMER_ID INT NOT NULL PRIMARY KEY,
STATUS VARCHAR(8),
FNAME VARCHAR(10),
MNAME VARCHAR(10),
LNAME VARCHAR(10),
GENDER VARCHAR(1),
AGE INT);

CREATE TABLE ORDERS(
ORDER_DT DATE,
ORDER_ID INT NOT NULL PRIMARY KEY,
ORDER_STATUS VARCHAR(10),
ORDER_STATUS_CD VARCHAR(1),
CUSTOMER_ID INT NOT NULL FOREIGN KEY REFERENCES DBO.CUSTOMERS(CUSTOMER_ID));

INSERT INTO ORDERS
VALUES('2/1/2016',1000002,'Completed','S',4),
('2/2/2016',2000008,'Processing','P',6),
('2/2/2016',2000009,'Completed','S',7),
('2/2/2016',2000010,'Completed','S',7),
('2/3/2016',3000008,'Processing','P',6),
('2/3/2016',3000009,'Cancelled','C',6),
('2/3/2016',3000010,'Cancelled','C',4),
('2/3/2016',3000011,'On Hold','H',3),
('2/3/2016',3000012,'Processing','P',7),
('2/4/2016',4000005,'Completed','S',6);

INSERT INTO CUSTOMERS
VALUES(1,'Active','John',NULL,'Smith','M',70),
(2,'Active','James','Emitt','Madison','M',68),
(3,'Active','Joe','Anthony','Diggs','M',55),
(4,'Inactive','Adam',NULL,'Lambert','M',40),
(5,'Active','Marcus',NULL,'Dallas','M',81),
(6,'Active','Steve','Eugene','Bullock','M',62),
(7,'Active','Naomi',NULL,'Patel','F',33),
(8,'Active','Alexander',NULL,'Pope','M',29),
(9,'Inactive','Peter',NULL,'Chandler','M',36);

SELECT c.CUSTOMER_ID, c.STATUS, c.FNAME, c.MNAME, c.LNAME, c.GENDER, c.AGE, o.ORDER_DT, o.ORDER_ID,o.ORDER_STATUS, o.ORDER_STATUS_CD
FROM CUSTOMERS as c
LEFT OUTER JOIN ORDERS as o
ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE o.ORDER_ID IS NOT NULL;

/* Assumed a one to many relationship between CUSTOMERS and ORDERS tables.
CUSTOMER_ID would be a primary key in the CUSTOMERS table, and a foreign key
in the ORDERS table. */


SELECT c.CUSTOMER_ID, c.STATUS, o.ORDER_ID, o.ORDER_STATUS,
CASE
WHEN c.STATUS = 'Inactive' AND (o.ORDER_STATUS = 'Completed' OR o.ORDER_STATUS = 'Processing') THEN 'YES'
WHEN c.STATUS = 'Inactive' AND (o.ORDER_STATUS = 'Cancelled' OR o.ORDER_STATUS = 'On Hold') THEN 'NO'
WHEN c.STATUS = 'Active' AND (o.ORDER_STATUS = 'Completed' OR o.ORDER_STATUS = 'Processing') THEN 'NO'
WHEN c.STATUS = 'Active' AND (o.ORDER_STATUS = 'Cancelled' OR o.ORDER_STATUS = 'On Hold') THEN 'NO'
END AS Mistake
FROM CUSTOMERS as c
LEFT OUTER JOIN ORDERS as o
ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE o.ORDER_ID IS NOT NULL;

/* validating that there was a mistake made using the following cases:
1. customer status is inactive and the order status is either completed or processing is a mistake
2. customer status is inactive and the order status is either cancelled or on hold is not a mistake
3. customer status is active and the order status is either completed or processing is not a mistake
4. customer status is active and the order status is either cancelled or on hold is not a mistake */


