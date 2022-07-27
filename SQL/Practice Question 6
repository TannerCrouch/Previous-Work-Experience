CREATE TABLE ShipmentTable(
   Shipment_ID INTEGER  NOT NULL PRIMARY KEY
  ,Ship_Date   DATE  NOT NULL
  ,Origin      VARCHAR(3) NOT NULL
  ,Destination VARCHAR(10) NOT NULL
              
);
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10001,'2/3/2015','RDC','Store 1');
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10002,'2/5/2015','RDC','Store 2');
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10004,'2/6/2015','RDC','Store 1');
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10007,'2/6/2015','RDC','Store 2');
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10008,'2/6/2015','RDC','Store 3');
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10009,'2/7/2015','RDC','Store 3');
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10011,'2/8/2015','RDC','Store 2');
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10013,'2/9/2015','RDC','Store 1');
INSERT INTO ShipmentTable(Shipment_ID,Ship_Date,Origin,Destination) VALUES (10014,'2/11/2015','RDC','Store 2');

CREATE TABLE RecepitTable(
   Receipt_Date DATE  NOT NULL 
  ,Origin       VARCHAR(3) NOT NULL
  ,Destination  DATE  NOT NULL
);
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/3/2015','RDC','Store 1');
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/6/2015','RDC','Store 2');
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/8/2015','RDC','Store 1');
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/7/2015','RDC','Store 2');
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/8/2015','RDC','Store 3');
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/8/2015','RDC','Store 3');
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/10/2015','RDC','Store 2');
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/10/2015','RDC','Store 1');
INSERT INTO RecepitTable(Receipt_Date,Origin,Destination) VALUES ('2/12/2015','RDC','Store 2');

WITH Store_1 AS(
SELECT *, (
  SELECT receipt_date
  FROM RecepitTable
  WHERE ShipmentTable.Ship_Date <= RecepitTable.receipt_date AND destination = 'Store 1'
  ORDer BY receipt_date) AS receipt_date
  FROM ShipmentTable
  WHERE destination = 'Store 1'),
  
Store_2 AS(
SELECT *, (
  SELECT receipt_date
  FROM RecepitTable
  WHERE ShipmentTable.Ship_Date <= RecepitTable.receipt_date AND destination = 'Store 2'
  ORDer BY receipt_date) AS receipt_date
  FROM ShipmentTable
  WHERE destination = 'Store 2'),
  

  
Store_3 AS(
SELECT *, (
  SELECT receipt_date
  FROM RecepitTable
  WHERE ShipmentTable.Ship_Date <= RecepitTable.receipt_date AND destination = 'Store 3'
  ORDer BY receipt_date) AS receipt_date
  FROM ShipmentTable
  WHERE destination = 'Store 3')
  
 SELECT * FROM Store_1
 UNION ALL
 SELECT * FROM Store_2
 UNION ALL
 SELECT * FROM Store_3
 ORDER BY shipment_id
