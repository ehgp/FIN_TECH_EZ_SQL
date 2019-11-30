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