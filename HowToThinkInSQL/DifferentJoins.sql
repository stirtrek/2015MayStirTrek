SELECT a.AddressLine1,z.City FROM Sales.ZipCodes z
INNER MERGE JOIN Person.Address a
	  ON z.Zipcode = a.PostalCode
SELECT a.AddressLine1,z.City FROM Sales.ZipCodes z
INNER JOIN Person.Address a
	  ON z.Zipcode = a.PostalCode
SELECT a.AddressLine1,z.City FROM Sales.ZipCodes z
INNER LOOP JOIN Person.Address a
	  ON z.Zipcode = a.PostalCode