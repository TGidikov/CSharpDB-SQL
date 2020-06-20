--1.Database Design
CREATE TABLE Students
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 FirstName nvarchar(30) NOT NULL,
	 MiddleName nvarchar(25),
	 LastName nvarchar(30) NOT NULL,
	 Age int CHECK (Age>0),
	 [Address] nvarchar(50), 
	 Phone nvarchar(10) )

CREATE TABLE Subjects 
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 [Name] nvarchar(20) NOT NULL,
	 Lessons int CHECK(Lessons>0) NOT NULL)

CREATE TABLE StudentsSubjects 
	(Id Int PRIMARY KEY IDENTITY NOT NULL,
	 StudentId int FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	 SubjectId int FOREIGN KEY REFERENCES Subjects(Id) NOT NULL,
	 Grade decimal (16,2) CHECK (Grade >=2.00 AND GRADE <=6.00) NOT NULL)

CREATE TABLE Exams 
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 [Date] datetime2 ,
	 SubjectId int NOT NULL FOREIGN KEY REFERENCES Subjects(Id))

CREATE TABLE StudentsExams
	(StudentId int FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	ExamId int FOREIGN KEY REFERENCES Exams(Id) NOT NULL,
	Grade decimal (16,2) CHECK (Grade >=2.00 AND GRADE <=6.00) NOT NULL
	CONSTRAINT PK_StudentIdExamId PRIMARY KEY (StudentId,ExamId))

CREATE TABLE Teachers
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 FirstName nvarchar(20) NOT NULL,
	 LastName nvarchar(20) NOT NULL,
	 [Address] nvarchar(20) NOT NULL,
	 Phone nvarchar(10),
	 SubjectId int FOREIGN KEY REFERENCES Subjects(Id) NOT NULL)

CREATE TABLE StudentsTeachers
	(StudentId int FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	TeacherId int FOREIGN KEY REFERENCES Teachers(ID) NOT NULL
	CONSTRAINT PK_StudentsTeachers  PRIMARY KEY (StudentId,TeacherId))

--2.Insert
INSERT INTO Teachers
(FirstName,LastName,[Address],Phone,SubjectId)
VALUES
('Ruthanne','Bamb','84948 Mesta Junction',3105500146,6),
('Gerrard','Lowin','370 Talisman Plaza',3324874824,2),
('Merrile','Lambdin','81 Dahle Plaza',4373065154,5),
('Bert','Ivie','2 Gateway Circle',4409584510,4)

INSERT INTO Subjects
([Name],Lessons)
VALUES
('Geometry',12),
('Health',10),
('Drama',7),
('Sports',9)

--3.Update 
UPDATE StudentsSubjects
SET Grade=6.00
WHERE Grade>=5.50 AND SubjectId IN (1,2)

--4.Delete
DELETE FROM StudentsTeachers
WHERE TeacherId IN (SELECT Id FROM Teachers WHERE Phone Like '%72%')
DELETE FROM Teachers
WHERE Phone Like '%72%'

--5.Teen Students
SELECT FirstName,LastName,Age FROM Students
WHERE Age >=12
ORDER BY FirstName,LastName

--6.Cool Addresses
SELECT (FirstName+' '+ISNULL(MiddleName,'')+' '+LastName) AS [Full Name],
Address
FROM Students
WHERE [Address] LIKE '%road%'
ORDER BY FirstName,LastName,[Address]

--7.42 Phones
SELECT FirstName,[Address],Phone FROM Students
WHERE Phone LIKE '42%' AND MiddleName IS NOT NULL
ORDER BY FirstName

--8.Students Teachers
SELECT FirstName,LastName,COUNT(TeacherId) AS TeachersCount FROM Students s
JOIN StudentsTeachers st ON st.StudentId= s.Id
GROUP BY FirstName,LastName

--9. Subjects with Students
SELECT CONCAT(FirstName,' ',LastName) AS [FullName],
S.[Name]+'-'+CAST(s.Lessons AS nvarchar) AS Subjects,
COUNT(st.StudentId) AS Students
FROM Teachers T
JOIN StudentsTeachers ST ON T.Id=ST.TeacherId
JOIN Subjects S ON T.SubjectId=s.Id
GROUP BY FirstName,LastName,s.[Name],s.Lessons
ORDER BY  COUNT(st.StudentId) DESC ,FullName,Subjects

--10.Students to Go
SELECT FirstName+' '+LastName AS [Full Name] FROM Students S
LEFT JOIN StudentsExams SE ON S.Id=se.StudentId
LEFT JOIN Exams E ON e.SubjectId=se.ExamId
WHERE Se.ExamId IS NUll
ORDER BY [Full Name]

--11.Busiest Teachers
SELECT TOP(10) FirstName,LastName,
COUNT(st.StudentId) AS Students
FROM Teachers T
JOIN StudentsTeachers ST ON T.Id=ST.TeacherId
JOIN Subjects S ON T.SubjectId=s.Id
GROUP BY FirstName,LastName
ORDER BY  COUNT(st.StudentId) DESC ,FirstName,LastName

--12.Top Students 
SELECT TOP(10) FirstName,LastName,
FORMAT(AVG(SE.Grade),'F2') AS Grade
FROM Students S
JOIN StudentsExams SE ON Se.StudentId=S.Id
GROUP BY FirstName, LastName
ORDER BY Grade DESC,FirstName,LastName

--13.Second Highest Grade
SELECT FirstName,LastName,Grade 
FROM							
    (SELECT s.FirstName,s.LastName,SE.Grade,
    ROW_NUMBER() OVER(PARTITION BY S.FirstName,S.LastName ORDER BY SE.Grade DESC) AS RowGrade
    FROM Students S
    JOIN StudentsSubjects SE ON Se.StudentId=S.Id) AS temp
WHERE RowGrade=2
ORDER BY FirstName,LastName

--14.Not So In The Studying
SELECT FirstName+ISNULL(' '+MiddleName,'')+' '+LastName AS [Full Name] 
FROM Students S
LEFT JOIN StudentsSubjects SS ON S.Id=ss.StudentId
WHERE SubjectId IS NULL
ORDER BY [Full Name]


--15.Top Student per Teacher
SELECT j.[Teacher Full Name], j.SubjectName ,j.[Student Full Name], FORMAT(j.TopGrade, 'N2') AS Grade
  FROM (
SELECT k.[Teacher Full Name],k.SubjectName, k.[Student Full Name], k.AverageGrade  AS TopGrade,
	   ROW_NUMBER() OVER (PARTITION BY k.[Teacher Full Name] ORDER BY k.AverageGrade DESC) AS RowNumber
  FROM (
  SELECT t.FirstName + ' ' + t.LastName AS [Teacher Full Name],
  	   s.FirstName + ' ' + s.LastName AS [Student Full Name],
  	   AVG(ss.Grade) AS AverageGrade,
  	   su.Name AS SubjectName
    FROM Teachers AS T 
    JOIN StudentsTeachers AS ST ON st.TeacherId = T.Id
    JOIN Students AS S ON s.Id = st.StudentId
    JOIN StudentsSubjects AS SS ON ss.StudentId = s.Id
    JOIN Subjects AS SU ON su.Id = ss.SubjectId AND su.Id = t.SubjectId
GROUP BY T.FirstName, T.LastName, s.FirstName, s.LastName, su.[Name]
) AS k
) AS j
   WHERE j.RowNumber = 1 
ORDER BY j.SubjectName,j.[Teacher Full Name], TopGrade DESC

--16.Average Grade per Subject 
SELECT [Name],AVG(Grade) AS AverageGrade FROM Subjects S
JOIN StudentsSubjects SS ON S.Id =ss.SubjectId
GROUP BY [Name],SubjectId
ORDER BY SubjectId


--17.Exam Information
 SELECT temp.Quarter, temp.SubjectName,COUNT(temp.StudentId) AS StudentsCount FROM     
	  (SELECT 
      CASE
      WHEN e.Date IS NULL THEN 'TBA'
      WHEN DATEPART(MONTH,Date) BETWEEN 1 AND 3 THEN 'Q1'
      WHEN DATEPART(MONTH,Date) BETWEEN 4 AND 6 THEN 'Q2'
      WHEN DATEPART(MONTH,Date) BETWEEN 7 AND 9 THEN 'Q3'
      WHEN DATEPART(MONTH,Date) BETWEEN 10 AND 12 THEN 'Q4'
      END AS [Quarter],
      s.[Name] AS SubjectName,
      SE.StudentId
      FROM Exams E
      JOIN StudentsExams SE ON E.Id=SE.ExamId
      JOIN Subjects S ON s.Id=e.SubjectId
      WHERE SE.Grade>=4.00) AS temp
GROUP BY temp.Quarter, temp.SubjectName
ORDER BY temp.Quarter

--18.Exam Grades
CREATE FUNCTION udf_ExamGradesToUpdate(@studentId int, @grade DECIMAL(16,2)) RETURNS  NVARCHAR(max) 
AS
BEGIN 
DECLARE @student int = (SELECT TOP(1) Id From Students 
						WHERE Id=@studentId)
IF @student IS NULL 
BEGIN
RETURN 'The student with provided id does not exist in the school!'
END
ELSE IF @grade>6.0
BEGIN 
RETURN 'Grade cannot be above 6.00!'
END
ELSE
BEGIN
DECLARE @HighestGrade DECIMAL(16,2) = @grade+0.5

DECLARE @StudentName nvarchar(20)= (SELECT FirstName FROM Students WHERE Id=@student)
DECLARE @Count int  =(SELECT COUNT(Grade) FROM StudentsExams se
					JOIN Students s ON S.Id=se.StudentId
					WHERE StudentId=@student AND se.Grade>=@grade AND se.Grade<=@HighestGrade)			
END
RETURN 		'You have to update '+ CAST(@Count AS NVARCHAR(10))+ ' grades for the student '+ @StudentName
END

--19.Exclude from School
CREATE PROCEDURE usp_ExcludeFromSchool @StudentId int
AS
DECLARE @Id int = (SELECT Id FROM Students s WHERE @StudentId=s.Id )
IF @Id IS NULL 
BEGIN
RAISERROR('This school has no student with the provided id!',15,1)
RETURN 
END


DELETE FROM StudentsExams
WHERE StudentId=@Id

DELETE FROM StudentsTeachers
WHERE StudentId=@Id

DELETE FROM StudentsSubjects
WHERE StudentId=@Id

DELETE FROM Students
WHERE Id=@Id

--20.Deleted Student
CREATE TABLE ExcludedStudents
(
StudentId INT, 
StudentName VARCHAR(30)
)


CREATE TRIGGER tr_StudentsDelete ON Students
INSTEAD OF DELETE
AS
INSERT INTO ExcludedStudents(StudentId, StudentName)
		SELECT Id, FirstName + ' ' + LastName FROM deleted

