--PROBLEM 09:
CREATE PROCEDURE usp_GetHoldersFullName AS
SELECT (FirstName+' '+LastName) AS [Full Name]  FROM AccountHolders

--PROBLEM 10:
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan 
(@CompareMoney money ) AS
SELECT ah.FirstName , ah.LastName FROM dbo.AccountHolders ah
JOIN dbo.Accounts a ON ah.Id = a.AccountHolderId
GROUP BY ah.FirstName ,ah.LastName
HAVING @CompareMoney <SUM(a.Balance)
ORDER BY ah.FirstName , ah.LastName

--PROBLEM 11:
CREATE FUNCTION ufn_CalculateFutureValue
(@sum decimal(18,4),@rate float, @years int)
RETURNS decimal(18,4) AS
BEGIN 
	DECLARE @result decimal(18,4)
	SET @result = @sum*(POWER((1+@rate),@years))
	RETURN @result
END

--PROBLEM 12:
CREATE PROCEDURE usp_CalculateFutureValueForAccount 
(@AccountId int,@rate float) AS
BEGIN
SELECT TOP (1)
	ah.Id,
	FirstName,
	LastName,
	a.Balance AS [Current Balance],
	dbo.ufn_CalculateFutureValue(a.Balance,@rate,5) AS [Balance in 5 Years]
	FROM dbo.AccountHolders ah
JOIN dbo.Accounts a ON ah.Id = a.AccountHolderId
END


