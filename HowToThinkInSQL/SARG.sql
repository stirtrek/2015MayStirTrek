USE AdventureWorks2014;
GO
SET NOCOUNT ON;
SET STATISTICS IO,TIME ON;
SELECT SalesOrderID
  FROM Sales.SalesOrderHeader
  WHERE CAST( CONVERT( char( 8 ) , ISNULL( shipdate , orderdate ) , 112 )AS datetime )BETWEEN '2011-06-24' AND '2011-06-25'
  ORDER BY SalesOrderID;


SELECT SalesOrderID
  FROM Sales.SalesOrderHeader
  WHERE ShipDate BETWEEN '2011-06-24' AND '2011-06-25'
     OR ShipDate IS NULL
    AND OrderDate BETWEEN '2011-06-24' AND '2011-06-25'
  ORDER BY SalesOrderID;
SET STATISTICS IO,TIME OFF;

GO
