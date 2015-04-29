SELECT *
  FROM Person.BusinessEntity be
  WHERE NOT EXISTS(
     SELECT 1
      FROM Person.BusinessEntityAddress bea
      WHERE bea.BusinessEntityID = be.BusinessEntityID);