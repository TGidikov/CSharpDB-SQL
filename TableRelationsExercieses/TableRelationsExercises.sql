--PROBLEM 01:
CREATE TABLE Passports(
	PassportID int  PRIMARY KEY ,
	PassortNumber char(8) NOT NULL
	)

CREATE TABLE Persons(
	PersonID int PRIMARY KEY,
	FirstName nvarchar(30) NOT NULL,
	Salary decimal(16,2) NOT NULL,
	PassportID int NOT NULL FOREIGN KEY REFERENCES dbo.Passports(PassportID) UNIQUE)
	
INSERT INTO dbo.Passports
(
    PassportID,
    PassortNumber
)
VALUES
	( 101, 'N34FG21B' ),
	( 102, 'K65LO4R7' ),
	( 103, 'ZE657QP2' )

INSERT INTO  dbo.Persons
(
    PersonID,
    [FirstName],
    Salary,
    PassportID
)
VALUES
( 1 ,'Roberto',43300,102),
( 2 ,'Tom',56100,103),
( 3 ,'Yana',60200,101)

--PROBLEM 02:
CREATE TABLE Manufacturers
	(ManufacturerID int PRIMARY KEY NOT NULL,
	[Name] nvarchar(20)NOT NULL,
	EstabilishedOn date NOT NULL)

CREATE TABLE Models
	(ModelID int PRIMARY KEY IDENTITY(100,1) NOT NULL,
	 [Name] nvarchar(50) NOT NULL,
	 ManufacturerID int FOREIGN KEY REFERENCES dbo.Manufacturers(ManufacturerID))

INSERT INTO dbo.Manufacturers
(
    ManufacturerID,
    [Name],
    EstabilishedON
)
VALUES
(1,'BMW','1916-03-07'),
(2,'Tesla','2003-01-01'),
(3,'Lada','1966-05-01')


INSERT INTO Models
	([Name],dbo.Models.ManufacturerID)
VALUES 
	('X1',1),
	('i6',1),
	('Model S',2),
	('Model X',2),
	('Model 3',2),
	('Nova',3)

--PROBLEM 03:

CREATE TABLE Students
	(StudentID int NOT NULL PRIMARY KEY IDENTITY,
	 [Name] nvarchar(50) NOT NULL)

CREATE TABLE Exams
	(ExamID int NOT NULL PRIMARY KEY IDENTITY(101,1),
	 [Name] nvarchar(50) NOT NULL)

Create TABLE StudentsExams
	(StudentID int NOT NULL FOREIGN KEY REFERENCES dbo.Students(StudentID),
	 ExamID int NOT NULL FOREIGN KEY REFERENCES dbo.Exams(ExamID),
	 CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentID,ExamID))

INSERT INTO dbo.Students
	([Name])
VALUES
	('Mila'),
	('Toni'),
	('Ron')
 
INSERT INTO dbo.Exams
	([Name])
VALUES
	('SpringMVC'),
	('Neo4j'),
	('Oracle 11g')

INSERT INTO StudentsExams
	(StudentID,ExamID)
VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103)

--PROBLEM 4:
CREATE TABLE Teachers
	(TeacherID int NOT NULL PRIMARY KEY IDENTITY (101,1),
	[Name] nvarchar(50) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID) NULL)

INSERT INTO Teachers([Name],ManagerID)
    VALUES
        ('John', NULL),
        ('Maya' , 106),
        ('Silvia' , 106),
        ('Ted' , 105),
        ('Mark' , 101),
        ('Greta' , 101);

--PROBLEM 05:
CREATE DATABASE  OnlineStoreDatabase
USE OnlineStoreDatabase

CREATE TABLE Cities
	(CityID int PRIMARY KEY IDENTITY NOT NULL,
	[Name] varchar(50) NOT NULL)

CREATE TABLE Customers 
	(CustomerID int PRIMARY KEY IDENTITY NOT NULL,
	 [Name] varchar(50) NOT NULL,
	 Birthday date ,
	 CityID int FOREIGN KEY REFERENCES dbo.Cities(CityID))

CREATE TABLE Orders
	( OrderID int PRIMARY KEY IDENTITY NOT NULL,
	 CustomerID int FOREIGN KEY REFERENCES dbo.Customers(CustomerID))

CREATE TABLE ItemTypes
	(ItemTypeID int PRIMARY KEY  IDENTITY NOT Null,
	[Name] varchar(50) NOT NULL)

CREATE TABLE Items
	(ItemID int PRIMARY KEY IDENTITY NOT NUll,
	[Name] varchar(50) NOT NULL,
	ItemTypeID int FOREIGN KEY REFERENCES dbo.ItemTypes(ItemTypeID))

CREATE TABLE OrderItems
	(OrderID int FOREIGN KEY REFERENCES dbo.Orders(OrderID),
	ItemID int FOREIGN KEY REFERENCES dbo.Items(ItemID),
	CONSTRAINT PK_KEY_OrderID_ItemID PRIMARY KEY (OrderID,ItemID))

--Problem 06:
CREATE DATABASE UniversityDatabase
USE UniversityDatabase

CREATE TABLE Subjects
	(SubjectID int PRIMARY KEY IDENTITY NOT NUll,
	SubjectName varchar(50))

CREATE TABLE Majors
	(MajorID int PRIMARY KEY IDENTITY NOT NULL,
	[Name] varchar(50))


CREATE TABLE Students
	(StudentID int PRIMARY KEY IDENTITY NOT NULL,
	StudentNumber varchar(20) NOT NULL,
	StudentName varchar(50) NOT NULL,
	MajorID int FOREIGN KEY REFERENCES dbo.Majors(MajorID))



CREATE TABLE Agenda
	(StudentID int FOREIGN KEY REFERENCES dbo.Students(StudentID),
	SubjectID int FOREIGN KEY REFERENCES dbo.Subjects(SubjectID),
	CONSTRAINT PK_Key_StudentID_SubjectID PRIMARY KEY (StudentID,SubjectID))

CREATE TABLE Payments
	(PaymentID int PRIMARY KEY IDENTITY NOT NULL,
	PaymentDate date NOT NULL,
	PaymentAmount decimal (16,2) NOT NULL,
	StudentID int FOREIGN KEY REFERENCES dbo.Students(StudentID))

--Problem07:

SELECT  MountainRange , PeakName, Elevation FROM Peaks
JOIN dbo.Mountains ON dbo.Peaks.MountainId = dbo.Mountains.Id
WHERE MountainRange ='Rila'
ORDER BY Elevation  DESC

