--PROBLEM:18
SELECT ProductName,OrderDate,
	DATEADD(DAY, 3, OrderDate) AS [Pay Due],
	DATEADD(MONTH,1,OrderDate) AS [Delivery Due]
FROM Orders

--PROBLEM:19
CREATE TABLE People
	(Id int PRIMARY KEY IDENTITY,
	[Name] nvarchar(50) NOT NULL,
	[Birthdate] datetime2 NOT NULL)

INSERT INTO dbo.People
	(Name,Birthdate)
VALUES
    ('Victor','2000-12-07'),
	('Steven','1992-09-10'),
	('Stephen','1910-09-19'),
	('John','2010-10-06')


SELECT [Name],
DATEDIFF(YEAR, Birthdate, GETDATE()) AS Age ,
DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],
DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in days],
DATEDIFF(Minute, Birthdate, GETDATE()) AS [Age in Minutes]
FROM dbo.People p