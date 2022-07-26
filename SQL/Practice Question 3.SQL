CREATE TABLE mytable(
   LOCATION_ID INTEGER  NOT NULL PRIMARY KEY 
  ,LATITUDE    NUMERIC(7,4) NOT NULL
  ,LONGITUDE   NUMERIC(8,4) NOT NULL
);
INSERT INTO mytable(LOCATION_ID,LATITUDE,LONGITUDE) VALUES (1,40.9283,-98.3821);
INSERT INTO mytable(LOCATION_ID,LATITUDE,LONGITUDE) VALUES (2,38.953,-94.5342);
INSERT INTO mytable(LOCATION_ID,LATITUDE,LONGITUDE) VALUES (3,33.925,-116.956);

CREATE TABLE REFTABLE(Start_ID INTERGER NOT NULL,
                      Dest_ID);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (1,1);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (1,2);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (1,3);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (2,1);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (2,2);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (2,3);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (3,1);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (3,2);
INSERT INTO REFTABLE(Start_ID, Dest_ID) VALUES (3,3);

WITH StartTable AS(
SELECT location_id AS Start_ID, latitude/57.29577951 AS StLatRad, longitude/57.29577951 AS StLongRad
FROM mytable),
DestTable AS( SELECT location_id AS Dest_ID, latitude/57.29577951 AS DestLatRad, longitude/57.29577951 AS DestLongRad
FROM mytable)
  

SELECT REFTABLE.Start_ID, REFTABLE.Dest_ID, 3963 * acos((sin(StartTable.StLatRad)*sin(DestTable.DestLatRad))+cos(StartTable.StLatRad)* 
cos(DestTable.DestLatRad)* cos(DestTable.DestLongRad-StartTable.StLongRad)) AS Distance
FROM REFTABLE
JOIN StartTable
ON REFTABLE.Start_ID = StartTable.Start_ID
JOIN DestTable
ON REFTABLE.Dest_ID = DestTable.Dest_ID
  
