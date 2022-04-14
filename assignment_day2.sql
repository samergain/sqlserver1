--1
SELECT COUNT(productId) numOfProducts
FROM Production.Product
--result: 504

--2
SELECT COUNT(ProductSubcategoryID) numOfProducts
FROM Production.Product
--result: 295

--3
SELECT ProductSubcategoryID, COUNT(ProductSubcategoryID) CountedProducts 
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

--4
SELECT ProductSubcategoryID, COUNT(*) CountedProductsWithNoSubcategory 
FROM Production.Product
WHERE ProductSubcategoryID IS NULL
GROUP BY ProductSubcategoryID

--5
SELECT SUM(Quantity) TotalQuantity
FROM Production.ProductInventory

--6
SELECT ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--7
SELECT Shelf, ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

--8
SELECT AVG(Quantity) AvgQuantity
FROM Production.ProductInventory
WHERE LocationID = 10

--9
SELECT ProductID, Shelf, AVG(Quantity) TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

--10
SELECT ProductID, Shelf, AVG(Quantity) TheAvg
FROM Production.ProductInventory
WHERE Shelf NOT LIKE 'N/A'
GROUP BY ProductID, Shelf

--11
SELECT Color, Class, COUNT(Color) TheCount, AVG(ListPrice) AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

--12
SELECT c.Name Country, s.Name Province
FROM Person.CountryRegion c INNER JOIN Person.StateProvince s 
ON c.CountryRegionCode = s.CountryRegionCode

--13
SELECT c.Name Country, s.Name Province
FROM Person.CountryRegion c INNER JOIN Person.StateProvince s 
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany','Canada')

---------Northwind-----------
use Northwind
GO
--14
SELECT p.ProductID, p.ProductName, o.OrderDate SoldDate
FROM Products p INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
				INNER JOIN Orders o ON od.OrderID = o.OrderID
where o.OrderDate >= '1997-01-01 00:00:00.000'

--15
SELECT TOP 5 o.ShipPostalCode, SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY SUM(od.UnitPrice * od.Quantity) DESC

--16
SELECT TOP 5 o.ShipPostalCode, o.OrderDate, SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.ShipPostalCode IS NOT NULL AND o.OrderDate >= '1997-01-01 00:00:00.000'
GROUP BY o.ShipPostalCode,  o.OrderDate
ORDER BY SUM(od.UnitPrice * od.Quantity) DESC

--17
SELECT City, Country, COUNT(CustomerID) NumOfCustomers
FROM Customers
GROUP BY City, Country

--18
SELECT City, Country, COUNT(CustomerID) NumOfCustomers
FROM Customers
GROUP BY City, Country
HAVING COUNT(CustomerID) > 2

--19
SELECT DISTINCT c.ContactName
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '1998-01-01 00:00:00.000'

--20
SELECT c.ContactName, MAX(o.OrderDate) RecentOrder
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY c.ContactName

--21
SELECT c.ContactName, COUNT(od.ProductID) NumOfProducts
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
				 LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName

--22
SELECT c.CustomerID, c.ContactName, COUNT(od.ProductID) NumOfProducts
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
				 LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName
HAVING COUNT(od.ProductID) > 100

--23
SELECT su.CompanyName as [Supplier Company Name], sh.CompanyName as [Shipping Company Name]
FROM Suppliers su CROSS JOIN Shippers sh
ORDER BY su.CompanyName

--24
SELECT o.OrderDate, p.ProductName
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
			  INNER JOIN Products p ON p.ProductID = od.ProductID
ORDER BY o.OrderDate DESC

--25
SELECT  (e1.FirstName+ ' '+e1.LastName) e1Names, (e2.FirstName+ ' '+e2.LastName) e2Names
FROM Employees e1 CROSS JOIN Employees e2 
WHERE e1.Title = e2.Title AND (e1.FirstName+ ' '+e1.LastName) <> (e2.FirstName+ ' '+e2.LastName)

--26
SELECT (e1.FirstName+ ' '+e1.LastName) e1Names, COUNT(e2.ReportsTo) 
FROM Employees e1 INNER JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY (e1.FirstName+ ' '+e1.LastName)
HAVING COUNT(e2.ReportsTo) > 2

--27
SELECT City, CompanyName, ContactName, 'Customer' AS Type 
FROM Customers
UNION SELECT City, CompanyName, ContactName, 'Supplier'
FROM Suppliers
ORDER BY City