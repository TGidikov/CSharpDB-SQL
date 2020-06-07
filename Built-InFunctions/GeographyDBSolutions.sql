--PROBLEM 12:
SELECT CountryName , ISOCode FROM dbo.Countries 
WHERE CountryName like '%a%a%a%' 
ORDER BY dbo.Countries.IsoCode

--PROBLEM 13:
SELECT PeakName,RiverName,LOWER( CONCAT(p.PeakName,SUBSTRING(r.RiverName,2,LEN(r.RiverName)-1))) AS [Mix]
FROM Peaks AS p , dbo.Rivers AS r
WHERE RIGHT(PeakName,1)= LEFT(RiverName,1)
ORDER BY Mix



