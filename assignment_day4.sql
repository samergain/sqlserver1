

--1.     
		CREATE VIEW view_product_order_saadoun
		AS
		select p.ProductID, p.ProductName, sum(od.Quantity) as totalQuantity
		from Products p join [Order Details] od on p.ProductID = od.ProductID
		group by p.ProductID, p.ProductName
		GO
--2.    
		CREATE PROCEDURE sp_product_order_quantity_saadoun
		@productID int,
		@quantity smallint out
		AS
		BEGIN
		select @quantity = sum(od.Quantity)
		from Products p join [Order Details] od on p.ProductID = od.ProductID
		where p.ProductID = @productID
		group by p.ProductID
		END
		GO

		BEGIN 
		DECLARE @q smallint
		exec sp_product_order_quantity_saadoun 1, @q out
		print @q
		END
		GO
--3. 
	CREATE PROCEDURE sp_product_order_city_saadoun
		@pID nvarchar(40)
		AS
		BEGIN
			select TOP 5 c.City, count(od.OrderID) as totalOrders, sum(od.Quantity) totalQuantity
			from Customers c
			join Orders o on c.CustomerID = o.CustomerID
			join [Order Details] od on o.OrderID = od.OrderID
			join Products p on od.ProductID = p.ProductID
			where p.ProductID = (select productID from products where ProductName LIKE @pID)
			group by c.City
		END
		GO

		BEGIN
		exec sp_product_order_city_saadoun 'Chang'
		END
		GO
		
--4
	CREATE TABLE dbo.city_saadoun(ID int primary key, 
								  City nvarchar(30) not null unique)
	GO						
	CREATE TABLE dbo.people_saadoun(ID int not null primary key,
									Name nvarchar(30) not null,
									City int foreign key references dbo.city_saadoun on delete set null)
	GO
	INSERT INTO dbo.city_saadoun VALUES(1, 'Seattle')
	INSERT INTO dbo.city_saadoun VALUES(2, 'Green Bay')
	INSERT INTO dbo.city_saadoun VALUES(3, 'Madison')
	INSERT INTO dbo.people_saadoun VALUES(1, 'Aaron Rodgers', 2),(2, 'Russell Wilson', 1),(3, 'Jody Nelson', 2)
	GO

	DELETE FROM city_saadoun where city = 'Seattle'
	GO

	UPDATE people_saadoun set City = 3 where City is null
	GO 

	CREATE VIEW Packers_saadoun
	AS
	select p.Name
	from people_saadoun p join city_saadoun c on c.ID = p.City
	where c.City = 'Green Bay'
	GO
	
	DROP TABLE dbo.city_saadoun
	DROP TABLE dbo.people_saadoun
	DROP VIEW Packers_saadoun
	GO

--5.  
CREATE PROC sp_birthday_employees_saadoun
AS
BEGIN
	SELECT *
		INTO birthday_employees_saadoun
	FROM Employees
	WHERE month(BirthDate) = 2
END
GO

BEGIN 
exec sp_birthday_employees_saadoun
END

select * from birthday_employees_saadoun
DROP TABLE  birthday_employees_saadoun

--6
--using INTERSECT and EXCEPT we can check if both tables have the same number of rows and all rows from one table are the same as all rows from the other table
select * from table1
INTERSECT
select * from table2
--should return the same rows number from table1 
select * from table1
EXCEPT
select * from table2
--should return nothing if identical, or return the different rows
--if the result is 