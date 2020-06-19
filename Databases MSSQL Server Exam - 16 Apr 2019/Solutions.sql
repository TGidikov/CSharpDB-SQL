--1.Database Design
CREATE TABLE Planes 
(Id int PRIMARY KEY IDENTITY,
 [Name] nvarchar(30) NOT NULL,
 Seats int NOT NULL,
 [Range] int NOT NULL)

 
 CREATE TABLE Flights
 (Id int PRIMARY KEY IDENTITY,
  DepartureTime datetime,
  ArrivalTime datetime,
  Origin nvarchar(50) NOT NULL,
  Destination nvarchar(50) NOT NULL,
  PlaneId int FOREIGN KEY REFERENCES dbo.Planes(Id) NOT NULL)

  CREATE TABLE Passengers 
  (Id int PRIMARY KEY IDENTITY,
  FirstName nvarchar(30) NOT NULL,
  LastName nvarchar(30) NOT NULL,
  Age int NOT NULL,
  [Address] nvarchar(30) NOT NULL,
  PassportId char(11) NOT NULL)
  
  CREATE TABLE LuggageTypes
  (Id int PRIMARY KEY IDENTITY,
  [Type] nvarchar(30) NOT NULL)
 
 CREATE TABLE Luggages
 (Id int PRIMARY KEY IDENTITY,
 LuggageTypeId int FOREIGN KEY REFERENCES dbo.LuggageTypes(Id) NOT NULL,
 PassengerId int FOREIGN KEY REFERENCES dbo.Passengers(Id) NOT NULL,)

 CREATE TABLE Tickets
 (Id int PRIMARY KEY IDENTITY,
  PassengerId int FOREIGN KEY REFERENCES dbo.Passengers(Id) NOT NULL,
  FlightId int FOREIGN KEY REFERENCES dbo.Flights(Id) NOT NULL,
  LuggageId int FOREIGN KEY REFERENCES dbo.Luggages(Id) NOT NULL,
  Price decimal(10,2) NOT NULL)
  
--2.Insert
INSERT INTO dbo.Planes
	([Name], Seats, [Range])
VALUES
	('Airbus 336',112,5132),
	('Airbus 330',432,5325),
	('Boeing 369',231,2355),
	('Stelt 297',254,2143),
	('Boeing 338',165,5111),
	('Airbus 558',387,1342),
	('Boeing 128',345,5541)

INSERT INTO dbo.LuggageTypes
	([Type])
VALUES
	('Crossbody Bag'),
	('School Backpack'),
	('Shoulder Bag')

--3.Update
UPDATE dbo.Tickets
SET    
    dbo.Tickets.Price = dbo.Tickets.Price*1.13
	WHERE dbo.Tickets.FlightId=(SELECT f.Id FROM dbo.Flights f 
								WHERE f.Destination ='Carlsbad')


--4.Delete
DELETE FROM dbo.Tickets
WHERE dbo.Tickets.FlightId=(SELECT Id FROM dbo.Flights f
		  WHERE f.Destination = 'Ayn Halagim')

DELETE FROM dbo.Flights
WHERE Destination = 'Ayn Halagim'

--5.Trips
SELECT f.Origin,f.Destination FROM dbo.Flights f
ORDER BY f.Origin,Destination

--6.The "Tr" Planes
SELECT * FROM Planes
WHERE dbo.Planes.[Name] LIKE '%Tr%'
ORDER BY Id,[Name],Seats,[Range]

--7.Flight Profits
SELECT t.FlightId,SUM(Price) AS Price FROM dbo.Tickets t
GROUP BY FlightId
ORDER BY SUM(Price) DESC , t.FlightId

--8.Passengers and Prices
SELECT TOP(10) FirstName,LastName ,dbo.Tickets.Price FROM Passengers
JOIN Tickets ON dbo.Passengers.Id = dbo.Tickets.PassengerId
ORDER BY dbo.Tickets.Price DESC,dbo.Passengers.FirstName,dbo.Passengers.LastName

--9.Most Used Luggage's
SELECT Lt.[Type],
COUNT(LuggageTypeId) AS MostUsedLuggage
FROM Luggages s 
JOIN LuggageTypes LT ON LT.Id = s.LuggageTypeId
GROUP BY  LT.[Type] 
ORDER BY COUNT(LuggageTypeId) DESC, [Type]

--10.Passenger Trips
SELECT
(FirstName+' '+LastName) AS [Full Name],
Origin,
Destination
FROM Flights f
JOIN Tickets t ON t.FlightId=f.Id
JOIN Passengers p ON p.Id= t.PassengerId
ORDER BY [Full Name],Origin,Destination

--11.Non Adventures People
SELECT FirstName,LastName,Age FROM Passengers p
LEFT JOIN Tickets t ON p.Id=t.PassengerId
WHERE PassengerId IS NULL
ORDER BY AGE DESC ,FirstName,LastName

--12.Lost Luggage's
SELECT PassportId,[Address] FROM Passengers p
LEFT JOIN Luggages l ON p.Id=l.PassengerId
WHERE LuggageTypeId IS NULL
ORDER BY PassportId,[Address]

--13.Count of Trips
SELECT FirstName,LastName,
COUNT(t.PassengerId) AS [Total Trips]  FROM Passengers p
LEFT JOIN Tickets t ON p.Id= t.PassengerId
GROUP BY FirstName,LastName
ORDER BY [Total Trips] DESC ,FirstName,LastName

--14.Full Info
SELECT (p.FirstName+' '+p.LastName) AS [Full Name],
		pl.[Name] AS [Plane Name],
		f.Origin+' - '+f.Destination AS Trip,
		LT.[Type] AS [Luggage Type]
  FROM Passengers p
JOIN Tickets t ON p.Id= t.PassengerId
JOIN Flights f ON f.Id=t.FlightId
JOIN Planes pl ON f.PlaneId=pl.Id
JOIN Luggages l ON t.LuggageId=l.Id
JOIN LuggageTypes LT ON l.LuggageTypeId=LT.Id
ORDER BY [Full Name],[Name],Origin,Destination,[Luggage Type]

--15.Most Expensive Trips 
SELECT r.FirstName,r.LastName,r.Destination,r.Price 
FROM(SELECT FirstName,LastName,
     Destination,
     t.Price AS Price,
     DENSE_RANK () OVER (Partition by p.FirstName,p.LastName ORDER BY t.Price DESC) AS [Price Rank]
     FROM Passengers p
     JOIN Tickets t ON p.Id=t.PassengerId
     JOIN Flights f ON f.Id=t.FlightId) as R
WHERE [Price Rank]=1
ORDER BY r.Price DESC,r.FirstName,r.LastName,r.Destination

--16.Destinations Info
SELECT Destination,COUNT(t.FlightId) AS FilesCount FROM Flights f
LEFT JOIN Tickets t ON f.Id=t.FlightId
GROUP BY Destination
ORDER BY FilesCount DESC , Destination

--17.PSP
SELECT pl.[Name],pl.Seats,
COUNT(t.PassengerId) AS PassangersCount FROM Planes pl
LEFT JOIN Flights f ON pl.Id=f.PlaneId
LEFT JOIN Tickets t ON f.Id=t.FlightId
LEFT JOIN Passengers pa ON t.PassengerId=pa.Id
GROUP BY pl.[Name],pl.Seats
ORDER BY PassangersCount DESC,pl.[Name],pl.Seats

--18.Vocation
CREATE FUNCTION udf_CalculateTickets(@origin nvarchar(50), @destination nvarchar(50), @peopleCount int)
RETURNS VARCHAR(100)
AS
BEGIN 
 IF(@peopleCount <=0)
 BEGIN
 RETURN 'Invalid people count!'
 END
 
 DECLARE @TripID INT = (SELECT Id FROM Flights f 
						WHERE Destination=@destination AND Origin=@origin)
IF @TripID IS NULL
BEGIN
RETURN 'Invalid flight!'
END
DECLARE @TicketPrice DECIMAL(16,2)=(SELECT t.Price FROM Tickets t
									JOIN Flights f ON t.FlightId=f.Id
									WHERE Destination=@destination AND Origin = @origin)
DECLARE @TotalPrice DECIMAL (16,2)= @TicketPrice* @peopleCount

RETURN 'Total price ' +CAST(@TotalPrice AS nvarchar(30))
END

--19.Wrong Data
CREATE PROCEDURE usp_CancelFlights
AS
UPDATE Flights 
SET DepartureTime=NULL,ArrivalTime=NULL
WHERE ArrivalTime>DepartureTime

--20.Deleted Planes 
CREATE TABLE DeletedPlanes
		(Id Int,
		[Name] nvarchar(50),
		Seats int,
		[Range] int)

CREATE TRIGGER tr_DeletedPlanes ON Planes
AFTER DELETE AS
INSERT INTO DeletedPlanes(Id,[Name],Seats,[Range])
		(SELECT Id,[Name],Seats,[Range]FROM deleted)