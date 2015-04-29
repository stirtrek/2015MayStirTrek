SET STATISTICS IO,TIME ON
DECLARE @zipcode char(5) = '44224'
DECLARE @source geography
SELECT @source = GeoLocation FROM Sales.ZipCodes WHERE zipcode = @zipcode

SELECT s.[Name],@source.STDistance(SpatialLocation) as distance INTO #distance
  FROM [Sales].[Store] s inner join Person.BusinessEntityAddress bea ON s.BusinessEntityID = bea.BusinessEntityID inner join Person.Address a ON bea.AddressID = a.AddressID
  inner join Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID inner join Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
  where sp.CountryRegionCode = 'US'
SELECT TOP 10 Name FROM #distance ORDER BY distance
drop table #distance