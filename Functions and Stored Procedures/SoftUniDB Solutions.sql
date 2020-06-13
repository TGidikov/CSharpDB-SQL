--PROBLEM 01:
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 
AS
SELECT FirstName,LastName 
FROM Employees 
WHERE dbo.Employees.Salary>35000


--PROBLEM 02:
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber
(@SalaryToCompare DECIMAL(18,4))  AS
SELECT FirstName,e.LastName FROM dbo.Employees e
WHERE e.Salary>=@SalaryToCompare

--PROBLEM 03:
CREATE PROCEDURE usp_GetTownsStartingWith 
(@LetterToBeginWith nvarchar(10)) AS
SELECT [Name] AS Town FROM dbo.Towns t
WHERE Name LIKE @LetterToBeginWith + '%'

--PROBLEM 04:
CREATE PROCEDURE usp_GetEmployeesFromTown 
(@TownName nvarchar(50)) AS
SELECT e.FirstName,e.LastName FROM dbo.Employees e
JOIN dbo.Addresses a ON e.AddressID = a.AddressID
JOIN dbo.Towns t ON a.TownID = t.TownID
WHERE t.[Name] LIKE @TownName

--PROBLEM 05:
CREATE FUNCTION ufn_GetSalaryLevel
(@salary DECIMAL(18,4)) RETURNS varchar(10)
AS BEGIN
  DECLARE @SalaryInfo nvarchar(10)
    IF(@salary<30000)
		
	    SET @SalaryInfo = 'Low'
		
    ELSE IF (@salary >=30000 AND @salary <= 50000)
	   
		SET @SalaryInfo = 'Average'
		
	ELSE 
	    
		SET @SalaryInfo='High'
		
    RETURN @SalaryInfo
END;

--PROBLEM 06:
CREATE PROCEDURE usp_EmployeesBySalaryLevel 
(@SalaryLevel varchar(10)) AS
	BEGIN 
	SELECT FirstName,LastName FROM dbo.Employees e
	WHERE dbo.ufn_GetSalaryLevel(e.Salary) = @SalaryLevel
	END

--PROBLEM 07:
CREATE FUNCTION ufn_IsWordComprised
(@setOfLetters NVARCHAR(50), @word NVARCHAR(20)) 
RETURNS BIT
AS
BEGIN
	DECLARE @result BIT = 1;
	DECLARE @counter INT = 1;
	DECLARE @wordLen INT = LEN(@word);
		WHILE(@counter <= @wordLen)
		BEGIN
		DECLARE @currentLetter CHAR(1)= SUBSTRING(@word, @counter, 1);
			IF(@setOfLetters NOT LIKE '%'+@currentLetter + '%')
			BEGIN
			SET @result = 0;
			END
		SET @counter += 1;
		END

	RETURN @result;
END

 --PROBLEM 08:
 CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
    AS
        BEGIN
              DELETE EmployeesProjects
                  WHERE EmployeeID IN (SELECT e.EmployeeID
                                          FROM Employees AS e
                                              WHERE e.DepartmentID = @departmentId);
 
             UPDATE Employees
                  SET ManagerID = NULL   
                      WHERE ManagerID IN (SELECT e.EmployeeID
                                              FROM Employees AS e
                                                  WHERE e.DepartmentID = @departmentId);
 
             ALTER TABLE Departments
             ALTER COLUMN ManagerID INT;
 
             UPDATE Departments
                  SET ManagerID = NULL
                      WHERE DepartmentID = @departmentId;
 
             DELETE Employees
                  WHERE DepartmentID = @departmentId;
 
              DELETE Departments
                  WHERE DepartmentID = @departmentId;
 
                  SELECT COUNT(*)
                      FROM Employees AS e
                          WHERE e.DepartmentID = @departmentId
        END;
