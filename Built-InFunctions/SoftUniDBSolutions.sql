
--Problem 01:
SELECT FirstName,LastName FROM dbo.Employees e
WHERE e.FirstName LIKE 'Sa%'

--Problem 02:
SELECT FirstName,LastName FROM dbo.Employees e
WHERE e.LastName LIKE '%ei%'

--Problem 03:
SELECT FirstName FROM dbo.Employees 
WHERE DepartmentID=3 OR dbo.Employees.DepartmentID=10 
AND  HireDate  BETWEEN '01-01-1995' AND '01-31-2005'

--PROBLEM 04:
SELECT FirstName,LastName FROM dbo.Employees
WHERE dbo.Employees.JobTitle NOT LIKE'%engineer%'

--PROBLEM 05:
SELECT [Name] FROM dbo.Towns t
WHERE LEN([Name])=5 OR LEN([Name])=6 
ORDER BY [Name]

--PROBLEM 06:
SELECT * FROM dbo.Towns t
WHERE [Name] LIKE'M%' OR [Name] LIKE 'K%' OR [Name] LIKE 'B%' OR [Name] LIKE 'E%'
ORDER BY [Name]

--PROBLEM 07:
SELECT * FROM dbo.Towns t
WHERE [Name] NOT LIKE'R%' AND [Name] NOT LIKE 'B%' AND [Name] NOT LIKE 'D%'
ORDER BY [Name]

--PROBLEM 08:
CREATE VIEW V_EmployeesHiredAfter2000  AS
SELECT FirstName,LastName FROM dbo.Employees 
WHERE YEAR(HireDate) >'2000'

--PROBLEM 09:
SELECT FirstName, LastName FROM dbo.Employees 
WHERE LEN(dbo.Employees.LastName)=5

--PROBLEM 10:
SELECT EmployeeID,FirstName,LastName,Salary,  
       DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank
FROM dbo.Employees 
WHERE dbo.Employees.Salary  BETWEEN 10000 AND  50000 
ORDER BY dbo.Employees.Salary DESC

--PROBLEM 11:
WITH Rank_Managemnet AS
(
SELECT EmployeeID,FirstName,LastName,Salary,  
       DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM dbo.Employees 
WHERE  dbo.Employees.Salary  BETWEEN 10000 AND  50000 
)

SELECT EmployeeID,FirstName,LastName,Salary,[Rank] FROM Rank_Managemnet 
WHERE [Rank] =2 
ORDER BY Salary DESC
