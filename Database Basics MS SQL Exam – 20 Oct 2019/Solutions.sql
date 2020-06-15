--1.Table Design:
CREATE TABLE Users
(Id int PRIMARY KEY IDENTITY,
 Username nvarchar(30) UNIQUE  NOT NULL,
 [Password] nvarchar(50) NOT NULL,
 [Name] nvarchar(50),
 Birthdate datetime2,
 Age tinyint CHECK(Age >= 14 AND Age <=110) ,
 Email nvarchar(50) NOT NULL)

 CREATE TABLE Departments 
 (Id int PRIMARY KEY  IDENTITY NOT NULL,
  [Name] nvarchar(50) NOT NULL)

  CREATE TABLE Employees
  (Id int PRIMARY KEY IDENTITY NOT NULL,
   FirstName nvarchar(25),
   LastName nvarchar(25),
   Birthdate datetime2,
   Age tinyint CHECK(Age >= 18 AND Age <=110),
   DepartmentId int FOREIGN KEY REFERENCES dbo.Departments(Id))

   CREATE TABLE Categories 
   (Id int PRIMARY KEY IDENTITY NOT NULL,
    [Name] nvarchar(50) NOT NULL,
	DepartmentId int FOREIGN KEY REFERENCES dbo.Departments(Id) NOT NULL)

	CREATE TABLE [Status]
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 [Label] nvarchar(30) NOT NULL)

	CREATE TABLE Reports 
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 CategoryId int FOREIGN KEY REFERENCES dbo.Categories(Id) NOT NULL,
	 StatusId int FOREIGN KEY REFERENCES dbo.[Status](Id) NOT NULL,
	 OpenDate datetime2 NOT NULL,
	 CloseDate datetime2,
	 [Description] nvarchar(200) NOT NULL,
	 UserId int FOREIGN KEY REFERENCES dbo.Users(Id) NOT NULL,
	 EmployeeId int FOREIGN KEY REFERENCES dbo.Employees(Id))

--2.Insert
INSERT INTO dbo.Employees
 ( 
    FirstName,
    LastName,
    Birthdate,
    DepartmentId
)
VALUES
('Marlo','O''Malley','1958-9-21',1),
('Niki','Stanaghan','1969-11-26',4),
('Ayrton','Senna','1960-03-21',9),
('Ronnie','Peterson','1944-02-14',9),
('Giovanna','Amati','1959-07-20',5)

INSERT INTO dbo.Reports
(
    CategoryId,
    StatusId,
    OpenDate,
    CloseDate,
    [Description],
    UserId,
    EmployeeId
)
VALUES
(1,1,'2017-04-13',NULL,'Stuck Road on Str.133',6,2),
(6,3,'2015-09-05','2015-12-06','Charity trail running',3,5),
(14,2,'2015-09-07',NULL,'Falling bricks on Str.58',5,2),
(4,3,'2017-07-03','2017-07-06','Cut off streetlight on Str.11',1,1)

--3.Update
UPDATE  Reports
SET CloseDate=GETDATE()
WHERE CloseDate IS NULL 

--4.Delete 
DELETE FROM Reports
WHERE Reports.StatusId=4

--5.Unassigned Reports
SELECT r.[Description],
FORMAT(r.OpenDate,'dd-MM-yyyy') AS OpenDate 
FROM dbo.Reports r
WHERE r.EmployeeId IS NULL
ORDER BY r.OpenDate ,r.[Description]

--6.Reports & Categories
SELECT [Description],[Name] AS CategoryName FROM dbo.Reports r
JOIN dbo.Categories c ON r.CategoryId = c.Id
WHERE r.CategoryId IS NOT NULL
ORDER BY [Description],[Name]

--7.Most Reported Category
SELECT TOP (5)c.[Name] AS CategoryName,
COUNT(CategoryId) AS ReportsNumber 
FROM dbo.Reports r
JOIN dbo.Categories c ON r.CategoryId=c.Id
GROUP BY r.CategoryId,c.[Name]
ORDER BY COUNT(CategoryId) DESC , [Name]

--8.Birthday Report
SELECT u.Username,c.[Name] AS CategoryName FROM dbo.Users u
JOIN dbo.Reports r ON r.UserId=u.Id 
JOIN dbo.Categories c ON c.Id=CategoryId
WHERE  DATEPART(MONTH,OpenDate)  = DATEPART(MONTH,Birthdate)
	   AND DATEPART(DAY,OpenDate) = DATEPART(DAY,Birthdate)
ORDER BY u.Username,c.[Name]

--9.Users per Employees
SELECT (e.FirstName+' '+e.LastName)AS [Full Name],
COUNT(r.UserId) AS UsersCount  FROM Employees e
LEFT JOIN dbo.Reports r ON e.Id = r.EmployeeId
LEFT JOIN dbo.Users u ON r.UserId = u.Id
GROUP BY e.FirstName , e.LastName
ORDER BY COUNT(r.UserId) DESC , [Full Name]

--10.
SELECT ISNULL((e.FirstName+ ' '+ e.LastName),'None') AS Employee,
       ISNULL(d.[Name],'None') AS Department,
       ISNULL(c.[Name],'None') AS Category,
       ISNULL(r.[Description],'None') AS [Description],
       FORMAT(r.OpenDate,'dd.MM.yyyy') AS [OpenDate],
       s.[Label] AS [Status],
       ISNULL(u.[Name],'None') AS [User]
FROM Reports AS r
    LEFT JOIN Employees AS e ON r.EmployeeId = e.Id
    LEFT JOIN Categories AS c ON r.CategoryId = c.Id   
    LEFT JOIN Users AS u ON r.UserId = u.Id
	LEFT JOIN [Status] AS s ON r.StatusId = s.Id
    LEFT JOIN Departments AS d ON e.DepartmentId = d.Id
ORDER BY e.FirstName DESC, e.LastName DESC, Department, Category, [Description], OpenDate, [Status], [User]

--PROBLEM 11:
CREATE FUNCTION udf_HoursToComplete
(@StartDate DATETIME2, @EndDate DATETIME2) RETURNS INT
AS 
BEGIN
	DECLARE @Result int 
	BEGIN
	IF	@StartDate IS NULL OR @EndDate IS NULL	
	 SET @Result = 0
	ELSE 
	 SET @Result= DATEDIFF(HOUR,@StartDate,@EndDate)
	 END
	RETURN @Result
	 
END

--PROBLEM 12:
CREATE PROC usp_AssignEmployeeToReport
(@EmployeeId int, @ReportId int)
AS 
DECLARE @DepartmentEmployee  int = (SELECT e.DepartmentId 
								 FROM dbo.Employees e 
								 WHERE e.Id=@EmployeeId)

DECLARE @DepartmentReport int = (SELECT c.DepartmentId
									FROM Reports r
									JOIN  Categories c ON r.CategoryId = c.Id
									WHERE r.Id = @ReportId)

		IF(@DepartmentEmployee != @DepartmentReport)
		BEGIN
		;THROW 55555,'Employee doesn''t belong to the appropriate department!',1;
		END

UPDATE dbo.Reports
SET EmployeeId=@EmployeeId
	WHERE Id=@ReportId;
    
