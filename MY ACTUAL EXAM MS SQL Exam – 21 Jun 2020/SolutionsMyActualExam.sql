--1.Database design
CREATE TABLE Cities
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 [Name] nvarchar(20) NOT NULL,
	 CountryCode char(2) NOT NULL)

CREATE TABLE Hotels
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 [Name] nvarchar(30) NOT NULL,
	 CityId int FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
	 EmployeeCount int NOT NULL,
	 BaseRate decimal(16,2))

CREATE TABLE Rooms 
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 Price decimal(16,2) NOT NULL,
	 [Type] nvarchar(20) NOT NULL,
	 Beds int NOT NULL,
	 HotelId int FOREIGN KEY REFERENCES Hotels(Id) NOT NULL)

CREATE TABLE Trips
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 RoomId int FOREIGN KEY REFERENCES Rooms(Id) NOT NULL,
	 BookDate datetime2  NOT NULL,
	 ArrivalDate datetime2  NOT NULL,
	 ReturnDate datetime2 NOT NULL,
	 CancelDate datetime2,
	 CONSTRAINT CheckArrivateDate CHECK (ArrivalDate<ReturnDate),
	 CONSTRAINT CheckBookDate CHECK (BookDate<ArrivalDate))

CREATE TABLE Accounts 
	(Id int PRIMARY KEY IDENTITY NOT NULL,
	 FirstName nvarchar(50) NOT NULL,
	 MiddleName nvarchar(20) ,
	 LastName nvarchar(50) NOT NULL,
	 CityId int FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
	 BirthDate datetime2 NOT NULL,
	 Email varchar(100) UNIQUE NOT NULL)

CREATE TABLE AccountsTrips
	(AccountId int FOREIGN KEY REFERENCES Accounts(Id) NOT NULL,
	TripId int FOREIGN KEY REFERENCES Trips(Id) NOT NULL,
	Luggage INT CHECK(Luggage>=0) NOT NULL
	CONSTRAINT PK_AccountIdTripsId PRIMARY KEY (AccountId,TripId))

--2.Insert
INSERT INTO Accounts
(FirstName,MiddleName,LastName,CityId,BirthDate,Email)
VALUES
('John','Smith','Smith',34,'1975-07-21','j.smith@gmail.com'),
('Gosho',NULL,'Petrov',11,'1978-05-16','g_petrov@gmail.com'),
('Ivan','Petrovich','Pavlov',59,'1849-09-26','i_pavlov@softuni.bg'),
('Friedrich','Wilhelm','Nietzsche',2,'1844-10-15','f.nietzsche@softuni.bg')

INSERT INTO Trips
(RoomId,BookDate,ArrivalDate,ReturnDate,CancelDate)
VALUES
(101,'2015-04-12','2015-04-14','2015-04-20','2015-02-02'),
(102,'2015-07-07','2015-07-15','2015-07-22','2015-04-29'),
(103,'2013-07-17','2013-07-23','2013-07-24',NULL),
(104,'2012-03-17','2012-03-31','2012-04-01','2012-01-10'),
(109,'2017-08-07','2017-08-28','2017-08-29',NULL)

--03.Update
UPDATE Rooms
SET Price=Price*1.14
WHERE HotelId IN (5,7,9)


--04.Delete
DELETE FROM AccountsTrips 
WHERE AccountId=47
DELETE FROM Accounts 
WHERE Id=47

--05.EEE-Mails
SELECT FirstName,LastName,
FORMAT(BirthDate,'MM-dd-yyyy') AS Birthdate,
(c.[Name]) AS Hometown,
Email
FROM Accounts A
JOIN Cities C ON a.CityId=c.Id
WHERE Email LIKE 'e%'
ORDER BY Hometown

--06.City Statistics
SELECT c.[Name] AS City,COUNT(h.CityId) AS Hotels FROM Cities C
JOIN Hotels H ON c.Id=h.CityId
GROUP BY C.[Name] , CityId
ORDER BY Hotels DESC,City

--07.Longest and Shortest Trips
SELECT A.Id As AccountId,A.FirstName+' '+A.LastName AS [FullName],
MAX(DATEDIFF(DAY,T.ArrivalDate,T.ReturnDate))AS LongestTrip,
MIN(DATEDIFF(DAY,T.ArrivalDate,T.ReturnDate)) AS ShortestTrip
FROM Accounts A
JOIN AccountsTrips ATR ON ATR.AccountId=A.Id
JOIN Trips T ON T.Id=ATR.TripId
WHERE A.MiddleName IS NULL AND CancelDate IS NULL
GROUP BY A.FirstName,A.LastName,A.Id
ORDER BY LongestTrip DESC,ShortestTrip ASC

--08.Metropolis
SELECT TOP(10) c.Id,c.[Name] AS City,c.CountryCode AS Country, COUNT(a.CityId) Accounts FROM Accounts A
JOIN Cities C ON a.CityId=c.Id
GROUP BY c.Id ,a.CityId,CountryCode,C.[Name]
ORDER BY Accounts DESC

--09.Romantic Gateways
SELECT a.Id,Email,C.[Name] AS City,COUNT(at.TripId) AS Trips FROM Accounts A
JOIN AccountsTrips AT ON At.AccountId=a.Id
JOIN Trips T ON T.Id=AT.TripId
JOIN Rooms R ON R.Id=T.RoomId
JOIN Hotels H ON H.Id=R.HotelId
JOIN Cities C ON C.Id=h.CityId
WHERE a.CityId=h.CityId
GROUP BY A.Id,Email,C.[Name]
ORDER BY Trips DESC,a.Id

--10.GDPR Violation
SELECT t.Id,FirstName+ISNULL(' '+MiddleName,'')+' '+LastName AS [Full Name],
c.[Name] AS [From],
c2.[Name] AS [To],
CASE
WHEN CancelDate IS  NOT NULL THEN 'Canceled'
ELSE 
CAST(DATEDIFF(DAY,t.ArrivalDate,t.ReturnDate) AS nvarchar(5))+' '+'days'
END
AS Duration
FROM Trips T
JOIN AccountsTrips AT ON AT.TripId=T.Id
JOIN Accounts A ON A.Id=AT.AccountId
JOIN Cities C ON C.Id=A.CityId
JOIN Rooms R ON R.Id=T.RoomId
JOIN Hotels H ON H.Id=R.HotelId
JOIN Cities C2 ON H.CityId=C2.Id
ORDER BY [Full Name],TripId

--11.Available Room
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @hotelBaseRate DECIMAL(18,2)
    SET @hotelBaseRate = (SELECT Hotels.BaseRate FROM Hotels WHERE Hotels.Id = @HotelId)
 
    DECLARE @roomId INT
    SET @roomId = (SELECT TOP(1) tempDB.roomId
                    FROM(
                    SELECT Rooms.Id AS roomId, Price, [Type], Beds, ArrivalDate, ReturnDate, CancelDate
                    FROM Rooms
                    JOIN Hotels ON Hotels.Id = Rooms.HotelId
                    JOIN Trips ON Trips.RoomId = Rooms.Id
                    WHERE Hotels.Id = @HotelId AND Rooms.Beds >= @People ) as tempDB
                    WHERE NOT EXISTS (SELECT tempDBTwo.roomId
                     FROM(
                     SELECT RoomsTwo.Id AS roomId, Price, [Type], Beds, ArrivalDate, ReturnDate, CancelDate
                     FROM Rooms as RoomsTwo
                     JOIN Hotels AS HotelsTwo ON HotelsTwo.Id = RoomsTwo.HotelId
                     JOIN Trips AS TripsTwo ON TripsTwo.RoomId = RoomsTwo.Id
                     WHERE HotelsTwo.Id = @HotelId AND RoomsTwo.Beds >= @People ) as tempDBTwo
                     WHERE (CancelDate IS NULL AND @Date > ArrivalDate AND @Date < ReturnDate))
                    ORDER BY tempDB.Price DESC)
 
    IF(@roomId IS NULL) RETURN 'No rooms available'
 
    DECLARE @highestPrice DECIMAL(18,2)
    SET @highestPrice = (SELECT Rooms.Price FROM Rooms WHERE Rooms.Id = @roomId)
 
    DECLARE @roomType NVARCHAR(200);
    SET @roomType = (SELECT Rooms.[Type] FROM Rooms WHERE Rooms.Id = @roomId);
 
    DECLARE @roomBeds INT
    SET @roomBeds = (SELECT Rooms.Beds FROM Rooms WHERE Rooms.Id = @roomId)
 
    DECLARE @totalPrice DECIMAL(18,2)  
    SET @totalPrice = (@hotelBaseRate + @highestPrice) * @People
    RETURN FORMATMESSAGE('Room %i: %s (%i beds) - $%s', @roomId, @roomType, @roomBeds, CONVERT(NVARCHAR(100),@totalPrice))
END


--12.Switch Room
CREATE PROCEDURE usp_SwitchRoom @TripId INT, @TargetRoomId INT
AS
BEGIN
        IF( (SELECT TOP(1) h.Id FROM Trips AS t
            JOIN Rooms AS r ON r.Id = t.RoomId
            JOIN HOTELS AS h ON h.Id = r.HotelId
            WHERE t.Id = @TripId) !=
            (SELECT HotelId FROM Rooms WHERE @TargetRoomId = Id))
            begin
                SELECT 'Target room is in another hotel!'
                return
            end
 
        IF( (SELECT Beds FROM Rooms WHERE @TargetRoomId = Id) <
            (SELECT COUNT(*) FROM AccountsTrips WHERE TripId = @TripId))
            BEGIN
                SELECT 'Not enough beds in target room!'
                return
            END
 
        UPDATE Trips
            SET RoomId = @TargetRoomId
            WHERE Id = @TripId
END
