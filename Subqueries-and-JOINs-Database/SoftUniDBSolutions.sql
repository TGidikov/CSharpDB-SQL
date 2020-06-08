--PROBLEM 01:
SELECT TOP(5) e.EmployeeID,e.JobTitle,e.AddressID, a.AddressText
FROM dbo.Employees e
JOIN Addresses AS a ON
a.AddressID = e.AddressID
ORDER BY AddressID 

--PROBLEM 02:
SELECT TOP(50)  FirstName,LastName,t.[Name] AS Town,AddressText
FROM dbo.Employees e
JOIN dbo.Addresses a ON e.AddressID = a.AddressID
JOIN dbo.Towns t ON a.TownID = t.TownID
ORDER BY e.FirstName,e.LastName

--PROBLEM 03:
SELECT EmployeeID,FirstName,LastName, d.Name AS DeparmentName
FROM Employees
JOIN dbo.Departments d ON dbo.Employees.DepartmentID = d.DepartmentID
WHERE dbo.Employees.DepartmentID=3
ORDER BY dbo.Employees.EmployeeID

--PROBLEM 04:
SELECT TOP(5) EmployeeID,FirstName,Salary,d.Name AS DepartmentName FROM dbo.Employees e
JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
WHERE Salary>15000 
ORDER BY e.DepartmentID 

--PROBLEM 05:
SELECT TOP(3) e.EmployeeID,e.FirstName FROM dbo.Employees e
LEFT JOIN dbo.EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL
ORDER BY e.EmployeeID

--PROBLEM 06:
SELECT  FirstName,e.LastName,HireDate,d.Name AS DepartmentName FROM dbo.Employees e
JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Name IN ('Sales','Finance') AND HireDate > '1999.01.01'
ORDER BY HireDate

--PROBLEM 07:
SELECT TOP(5) e.EmployeeID,e.FirstName,p.Name AS ProjectName 
FROM Employees e
LEFT JOIN dbo.EmployeesProjects ep ON ep.EmployeeID=e.EmployeeID
JOIN dbo.Projects p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate>'2002.08.13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID

--PROBLEM 08:
SELECT  e.EmployeeID,e.FirstName,CASE
WHEN p.StartDate>'2005-01-01' THEN NULL
ELSE p.Name
END AS ProjectName
FROM dbo.Employees e
RIGHT JOIN dbo.EmployeesProjects ep ON ep.EmployeeID=e.EmployeeID
JOIN dbo.Projects p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID=24  

--PROBLEM 09:
SELECT e.EmployeeID,e.FirstName,e.ManagerID,m.FirstName AS ManagerName
FROM dbo.Employees e
JOIN dbo.Employees m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID =3 OR e.ManagerID=7
ORDER BY e.EmployeeID


--PROBLEM 10:
SELECT TOP (50)e.EmployeeID,e.FirstName +' '+ e.LastName AS EmployeeName,
m.FirstName+' '+ m.LastName AS ManagerName,
d.Name AS DepartmentName
FROM dbo.Employees e
JOIN dbo.Employees m ON e.ManagerID = m.EmployeeID 
JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

--PROBLEM 11:
SELECT MIN(m.AverageSalary) AS MinAverageSalary FROM 
(
SELECT e.DepartmentID,AVG(e.Salary) AS AverageSalary
FROM dbo.Employees e
GROUP BY e.DepartmentID
) AS m

