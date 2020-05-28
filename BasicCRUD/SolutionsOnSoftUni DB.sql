--Problem 02:
SELECT * FROM dbo.Departments 
--Problem 03:
SELECT [Name] FROM Departments
--Problem 04:
SELECT [FirstName],[LastName],Salary FROM dbo.Employees 
--Problem 05:
SELECT [FirstName],[MiddleName],[LastName] FROM dbo.Employees
--Problem 06:
SELECT [FirstName]+'.'+[LastName]+'@softuni.bg' AS[Full Email Address]
FROM dbo.Employees
--Problem 07:
SELECT DISTINCT dbo.Employees.Salary FROM dbo.Employees
--Problem 08:
SELECT* FROM dbo.Employees
WHERE JobTitle = 'Sales Representative'
--Problem 09:
SELECT [FirstName],[LastName],JobTitle FROM dbo.Employees 
WHERE Salary>=20000 AND Salary<=30000
--Problem 10:
SELECT [FirstName]+' '+[MiddleName]+' '+[LastName] AS [Full Name] FROM dbo.Employees
WHERE Salary=25000 OR Salary=14000 OR Salary=12500 OR Salary=23600
--Problem 11:
SELECT [FirstName],[LastName] FROM dbo.Employees
WHERE ManagerID IS NULL
--Problem 12:
SELECT [FirstName],[LastName],Salary FROM dbo.Employees
 WHERE Salary > 50000  ORDER BY Salary DESC 
--Problem 13:
SELECT TOP 5 [FirstName],[LastName] FROM dbo.Employees
 ORDER BY Salary DESC 
--Problem 14:
SELECT  [FirstName],[LastName] FROM dbo.Employees
 WHERE dbo.Employees.DepartmentID!=4
--Problem 15:
SELECT * FROM dbo.Employees 
 ORDER BY dbo.Employees.Salary DESC ,
 [dbo].[Employees].FirstName ,
 [dbo].[Employees].LastName DESC,
 [dbo].[Employees].MiddleName
--Problem 16:
CREATE VIEW V_EmployeesSalaries
 AS SELECT FirstName,LastName,Salary FROM dbo.Employees 
--Problem 17:
CREATE VIEW [V_EmployeeNameJobTitle] AS
SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name]
,JobTitle AS [Job Title] FROM Employees 
--Problem 18:
SELECT DISTINCT JobTitle FROM Employees
--Problem 19:
SELECT TOP(10) * FROM Projects
ORDER BY dbo.Projects.StartDate,
dbo.Projects.Name
--Problem 20:
SELECT TOP(7) FirstName,LastName,HireDate FROM dbo.Employees 
ORDER BY HireDate DESC
--Problem 21:
UPDATE  dbo.Employees 
SET dbo.Employees.Salary+=dbo.Employees.Salary*0.12
WHERE dbo.Employees.DepartmentID = 1 OR dbo.Employees.DepartmentID=2 
OR dbo.Employees.DepartmentID=4 OR dbo.Employees.DepartmentID=11
SELECT Salary FROM Employees