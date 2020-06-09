--PROBLEM 12:
SELECT MountainsCountries.CountryCode AS CountryCode,
MountainRange,PeakName,Elevation
FROM  Peaks
JOIN dbo.Mountains m ON dbo.Peaks.MountainId = m.Id
JOIN dbo.MountainsCountries ON m.Id = dbo.MountainsCountries.MountainId
WHERE Elevation >'2835' AND dbo.MountainsCountries.CountryCode='BG'
ORDER BY dbo.Peaks.Elevation DESC

--PROBLEM 13:
SELECT mc.CountryCode,COUNT(m.MountainRange) 
FROM dbo.Mountains m
JOIN dbo.MountainsCountries mc ON m.Id = mc.MountainId
WHERE mc.CountryCode IN ('BG','RU','US')
GROUP BY mc.CountryCode

--PROBLEM 14:
SELECT TOP(5)CountryName ,RiverName FROM Countries c
LEFT JOIN dbo.CountriesRivers cr ON c.CountryCode = cr.CountryCode
LEFT JOIN dbo.Rivers r ON cr.RiverId = r.Id
JOIN Continents co ON c.ContinentCode = co.ContinentCode 
WHERE c.ContinentCode='AF'
ORDER BY CountryName
--PROBLEM 15:
SELECT ContinentCode, CurrencyCode, CurrencyCount AS CurrencyUsage
  FROM (
	   SELECT ContinentCode, 
       CurrencyCode,
	   CurrencyCount,
	   DENSE_RANK() OVER
	   (PARTITION BY ContinentCode ORDER BY CurrencyCount DESC) AS CurrencyRank
	   FROM (
		       SELECT ContinentCode,
		       	   CurrencyCode,
		       	   COUNT(*) AS [CurrencyCount]
		         FROM Countries
		        GROUP BY ContinentCode, CurrencyCode
				) AS [CurrencyCountQuery]
 WHERE CurrencyCount > 1 ) AS CurrencyRanking
 WHERE CurrencyRank = 1
 ORDER BY ContinentCode 

--PROBLEM 16: 
SELECT COUNT(ContinentCode)FROM dbo.Countries c
LEFT JOIN dbo.MountainsCountries mc ON c.CountryCode = mc.CountryCode
WHERE mc.MountainId IS NULL

--PROBLEM 17:
SELECT TOP(5) c.CountryName ,
	MAX(p.Elevation) AS [HighestPeakElevation],
	MAX(r.[Length]) AS [LongestRiverLength]	
 FROM dbo.Countries c
LEFT OUTER JOIN CountriesRivers cr ON c.CountryCode = cr.CountryCode
LEFT OUTER JOIN dbo.Rivers r ON cr.RiverId = r.Id
LEFT OUTER JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
LEFT OUTER JOIN Mountains m ON mc.MountainId = m.Id
LEFT OUTER JOIN  Peaks p ON p.MountainId = m.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC , LongestRiverLength DESC,c.CountryName

--PROBLEM 18:
SELECT TOP (5)Country,
	   CASE 
			WHEN PeakName IS NULL THEN '(no highest peak)'
			ELSE PeakName
	   END AS [Highest Peak Name], 
	   CASE
	       WHEN Elevation IS NULL THEN 0
		   ELSE Elevation END AS [Highest Peak Elevation],
	  CASE 
			WHEN MountainRange IS NULL THEN '(no mountain)'
			ELSE MountainRange END AS [Mountain]
FROM
(SELECT * , 
		DENSE_RANK() OVER 
		(PARTITION BY [Country] ORDER BY Elevation DESC) AS [PeakRank]
  FROM (
		SELECT c.CountryName AS [Country],
					  p.PeakName,
					  p.Elevation,
					  m.MountainRange
					  FROM dbo.Countries c
	  LEFT JOIN dbo.MountainsCountries mc ON c.CountryCode = mc.CountryCode
	  LEFT JOIN Mountains m ON mc.MountainId = m.Id
	  LEFT JOIN dbo.Peaks p ON p.MountainId=m.Id
	  ) AS [FullInfoQuery] 
	  ) AS [PeakRankingsQUERY] 
WHERE [PeakRank]=1
ORDER BY Country ,[Highest Peak Name]