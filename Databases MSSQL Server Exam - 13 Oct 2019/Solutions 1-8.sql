--1.Database Design
CREATE TABLE Users
	(Id int PRIMARY KEY IDENTITY,
	Username nvarchar(30) NOT NULL,
	[Password] nvarchar(30) NOT NULL,
	Email nvarchar(50) NOT NULL)

CREATE TABLE Repositories 
	(Id int PRIMARY KEY IDENTITY ,
	 [Name] nvarchar(50) NOT NULL)

CREATE TABLE RepositoriesContributors
	(RepositoryId int  FOREIGN KEY REFERENCES dbo.Repositories(Id) NOT NULL,
	 ContributorId int  FOREIGN KEY REFERENCES dbo.Users(Id) NOT NULL,
	 CONSTRAINT PK_RepositoryContributorPK PRIMARY KEY (RepositoryId ,ContributorId ))


CREATE TABLE Issues
	(Id int PRIMARY KEY IDENTITY ,
	 Title nvarchar(255) NOT NULL,
	 IssueStatus nvarchar(6) NOT NULL,
	 RepositoryId int FOREIGN KEY REFERENCES dbo.Repositories(Id) NOT NULL,
	 AssigneeId int FOREIGN KEY REFERENCES dbo.Users(Id) NOT NULL)
	
CREATE TABLE Commits
	(Id int PRIMARY KEY IDENTITY,
	 [Message] nvarchar(255) NOT NULL,
	 IssueId int FOREIGN KEY REFERENCES dbo.Issues(Id) ,
	 RepositoryId int FOREIGN KEY REFERENCES dbo.Repositories(Id) NOT NULL,
	 ContributorId int FOREIGN KEY  REFERENCES dbo.Users(Id) NOT NULL)

CREATE TABLE Files 
	(Id int PRIMARY KEY IDENTITY,
	[Name] nvarchar(100) NOT NULL,
	Size decimal(10,2) NOT NULL,
	ParentId int FOREIGN KEY REFERENCES Files(Id) ,
	CommitId int FOREIGN KEY REFERENCES dbo.Commits(Id) NOT NULL)

--2.Insert
INSERT INTO dbo.Files
    ([Name], Size, ParentId, CommitId)
VALUES
('Trade.idk',2598.0,1,1),
('menu.net',9238.31,2,2),
('Administrate.soshy',1246.93,3,3),
('Controller.php',7353.15,4,4),
('Find.java',9957.86,5,5),
('Controller.json',14034.87,3,6),
('Operate.xix',7662.92,7,7)

INSERT INTO dbo.Issues
	(Title, IssueStatus, RepositoryId, AssigneeId)
VALUES
	('Critical Problem with HomeController.cs file','open',1,4),
	('Typo fix in Judge.html','open',4,3),
	('Implement documentation for UsersService.cs','closed',8,2),
	('Unreachable code in Index.cs','open',9,8)
	
--3.Update
UPDATE dbo.Issues
SET dbo.Issues.IssueStatus = 'closed'
WHERE AssigneeId = 6

--4.Delete
DELETE FROM Issues
WHERE RepositoryId IN (SELECT r.Id
                            FROM Repositories AS r
                            WHERE r.[Name] = 'Softuni-Teamwork')
 
DELETE FROM RepositoriesContributors
WHERE RepositoryId IN (SELECT r.Id
                            FROM Repositories AS r
                            WHERE r.[Name] = 'Softuni-Teamwork')

--5.Commits
SELECT Id,[Message],RepositoryId,ContributorId FROM Commits
ORDER BY Id,[Message],RepositoryId,ContributorId

--6.Heavy HTML
SELECT dbo.Files.Id,[Name],Size FROM Files
WHERE dbo.Files.Size>1000 AND [Name] LIKE '%html%'
ORDER BY Size DESC ,[Name]

--7.Issues and Users
SELECT i.Id ,
(u.Username +' : '+i.Title) AS IssueAssignee 
FROM dbo.Issues i
JOIN dbo.Users u ON i.AssigneeId=u.Id
ORDER BY i.Id DESC ,i.AssigneeId

--8.Non-Directory Files
SELECT f.Id,f.[Name], CONCAT(f.Size,'KB') AS Size FROM dbo.Files f
LEFT JOIN Files FA ON f.Id = FA.ParentId
WHERE FA.Id IS NULL
ORDER BY Id,[Name] ,Size DESC



