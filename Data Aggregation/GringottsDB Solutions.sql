--PROBLEM 01:
SELECT COUNT(*) AS [Count] FROM dbo.WizzardDeposits wd 
--PROBLEM 02:
SELECT MAX(MagicWandSize) AS LongestMagicWand  FROM dbo.WizzardDeposits wd
--PROBLEM 03:
SELECT wd.DepositGroup,MAX(MagicWandSize) AS LongestMagicWand FROM dbo.WizzardDeposits wd
GROUP BY DepositGroup
--PROBLEM 04:
SELECT TOP(2) wd.DepositGroup FROM dbo.WizzardDeposits wd
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize) ASC

--PROBLEM 05:
SELECT  wd.DepositGroup, SUM(DepositAmount) AS TotalSum FROM dbo.WizzardDeposits wd
GROUP BY DepositGroup


--PROBLEM 06:
SELECT  wd.DepositGroup, SUM(DepositAmount) AS TotalSum FROM dbo.WizzardDeposits wd
WHERE wd.MagicWandCreator ='Ollivander family'
GROUP BY DepositGroup

--PROBLEM 07:
SELECT * FROM 
			(SELECT  wd.DepositGroup, SUM(DepositAmount) AS TotalSum FROM dbo.WizzardDeposits wd
			WHERE wd.MagicWandCreator ='Ollivander family'  
			GROUP BY DepositGroup) AS DA 
WHERE DA.TotalSum<150000
ORDER BY DA.TotalSum DESC

--PROBLEM 08:
SELECT wd.DepositGroup,wd.MagicWandCreator,
MIN(DepositCharge) AS MinDepositCharge 
FROM dbo.WizzardDeposits wd
GROUP BY wd.DepositGroup, MagicWandCreator
ORDER BY wd.MagicWandCreator,DepositGroup

--PROBLEM 09:
SELECT ag.AgeGroup,COUNT(AgeGroup) AS WizzardCount FROM 
(SELECT 
		CASE 
		    WHEN wd.Age BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN wd.Age BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN wd.Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN wd.Age BETWEEN 31 AND 40 THEN '[31-40]'
		    WHEN wd.Age BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN wd.Age BETWEEN 51 AND 60 THEN '[51-60]'
			ELSE '[61+]' END AS [AgeGroup]
  FROM dbo.WizzardDeposits wd 
  )
  AS AG
GROUP BY AG.AgeGroup

--PROBLEM 10:
SELECT SUBSTRING(FirstName,1,1) AS FirstLetter FROM dbo.WizzardDeposits wd
WHERE DepositGroup='Troll Chest'

--PROBLEM 11:
SELECT DepositGroup,IsDepositExpired,
AVG(DepositInterest) AS AverageInterest
FROM dbo.WizzardDeposits wd
WHERE wd.DepositStartDate>'1985-01-01'
GROUP BY wd.DepositGroup ,isDepositExpired
ORDER BY wd.DepositGroup DESC  ,isDepositExpired

--PROBLEM 12:
SELECT  SUM([Difference]) AS SumDifference
	FROM 
		(SELECT FirstName AS [HostWizzard],
      		wd.DepositAmount AS [Host Wizard Deposit],
      		LEAD(FirstName) OVER(ORDER BY Id ) AS [Guest Wizard],
      		LEAD(DepositAmount) OVER(ORDER BY Id ) AS [Guest Wizard Deposit],
			wd.DepositAmount-LEAD(DepositAmount) OVER(ORDER BY Id )AS [Difference]
		FROM dbo.WizzardDeposits wd)
		AS [LeadQuery] 
		WHERE [Guest Wizard] IS NOT NULL
	
		


