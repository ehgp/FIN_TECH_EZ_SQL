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