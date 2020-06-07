--PROBLEM 14:
SELECT TOP(50) [Name],FORMAT( Start,'yyyy-MM-dd') AS Start
FROM Games 
WHERE YEAR (Start) BETWEEN 2011 AND 2012
ORDER BY Start , Name 

--PROBLEM 15:
SELECT Username,RIGHT(Email, LEN(Email) - CHARINDEX('@', email)) 
AS [Email Provider] 
FROM Users
ORDER BY [Email Provider] ,Username

--PROBLEM 16:
SELECT Username,IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___' 
ORDER BY Username

--PROBLEM 17:
 SELECT [Name],
	CASE
		WHEN DATEPART(HOUR,[Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR,[Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END AS [Part of the Day],
	CASE 
		WHEN g.Duration < 4 THEN 'Extra Short'
		WHEN g.Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN g.Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
		END AS [Duration]
FROM dbo.Games g
ORDER BY [Name],Duration,[Part of the Day]


 