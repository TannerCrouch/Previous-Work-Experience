CREATE TABLE ProductTable(
   ChildProduct  VARCHAR(10) NOT NULL PRIMARY KEY
  ,ParentProduct VARCHAR(10) NOT NULL
);
INSERT INTO ProductTable(ChildProduct,ParentProduct) VALUES ('Product B','Product A');
INSERT INTO ProductTable(ChildProduct,ParentProduct) VALUES ('Product C','Product A');
INSERT INTO ProductTable(ChildProduct,ParentProduct) VALUES ('Product D','Product A');
INSERT INTO ProductTable(ChildProduct,ParentProduct) VALUES ('Product B1','Product B');
INSERT INTO ProductTable(ChildProduct,ParentProduct) VALUES ('Product B2','Product B');
INSERT INTO ProductTable(ChildProduct,ParentProduct) VALUES ('Product D1','Product D');
INSERT INTO ProductTable(ChildProduct,ParentProduct) VALUES ('Product E1','Product D1');
INSERT INTO ProductTable(ChildProduct,ParentProduct) VALUES ('Product E2','Product D1');

WITH PA AS(
  SELECT childproduct, parentproduct
  FROM ProductTable),
 PB AS(
   SELECT childproduct, parentproduct
  FROM ProductTable
  WHERE parentproduct= 'Product B'),
  PD AS(
    SELECT childproduct, parentproduct
  FROM ProductTable
  WHERE parentproduct= 'Product D'),
  PD1 AS(
    SELECT childproduct, parentproduct
  FROM ProductTable
  WHERE parentproduct= 'Product D1'),
 
PAB AS(
SELECT PB.childproduct, PA.parentproduct
FROM PA 
JOIN PB
ON PA.childproduct = PB.parentproduct
UNION ALL
SELECT * FROM PA
ORDER BY parentproduct, childproduct),

PAD AS(
  SELECT PD.childproduct, PA.parentproduct
  FROM PA 
  JOIN PD
  ON PA.childproduct = PD.parentproduct
  UNION ALL
  SELECT * FROM PAB
  ORDER BY parentproduct, childproduct),
  
PDDD AS(
  SELECT PD1.childproduct, PD.parentproduct
  FROM PD
  JOIN PD1
  ON PD.childproduct = PD1.parentproduct),
  
FinalTable AS(
  SELECT PDDD.childproduct, PAD.parentproduct
  FROM PAD
  JOIN PDDD
  ON PAD.childproduct = PDDD.parentproduct
  UNION ALL
  SELECT * FROM PAD
  UNION ALL
  SELECT * FROM PDDD
  ORDER BY parentproduct, childproduct)
  
  SELECT * FROM FinalTable
  
