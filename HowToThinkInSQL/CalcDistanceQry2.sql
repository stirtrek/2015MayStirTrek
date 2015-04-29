SET STATISTICS IO,TIME ON
DECLARE @zipcode char(5) = '44224'


SELECT s.[Name],Sales.fnCalcDistanceMiles(@zipcode,left(a.PostalCode,5)) as distance INTO #distance
  FROM [Sales].[Store] s inner join Person.BusinessEntityAddress bea ON s.BusinessEntityID = bea.BusinessEntityID inner join Person.Address a ON bea.AddressID = a.AddressID
  inner join Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID inner join Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
  where sp.CountryRegionCode = 'US'
SELECT TOP 10 Name FROM #distance ORDER BY distance
DROP TABLE #distance