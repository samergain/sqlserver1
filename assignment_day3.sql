
--1
SELECT DISTINCT c.City
FROM Customers c 
WHERE c.City in (
SELECT DISTINCT City
FROM Employees 
)

--2
--a)
SELECT DISTINCT c.City
FROM Customers c 
WHERE c.City NOT IN (
SELECT DISTINCT City
FROM Employees 
)

--b
SELECT DISTINCT c.City
FROM Customers c
EXCEPT
SELECT DISTINCT City
FROM Employees

--3
SELECT p.ProductID, p.ProductName, (SELECT SUM(Quantity) AS SoldQuantities
									FROM [Order Details] od
									WHERE od.ProductID = p.ProductID
									GROUP BY od.ProductID ) 
FROM Products p

--4
SELECT o.ShipCity, SUM(od.Quantity) as "Total Sold Products"
FROM Orders o join [Order Details] od on o.OrderID = od.OrderID
WHERE o.ShipCity IN (SELECT DISTINCT City FROM Customers)
GROUP BY o.ShipCity

--5---------GET BACK HERE--------
--a)

--b)
select distinct d.City, d.CustomerCount
from (select City, count(City) over(partition by city) as CustomerCount from Customers) d
where d.CustomerCount >= 2

--6
Select c.City from Customers c
join
(select o.ShipCity, count(p.CategoryID) as numOfProductCategory
from orders o join [Order Details] od on o.OrderID = od.OrderID join Products p on od.ProductID = p.ProductID
group by o.ShipCity
having count(p.CategoryID) > 2) as d on c.City = d.ShipCity

--7
select distinct coCity.ContactName
from (
select c.ContactName, c.City, o.ShipCity
from Customers c join Orders o on c.CustomerID = o.CustomerID) as coCity
where coCity.City <> coCity.ShipCity


--8
--List 5 most popular products, their average price, and the customer city that ordered most quantity of it

select a.pid, a.pname, a.numOfOrders, a.avgPrice, co.city TopCity, co.totalQ QuantityOrderedInCity  from (
--top 5 products and their avg
		select top 5 od.ProductID pid, p.productname pname, count(od.OrderID) numOfOrders, avg(od.UnitPrice) avgPrice
		from [Order Details] od join products p on od.productid = p.productid
		group by od.ProductID, p.productname
		order by numOfOrders desc
) as a 
join (
--popular products
select c.city city, c.pid pid, c.totalQuantity totalQ
from (
select c.city city, od.ProductID pid, sum(od.quantity) as totalQuantity, RANK() OVER(PARTITION BY od.ProductID ORDER BY sum(od.quantity) DESC) AS RNK
		from customers c join orders o on c.CustomerID = o.CustomerID join [Order Details] od on o.OrderID = od.OrderID
		group by c.city, od.ProductID
		) as c
where c.RNK = 1
) as co 
on a.pid = co.pid


--9
--List all cities that have never ordered something but we have employees there.
select distinct e.City empCity
from Employees e
where e.City not in (select distinct ShipCity from orders)

select distinct e.City empCity
from Employees e
EXCEPT (select distinct ShipCity from orders)


--10
--List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
--and also the city of most total quantity of products ordered from. (tip: join  sub-query)

select e.eCity, c.cCity
from (select top 1 e.EmployeeID, e.FirstName, e.City eCity, count(o.OrderID) numOfOrders 
from Employees e join orders o on o.EmployeeID = e.EmployeeID
Group by e.EmployeeID, e.FirstName, e.City
order by numOfOrders desc) as e
join (select top 1 c.city cCity, sum(od.quantity) as totalQuantity
		from customers c join orders o on c.CustomerID = o.CustomerID join [Order Details] od on o.OrderID = od.OrderID
		group by c.city
		order by totalQuantity desc) as c 
on e.eCity = c.cCity

--11. How do you remove the duplicates record of a table?
--we can use CTE with ROW_NUMBER() to find and delete duplicates
WITH CTE(col1, col2, col3, DuplicateCount)
AS (SELECT col1, col2, col3, ROW_NUMBER() OVER(PARTITION BY col1, col2, col3 ORDER BY ID) AS DuplicateCount
    FROM table1)
DELETE FROM CTE
WHERE DuplicateCount > 1;