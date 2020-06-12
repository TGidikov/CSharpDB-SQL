--PROBLEM 13:
SELECT DepartmentId,
SUM(Salary) AS TotalSalary
FROM dbo.Employees e
GROUP BY e.DepartmentID

--PROBLEM 14:
SELECT e.DepartmentID,
MIN(Salary)AS MinimumSalary
FROM dbo.Employees e
WHERE e.DepartmentID IN (2,5,7) AND e.HireDate>'2000-01-01'
GROUP BY e.DepartmentID

--PROBLEM 15:
SELECT *
INTO NewEmployeees 
FROM Employees e
WHERE e.Salary>30000

DELETE FROM dbo.NewEmployeees 
WHERE ManagerID = 42


UPDATE dbo.NewEmployeees
SET dbo.NewEmployeees.Salary += 5000
WHERE DepartmentID =1 

SELECT DepartmentID,AVG(Salary) AS AverageSalary 
FROM dbo.NewEmployeees 
GROUP BY dbo.NewEmployeees.DepartmentID

--PROBLEM 16:
SELECT DepartmentID, MAX(e.Salary)
AS MaxSalary FROM dbo.Employees e
GROUP BY e.DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--PROBLEM 17:
SELECT COUNT(*) AS [Count] FROM Employees
WHERE ManagerID IS NULL

--PROBLEM 18:
SELECT DepartmentID, 
		 Salary AS ThirdHighestSalary
FROM(
     SELECT e.DepartmentID,e.Salary,
     DENSE_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY Salary DESC) AS [SalaryRank]
     FROM dbo.Employees e
	 GROUP BY DepartmentID,e.Salary
	) AS [SalaryRanking]
WHERE SalaryRank=3

--PROBLEM 19:
SELECT TOP(10)  e1.FirstName,
				e1.LastName,
				e1.DepartmentID 
FROM dbo.Employees e1
WHERE e1.Salary> (SELECT
                 AVG(Salary) AS [AverageSalary]
                 FROM Employees e2
				 WHERE e2.DepartmentID=e1.DepartmentID
                 GROUP BY DepartmentID)  
ORDER BY DepartmentID












