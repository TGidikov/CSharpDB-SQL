--Problem 22:
SELECT dbo.Peaks.PeakName FROM dbo.Peaks 
ORDER BY dbo.Peaks.PeakName ASC

--Problem 23:
SELECT TOP(30) CountryName,[Population] FROM dbo.Countries 
WHERE dbo.Countries.ContinentCode='EU'
ORDER BY dbo.Countries.Population DESC,
dbo.Countries.CountryName ASC

--Problem 24:
SELECT CountryName,CountryCode,
CASE
	WHEN CurrencyCode  = 'EUR' THEN 'Euro'
	ELSE 'Not Euro'
	END AS Currency
FROM dbo.Countries 
ORDER BY CountryName
--Problem 24:
USE Diablo
SELECT [Name] FROM Characters
ORDER BY [Name]

