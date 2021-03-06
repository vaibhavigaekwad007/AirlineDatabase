
USE "GROUP9_INFO6210";

---- create table ----

CREATE SCHEMA Passenger;
CREATE SCHEMA Flight;
CREATE SCHEMA Aircraft;
CREATE SCHEMA Crew;
CREATE SCHEMA Cost;

CREATE TABLE Passenger.passenger (
	psg_id INT NOT NULL,
	psg_type INT NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	middle_name VARCHAR(45) NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	gender INT NOT NULL,
	phone_no INT NOT NULL,
	email VARCHAR(45) NOT NULL,
	birthday DATE NOT NULL,
		CONSTRAINT PKPassenger PRIMARY KEY CLUSTERED (psg_id, psg_type)
);

-- add comments to the column
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Identification card/ passport', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'psg_id';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Domestic = 0/ international = 1', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'psg_type';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Male = 1 / female = 0', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'gender';

CREATE TABLE Passenger.ticket (
	ticket_no INT NOT NULL PRIMARY KEY,
	psg_id INT NOT NULL,
	psg_type INT NOT NULL,
	ticket_type INT NOT NULL,
	ticket_price Money NOT NULL,
	baggage_price Money NOT NULL,
		CONSTRAINT FKTicket FOREIGN KEY (psg_id, psg_type) REFERENCES Passenger.passenger(psg_id, psg_type)
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Domestic = 0/ international = 1', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'ticket', @level2type = N'COLUMN',
@level2name = N'psg_type';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'economy = 0 / business = 1 / first class = 2', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'ticket', @level2type = N'COLUMN',
@level2name = N'ticket_type';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The additional baggage price', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'ticket', @level2type = N'COLUMN',
@level2name = N'baggage_price';

CREATE TABLE Flight.airport (
	airport_code INT NOT NULL PRIMARY KEY,
	airport_name VARCHAR(45) NOT NULL
);

CREATE TABLE Flight.route (
	route_id INT NOT NULL PRIMARY KEY,
	departure INT NOT NULL
		REFERENCES Flight.airport(airport_code),
	destination INT NOT NULL
		REFERENCES Flight.airport(airport_code),
	distance FLOAT NOT NULL
)

CREATE TABLE Flight.flight (
	flight_no INT NOT NULL PRIMARY KEY
)

CREATE TABLE Flight.flight_legs (
	flight_no INT NOT NULL
		REFERENCES Flight.flight(flight_no),
	leg_no INT NOT NULL,
	dep_time TIME NOT NULL,
	route_id INT NOT NULL
		REFERENCES Flight.route(route_id),
	arr_time TIME NOT NULL,
		CONSTRAINT PKFlightLegs PRIMARY KEY CLUSTERED (flight_no, leg_no)
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The planned departure time', @level0type = N'SCHEMA',
@level0name = N'Flight', @level1type = N'TABLE',
@level1name = N'flight_legs', @level2type = N'COLUMN',
@level2name = N'dep_time';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The planned arrival time', @level0type = N'SCHEMA',
@level0name = N'Flight', @level1type = N'TABLE',
@level1name = N'flight_legs', @level2type = N'COLUMN',
@level2name = N'arr_time';

CREATE TABLE Aircraft.aircraft_model (
	aircraft_model_id INT NOT NULL PRIMARY KEY,
	first_seats INT NOT NULL,
	business_seats INT NOT NULL,
	economy_seats INT NOT NULL
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The sum number of the first seats', @level0type = N'SCHEMA',
@level0name = N'Aircraft', @level1type = N'TABLE',
@level1name = N'aircraft_model', @level2type = N'COLUMN',
@level2name = N'first_seats';

CREATE TABLE Aircraft.aircraft (
	aircraft_id INT NOT NULL PRIMARY KEY,
	aircraft_model_id INT NOT NULL
		REFERENCES Aircraft.aircraft_model(aircraft_model_id),
	aircraft_year INT NOT NULL
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The year aircraft start to be used', @level0type = N'SCHEMA',
@level0name = N'Aircraft', @level1type = N'TABLE',
@level1name = N'aircraft', @level2type = N'COLUMN',
@level2name = N'aircraft_year';

CREATE TABLE Flight.leg_instance (
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
	dep_time DATETIME NOT NULL,
	arr_time DATETIME,
	aircraft_id INT NOT NULL
		REFERENCES Aircraft.aircraft(aircraft_id),
		CONSTRAINT PKLegInstance PRIMARY KEY CLUSTERED (flight_no, leg_no, date_of_travel),
		CONSTRAINT FKLegInstance FOREIGN KEY (flight_no, leg_no) REFERENCES Flight.flight_legs(flight_no, leg_no)
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The actual departure time', @level0type = N'SCHEMA',
@level0name = N'Flight', @level1type = N'TABLE',
@level1name = N'leg_instance', @level2type = N'COLUMN',
@level2name = N'dep_time';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The actual arrival time', @level0type = N'SCHEMA',
@level0name = N'Flight', @level1type = N'TABLE',
@level1name = N'leg_instance', @level2type = N'COLUMN',
@level2name = N'arr_time';

CREATE TABLE Flight.seat (
	seat_no INT NOT NULL,
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
		CONSTRAINT PKSeat PRIMARY KEY CLUSTERED (seat_no, flight_no, leg_no, date_of_travel),
		CONSTRAINT FKSeat FOREIGN KEY (flight_no, leg_no, date_of_travel) REFERENCES Flight.leg_instance(flight_no, leg_no, date_of_travel)
);


CREATE TABLE Passenger.reservation (
	rev_id INT NOT NULL PRIMARY KEY,
	ticket_no INT NOT NULL
		REFERENCES Passenger.ticket(ticket_no),
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
	seat_no INT NOT NULL,
		CONSTRAINT FKReservation FOREIGN KEY (seat_no, flight_no, leg_no, date_of_travel) REFERENCES Flight.seat(seat_no, flight_no, leg_no, date_of_travel)
);

CREATE TABLE Cost.ground_cost (
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
	wearing Money NOT NULL,
	maintenance Money NOT NULL,
	airport_usage_fee Money NOT NULL,
		CONSTRAINT PKGroundCost PRIMARY KEY CLUSTERED (flight_no, leg_no, date_of_travel),
		CONSTRAINT FKGroundCost FOREIGN KEY (flight_no, leg_no, date_of_travel) REFERENCES Flight.leg_instance(flight_no, leg_no, date_of_travel)
);

CREATE TABLE Cost.flight_cost (
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	fuel Money NOT NULL,
	food Money NOT NULL,
		CONSTRAINT PKFlightCost PRIMARY KEY CLUSTERED (flight_no, leg_no),
		CONSTRAINT FKFlightCost FOREIGN KEY (flight_no, leg_no) REFERENCES Flight.flight_legs(flight_no, leg_no)
);

CREATE TABLE Crew.job (
	job_id INT NOT NULL PRIMARY KEY,
	job_name VARCHAR(45) NOT NULL,
	salary Money NOT NULL
);

CREATE TABLE Crew.staff (
	staff_id INT NOT NULL PRIMARY KEY,
	job_id INT NOT NULL
		REFERENCES Crew.job(job_id),
	last_name VARCHAR(45) NOT NULL,
	middle_name VARCHAR(45) NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	gender INT NOT NULL,
	phone_no INT NOT NULL,
	email VARCHAR(45) NOT NULL,
	birthday DATE NOT NULL
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Male = 1 / female = 0', @level0type = N'SCHEMA',
@level0name = N'Crew', @level1type = N'TABLE',
@level1name = N'staff', @level2type = N'COLUMN',
@level2name = N'gender';

CREATE TABLE Crew.crew (
	crew_id INT NOT NULL
		REFERENCES Crew.staff(staff_id),
	flight_no INT NOT NULL
		REFERENCES Flight.flight(flight_no),
	date_of_travel DATE NOT NULL,
		CONSTRAINT PKCrew PRIMARY KEY CLUSTERED (crew_id, flight_no, date_of_travel)
);

/*
 * change the data type of route_id from INT to VARCHAR
*/
ALTER TABLE Flight.flight_legs  
DROP CONSTRAINT FK__flight_le__route__2180FB33; 

ALTER TABLE Flight.route  
DROP CONSTRAINT PK__route__28F706FE40D56F69; 

ALTER TABLE Flight.route 
ALTER COLUMN route_id VARCHAR(10) NOT NULL; 

ALTER TABLE Flight.route ADD PRIMARY KEY (route_id);

ALTER TABLE Flight.flight_legs 
ALTER COLUMN route_id VARCHAR(10) NOT NULL; 

ALTER TABLE Flight.flight_legs ADD FOREIGN KEY (route_id) REFERENCES Flight.route(route_id);

/*
 * change the data type of airport_code from INT to VARCHAR
*/
ALTER TABLE Flight.route  
DROP CONSTRAINT FK__route__departure__1332DBDC, FK__route__destinati__14270015; 

ALTER TABLE Flight.airport  
DROP CONSTRAINT PK__airport__E949ADC6C466BD05; 

ALTER TABLE Flight.airport 
ALTER COLUMN airport_code VARCHAR(10) NOT NULL; 

ALTER TABLE Flight.airport ADD PRIMARY KEY (airport_code);

ALTER TABLE Flight.route 
ALTER COLUMN departure VARCHAR(10) NOT NULL; 

ALTER TABLE Flight.route 
ALTER COLUMN destination VARCHAR(10) NOT NULL;

ALTER TABLE Flight.route ADD FOREIGN KEY (departure) REFERENCES Flight.airport(airport_code);

ALTER TABLE Flight.route ADD FOREIGN KEY (destination) REFERENCES Flight.airport(airport_code);


/*
 * Insert data to Flight Section
*/

-- insert data to airpot entity
INSERT INTO Flight.airport VALUES ('BOS', 'Boston'),
	('PEK', 'Beijing'),('TXL', 'Berlin'),('SEA', 'Seattle'),
	('YYZ', 'Toronto'),('SJC', 'San Jose'),('BRU', 'Brussels'),
	('ORD', 'Chicago'),('SVO', 'Moscow'),('SHA', 'Shanghai'),
	('LED', 'St. Petersburg');


-- create stored procedure to insert data into route entity
CREATE PROCEDURE addRoute
(@departure VARCHAR(10), @destination VARCHAR(10), @distance FLOAT, @depName VARCHAR(10) = '', @desName VARCHAR(10) = '')
AS
BEGIN
	DECLARE @routeId VARCHAR(10) = '';
	SELECT @routeId = route_id FROM Flight.route WHERE route_id = CONCAT(@departure, @destination);
	IF @routeId <> ''
		PRINT 'Unable to insert data because the route_id has already existed!'
	ELSE 
		BEGIN
			DECLARE @dep VARCHAR(10) = '';
			DECLARE @des VARCHAR(10) = '';
			SELECT @dep = airport_code FROM Flight.airport WHERE airport_code = @departure;
			SELECT @des = airport_code FROM Flight.airport WHERE airport_code = @destination;
			IF @dep <> '' AND @des <> ''
				BEGIN
					INSERT INTO Flight.route (route_id, departure, destination, distance)
						VALUES(CONCAT(@departure, @destination), @departure, @destination, @distance);
					INSERT INTO Flight.route (route_id, departure, destination, distance)
						VALUES(CONCAT(@destination, @departure), @destination, @departure, @distance);
					PRINT 'SUCCESFUL INSERT DATA INTO Flight.route!';
				END
			ELSE
				IF @dep = ''
					IF @depName = ''
						PRINT 'Add parameter @depName to this procedure';
					ELSE
						BEGIN
							INSERT INTO Flight.airport VALUES (@departure, @depName);
							PRINT 'Insert new data into airport table successfully!';
							INSERT INTO Flight.route (route_id, departure, destination, distance)
								VALUES(CONCAT(@departure, @destination), @departure, @destination, @distance);
							INSERT INTO Flight.route (route_id, departure, destination, distance)
								VALUES(CONCAT(@destination, @departure), @destination, @departure, @distance);
							PRINT 'SUCCESFUL INSERT DATA INTO Flight.route!';
						END
						
				IF @des = ''
					IF @desName = ''
						PRINT 'Add parameter @desName to this procedure';
					ELSE
						BEGIN
							INSERT INTO Flight.airport VALUES (@destination, @desName);
							PRINT 'Insert new data into airport table successfully!';
							INSERT INTO Flight.route (route_id, departure, destination, distance)
								VALUES(CONCAT(@departure, @destination), @departure, @destination, @distance);
							INSERT INTO Flight.route (route_id, departure, destination, distance)
								VALUES(CONCAT(@destination, @departure), @destination, @departure, @distance);
							PRINT 'SUCCESFUL INSERT DATA INTO Flight.route!';
						END
		END
END

EXEC addRoute 'BOS', 'PEK', 6737;
EXEC addRoute 'TXL', 'PEK', 4582;
EXEC addRoute 'SEA', 'SHA', 5407;
EXEC addRoute 'BRU', 'PEK', 4951;
EXEC addRoute 'ORD', 'PEK', 6590;
EXEC addRoute 'SVO', 'PEK', 3610;
EXEC addRoute 'BOS', 'SHA', 4263;
EXEC addRoute 'LED', 'PEK', 3774;
EXEC addRoute 'YYZ', 'PEK', 6578;
EXEC addRoute 'SJC', 'PEK', 8739;
EXEC addRoute 'PEK', 'CAN', 1165;
EXEC addRoute 'PEK', 'CAN', 1165, @desName = 'Guangzhou';

/* DROP PROC addRoute; */



-- insert data to flight entity and flight_legs entity automatically
CREATE PROCEDURE addFlightAndLegs
(@flight_no INT ,@dep_time TIME, @departure VARCHAR(10), 
@arrival VARCHAR(10), @duration1 FLOAT, @stop VARCHAR(10) = '',
@duration2 FLOAT = 0, @stopHour FLOAT = 0)
AS
BEGIN
	DECLARE @flightNo INT = 0;
	SELECT @flightNo = flight_no FROM Flight.flight WHERE flight_no = @flight_no;
	IF @flightNo = 0
		BEGIN
			INSERT INTO Flight.flight VALUES (@flight_no), (@flight_no + 1);
			PRINT 'INSERT flight_no to flight table successfully!';
			IF @stop <> ''
				BEGIN
					DECLARE @Minutes1 INT; 
					SELECT @Minutes1 = CONVERT(INT, Floor(@duration1)* 60)
						+ CONVERT(INT, (@duration1 - Floor(@duration1)) * 60);
						
					DECLARE @Minutes2 INT; 
					SELECT @Minutes2 = CONVERT(INT, Floor(@duration2)* 60)
						+ CONVERT(INT, (@duration1 - Floor(@duration2)) * 60);
       
					DECLARE @depart_time1 TIME;
					SET @depart_time1 = @dep_time;
					DECLARE @arrival_time1 TIME;
					SET @arrival_time1 = DATEADD(minute, @Minutes1, @depart_time1);
				
					DECLARE @depart_time2 TIME;
					SET @depart_time2 = DATEADD(hour, @stopHour, @arrival_time1);
					DECLARE @arrival_time2 TIME;
					SET @arrival_time2 = DATEADD(minute, @Minutes2, @depart_time2);
				
					INSERT INTO Flight.flight_legs VALUES 
						(@flight_no, 1, @depart_time1, CONCAT(@departure, @stop), @arrival_time1),
						(@flight_no, 2, @depart_time2, CONCAT(@stop, @arrival), @arrival_time2),
						(@flight_no, 3, @depart_time1, CONCAT(@departure, @arrival), @arrival_time2);
					
					INSERT INTO Flight.flight_legs VALUES 
						(@flight_no + 1, 1, @depart_time1, CONCAT(@arrival, @stop), @arrival_time1),
						(@flight_no + 1, 2, @depart_time2, CONCAT(@stop, @departure), @arrival_time2),
						(@flight_no + 1, 3, @depart_time1, CONCAT(@arrival, @departure), @arrival_time2);
					
					PRINT 'INSERT 3 flight legs for each flight successfully!';
				END
			ELSE
				BEGIN
					DECLARE @Minutes3 INT; 
					SELECT @Minutes3 = CONVERT(INT, Floor(@duration1)* 60)
						+ CONVERT(INT, (@duration1 - Floor(@duration1)) * 60);
					
					INSERT INTO Flight.flight_legs VALUES
						(@flight_no, 1, @dep_time, CONCAT(@departure,@arrival), DATEADD(minute, @Minutes3, @dep_time)),
						(@flight_no + 1, 1, @dep_time, CONCAT(@arrival,@departure), DATEADD(minute, @Minutes3, @dep_time));
					PRINT 'INSERT 1 flight leg for each flight successfully!';
				END
		END
	ELSE
		PRINT 'This flight had already been inserted. Do not do it again!';
END


EXEC addFlightAndLegs 10001, '11:30', 'BOS', 'CAN', 13.8, 'PEK', 3.1, 1;
EXEC addFlightAndLegs 10003, '14:30', 'TXL', 'SHA', 9.1, 'PEK', 2.2, 3;
EXEC addFlightAndLegs 10005, '9:30', 'SEA', 'CAN', 12.0, 'SHA', 2.1, 2;
EXEC addFlightAndLegs 10007, '22:15', 'YYZ', 'HGH', 13.5, 'PEK', 2.3, 5;
EXEC addFlightAndLegs 10009, '3:30', 'SJC', 'CAN', 11.8, 'PEK', 3.1, 14;
EXEC addFlightAndLegs 10011, '10:48', 'BRU', 'PEK', 9.6;
EXEC addFlightAndLegs 10013, '3:30', 'ORD', 'PEK', 13.5;
EXEC addFlightAndLegs 10015, '6:10', 'SVO', 'PEK', 7.4;
EXEC addFlightAndLegs 10017, '20:22', 'BOS', 'SHA', 15.0;
EXEC addFlightAndLegs 10019, '1:30', 'LED', 'PEK', 7.7;

/* drop proc addFlightAndLegs */


---- insert data into leg_instance table

/* record information when the plane takes off*/
CREATE PROC recordLegInstanceWhenFly 
(@flight_no INT, @leg_no INT, @aircraft_id INT)
AS
BEGIN
	DECLARE @flightNo INT = NULL;
	SELECT  @flightNo = flight_no FROM flight.flight_legs
		WHERE flight_no = @flight_no AND leg_no = @leg_no;
	IF @flightNo IS NULL
		PRINT 'No information found for this flight leg!';
	ELSE
		BEGIN
			DECLARE @date_of_travel DATE;
			SET @date_of_travel = CONVERT(varchar(10),GETDATE(),120);
			DECLARE @dep_time DATETIME;
			SET @dep_time = CONVERT(varchar,GETDATE(),120);
			PRINT 'INSERT one flight leg successfully!';
			INSERT INTO flight.leg_instance (flight_no, leg_no, date_of_travel, dep_time, aircraft_id)
				VALUES (@flight_no, @leg_no, @date_of_travel, @dep_time, @aircraft_id);
		END
END

/* drop proc recordLegInstanceWhenFly */

/* record information when the plane landing*/
CREATE PROC recordLegInstanceWhenLand
(@flight_no INT, @leg_no INT, @legDepartureDate DATE)
AS
BEGIN
	DECLARE @flightNo INT = NULL;
	SELECT  @flightNo = flight_no FROM flight.leg_instance
		WHERE flight_no = @flight_no AND leg_no = @leg_no AND date_of_travel = @legDepartureDate;
	IF @flightNo IS NULL
		PRINT 'No information found for this flight leg!';
	ELSE
		BEGIN
			DECLARE @arr_time DATETIME;
			SET @arr_time = CONVERT(varchar,GETDATE(),120);
			PRINT 'UPDATE arrival time for one specific flight leg successfully!';
			UPDATE flight.leg_instance 
				SET arr_time = @arr_time
				WHERE flight_no = @flight_no AND leg_no = @leg_no AND date_of_travel = @legDepartureDate;
		END
END

/* drop proc recordLegInstanceWhenLand */


EXEC recordLegInstanceWhenFly 10001, 1, 10000;
EXEC recordLegInstanceWhenLand 10001, 1, '2019-12-01';

INSERT INTO flight.leg_instance VALUES
(10001,2,'2019-8-2','2019-8-2 02:28','2019-8-2 16:06',10000),
(10001,3,'2019-8-1','2019-08-01 11:30:00','2019-08-02 16:06:00',10000),
(10002,1, '2019-08-1', '2019-08-01 11:30', '2019-08-02 01:20',10002),
(10002,2, '2019-08-2', '2019-08-02 02:30', '2019-08-02 16:26',10002),
(10002,3, '2019-08-1', '2019-08-01 11:30', '2019-08-02 16:26',10002),
(10003,1, '2019-08-1', '2019-08-01 14:30', '2019-08-02 23:45',10003),
(10003,2, '2019-08-2', '2019-08-02 02:50', '2019-08-02 11:59',10003),
(10003,3, '2019-08-1', '2019-08-01 14:30', '2019-08-02 11:59',10003),
(10011,1, '2019-08-1', '2019-08-01 10:48:00', '2019-08-02 20:23:00',10001),
(10013,1, '2019-08-1', '2019-08-01 03:30:00', '2019-08-02 17:00:00',10004);



-- adding more data to Passenger.passenger table

INSERT INTO Passenger.passenger(psg_type) VALUES(0)

CREATE PROCEDURE addpass
       @num INT
AS
BEGIN
	while (@num > 0)
		BEGIN
			INSERT Passenger.passenger DEFAULT VALUES;
			SET @num = @num - 1;
		END
END

--DROP PROCEDURE addpass; 

EXEC addpass 525;
EXEC addpass 100;



-- changes made to change the primary key of Passenger.RESERVATION Table

ALTER TABLE Passenger.reservation 
DROP CONSTRAINT PK__reservat__397465D600CEA034;

ALTER TABLE Passenger.reservation DROP COLUMN rev_id;

ALTER TABLE Passenger.reservation ADD reservation_no INT PRIMARY KEY IDENTITY(1000,1)


ALTER TABLE Passenger.passenger
	ADD CONSTRAINT chkBirthday CHECK (birthday  <= GetDate());

ALTER TABLE Passenger.ticket
	ADD CONSTRAINT chkTicketPrice CHECK (ticket_price  > 0),
	CONSTRAINT chkBaggagePrice CHECK (baggage_price  >= 0);

ALTER TABLE Cost.ground_cost
	ADD CONSTRAINT chkWearing CHECK (wearing > 0),
		CONSTRAINT chkMaintenance CHECK (maintenance > 0),
		CONSTRAINT chkUsage CHECK (airport_usage_fee > 0);


-- added a identity attribute in Passenger.passenger table
ALTER TABLE Passenger.passenger ADD passenger_no INT IDENTITY(100,1);

--ALTER TABLE Passenger.passenger ADD PRIMARY KEY (passenger_no);

-- changing the data type for phone number attribute in Passenger.passenger table
ALTER TABLE Passenger.passenger ALTER COLUMN phone_no BIGINT;

-- changes made to change the primary key of Passenger.passenger Table
ALTER TABLE Passenger.ticket 
DROP CONSTRAINT FKTicket;

ALTER TABLE Passenger.passenger 
DROP CONSTRAINT PKPassenger;

ALTER TABLE Passenger.passenger DROP COLUMN passenger_no;

ALTER TABLE Passenger.passenger ADD passenger_no INT PRIMARY KEY IDENTITY(100,1)

ALTER TABLE Passenger.passenger ALTER  COLUMN psg_id VARCHAR(45);


-- changes made in the Passenger.ticket table adding new foreign key
ALTER TABLE Passenger.ticket DROP COLUMN psg_id, psg_type;

ALTER TABLE Passenger.ticket ADD passenger_no INT FOREIGN KEY REFERENCES Passenger.passenger(passenger_no);


--insertion of data in Passenger.passenger table.

INSERT INTO Passenger.passenger VALUES ( '1342453', 0, 'Wayne', 'K.','Peter', 1, 4256245678, 'waynep@gmail.com','01/06/1990'),
( '654163', 0, 'Wei', 'S.','Tianrui', 1, 9096145678, 'tianruiwei@gmail.com','05/06/1994'),
( 'SY4560', 1, 'Malfoy', 'T.','Amanda', 0, 3234145998, 'malfoyamanda@gmail.com','12/06/1982'),
( 'HKS1061', 1, 'Walter', 'A.','Jake', 1, 6071915522, 'walterjake@gmail.com','11/09/1991'),
( '7474540', 0, 'Han', 'V.','Shang', 1, 3608708986, 'hanshang@gmail.com','10/12/1993'),
( '457540', 0, 'Li', 'V.','Zechen', 1, 2063108681, 'lizec@gmail.com','07/07/1996'),
( 'GHI8641', 1, 'Dinkling', 'Z.','Amy', 0, 2066115971, 'amyz@gmail.com','04/16/1980'),
( 'NMO5361', 1, 'Wayne', 'A.','Josh', 1, 2068125712, 'waynejosh@gmail.com','01/29/1985'),
( 'YIN3535', 1, 'McDougall', 'S.','Harry', 1, 4252349678, 'harry12@gmail.com','09/19/1978'),
( '890565', 0, 'Hun', 'C.','Mei', 0, 2068809298, 'hunm@gmail.com','07/15/1992');

--DELETE FROM Passenger.passenger WHERE first_name='Peter';

-- insertion of data in Passenger.ticket table.

--DELETE FROM Passenger.ticket;

INSERT INTO Passenger.ticket (ticket_no, ticket_type, ticket_price, baggage_price, passenger_no) 
VALUES (2123, 0, 90.95, 40, 100), (7321, 1, 399.25, 60, 101), (8563, 0, 94.29, 40, 102),
(2321, 2, 794.22, 80, 103), (9654, 2, 858.80, 80, 104), (9231, 1, 501.96, 60, 105), (2945, 0, 90.95, 40, 106), 
(3223, 1, 399.25, 60, 107), (0852, 2, 794.22, 80, 108), (5439, 1, 399.25, 60, 109);


 /* data encryption */
-- Create DMK
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Group9Psw';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE TestCertificate
WITH SUBJECT = 'Group9 Test Certificate',
EXPIRY_DATE = '2026-10-31';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY TestSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE TestCertificate;

-- Open symmetric key
OPEN SYMMETRIC KEY TestSymmetricKey
DECRYPTION BY CERTIFICATE TestCertificate;

----Insert data into crew.staff
insert into [Crew].[staff] values (1,1,'lebron','l','james','1',2061234567,'james.gmail.com','06/21/1994')
,(2,2,'dwight','m','wade','1',2061234568,'wade.gmail.com','08/02/1982'),
(3,3,'chris','o','paul','1',2061234569,'paul.gmail.com','06/02/1988'),
(4,4,'camero','r','anthony','1',2061234570,'anthony.gmail.com','05/31/1971'),
(5,5,'steven','w','curry','0',2061234571,'curry.gmail.com','03/31/1979'),
(6,6,'camero','r','anthony','1',2061234572,'anthony.gmail.com','07/03/1976'),
(7,7,'jiayi','w','ren','0',2061234573,'ren.gmail.com','10/03/1993'),
(8,8,'james','h','harden','0',2061234574,'harden.gmail.com','04/01/1973'),
(9,9,'paul','c','george','1',2061234575,'george.gmail.com','02/06/1968'),
(10,10,'kevin','n','durant','1',2061234576,'durant.gmail.com','09/01/1977');

insert into [Crew].[crew] values (1901,10001,'08/01/2019'),(1902,10001,'08/01/2019'),
(1903,10001,'08/01/2019'),(1904,10001,'08/01/2019'),(1905,10001,'08/01/2019'),
(1906,10001,'08/01/2019'),(1907,10001,'08/01/2019'),(1908,10001,'08/01/2019'),(1911,10011,'08/01/2019'),(1912,10011,'08/01/2019'),
(1913,10011,'08/01/2019'),(1914,10011,'08/01/2019'),(1915,10011,'08/01/2019'),(1916,10011,'08/01/2019'),
(1917,10011,'08/01/2019'),(1918,10011,'08/01/2019');

insert into [Crew].[staff] values (11,1,'zhiqi','x','kang','1',2061234577,'kang.gmail.com','01/28/1993')
,(12,2,'zhun','h','song','1',2061234578,'song.gmail.com','08/02/1996'),
(13,2,'zhaohong','b','zhu','0',2061234579,'zhu.gmail.com','06/22/1992'),
(14,2,'sijian','g','zhou','1',2061234580,'zhou.gmail.com','05/27/1997'),
(15,2,'weijin','l','zhang','0',2061234581,'zhang.gmail.com','03/11/1987'),
(16,2,'chengyuan','k','zhou','1',2061234582,'zhou1.gmail.com','07/03/1998'),
(17,2,'yuerui','h','guo','0',2061234583,'guo.gmail.com','10/01/1999'),
(18,2,'da','s','deng','1',2061234584,'deng.gmail.com','08/12/1993'),
(19,2,'ke','c','huang','0',2061234585,'huang.gmail.com','02/08/1998'),
(20,3,'yifan','h','li','1',2061234586,'li.gmail.com','09/13/1991'),
(21,3,'siyang','c','liu','1',2061234587,'liu.gmail.com','09/27/1995'),
(22,3,'yan','s','xi','0',2061234588,'xi.gmail.com','04/14/1997');

insert into [Crew].[crew] values (1,10001,'08/01/2019'),(2,10001,'08/01/2019'),
(12,10001,'08/01/2019'),(13,10001,'08/01/2019'),(14,10001,'08/01/2019'),
(15,10001,'08/01/2019'),(16,10001,'08/01/2019'),(20,10001,'08/01/2019'),(23,10011,'08/01/2019'),(17,10011,'08/01/2019'),
(24,10011,'08/01/2019'),(25,10011,'08/01/2019'),(26,10011,'08/01/2019'),(27,10011,'08/01/2019'),
(28,10011,'08/01/2019'),(22,10011,'08/01/2019');

insert into [Crew].[staff] values 
(23,2,'zhenying','b','lin','0',2061234589,'lin.gmail.com','06/22/1991'),
(24,2,'ying','y','li','1',2061234590,'li1.gmail.com','05/27/1982'),
(25,2,'lixian','n','tang','0',2061234591,'tang.gmail.com','03/11/1986'),
(26,2,'jie','k','shen','1',2061234592,'shen.gmail.com','07/03/1993'),
(27,2,'shan','h','huang','0',2061234593,'huang.gmail.com','10/01/1997'),
(28,2,'fusheng','l','ren','1',2061234594,'ren1.gmail.com','08/12/1969'),
(29,2,'xiaoyu','c','liu','0',2061234595,'liu3.gmail.com','02/08/1987');


ALTER TABLE Passenger.reservation 
DROP CONSTRAINT FK__reservati__ticke__367C1819;

ALTER TABLE Passenger.ticket 
DROP CONSTRAINT PK__ticket__D596C19777587F91;

ALTER TABLE Passenger.ticket DROP COLUMN ticket_no;

ALTER TABLE Passenger.ticket ADD ticket_no INT PRIMARY KEY IDENTITY(100,1)

ALTER TABLE Passenger.reservation ADD FOREIGN KEY (ticket_no) REFERENCES Passenger.ticket(ticket_no);


CREATE PROC addTicket
(
@sumTicket INT, @ticketType INT, @ticketPrice Money, 
@bagPrice Money, @startPsgNum INT
)
AS
BEGIN
	WHILE (@sumTicket > 0)
		BEGIN
			INSERT INTO Passenger.ticket (ticket_type, ticket_price, baggage_price, passenger_no)
				VALUES (@ticketType, @ticketPrice, @bagPrice, @startPsgNum);
			SET @startPsgNum = @startPsgNum + 1;
			SET @sumTicket = @sumTicket - 1;
		END
END

EXEC addTicket 100, 0, 94.29, 40, 1635;
EXEC addTicket 29, 1, 399.25, 60, 1735;
EXEC addTicket 20, 2, 858.8, 80, 1764;

EXEC addTicket 100, 0, 94.29, 40, 1784;
EXEC addTicket 39, 1, 399.25, 60, 1884;
EXEC addTicket 20, 2, 858.8, 80, 1923;

EXEC addTicket 30, 0, 94.29, 40, 1943;
EXEC addTicket 10, 1, 399.25, 60, 1983;
EXEC addTicket 10, 2, 858.8, 80, 1993;

EXEC addTicket 100, 0, 90.95, 40, 2003;
EXEC addTicket 40, 1, 501.96, 60, 2103;
EXEC addTicket 27, 2, 794.22, 80, 2143;


/* drop proc addTicket */



-- insert data into seat and reservation tables

CREATE PROC CreateSeatAndRev
(@flight_no INT, @leg_no INT, @date_of_travel DATE, @sumticket INT, @startTicket INT)
AS
BEGIN
	DECLARE @flightNo INT = NULL;
	SELECT  @flightNo = flight_no FROM flight.leg_instance
		WHERE flight_no = @flight_no AND leg_no = @leg_no AND date_of_travel = @date_of_travel;
	IF @flightNo IS NULL
		PRINT 'No information found for this flight leg!';
	ELSE
		BEGIN
			DECLARE @num INT 
					SET @num= 1;
			WHILE (@sumticket > 0)
				BEGIN
					INSERT INTO Flight.seat VALUES (@num, @flight_no, @leg_no, @date_of_travel);
					INSERT INTO Passenger.reservation (ticket_no, flight_no, leg_no, date_of_travel, seat_no) 
						VALUES (@startTicket, @flight_no, @leg_no, @date_of_travel, @num);
					SET @num = @num + 1;
					SET @startTicket = @startTicket + 1;
					SET @sumTicket = @sumTicket - 1;
				END		
		END		
END


/* drop proc CreateSeat */

EXEC CreateSeat 10001, 1, '2019-08-01', 0.7028;
EXEC CreateSeat 10001, 2, '2019-08-02', 0.75;
EXEC CreateSeat 10001, 3, '2019-08-01', 0.2358;
EXEC CreateSeat 10011, 1, '2019-08-01', 0.5901;


-- adding more data to Passenger.passenger table

INSERT INTO Passenger.passenger(psg_type) VALUES(0)

CREATE PROCEDURE addpass
       @num INT
AS
BEGIN
	while (@num > 0)
		BEGIN
			INSERT Passenger.passenger DEFAULT VALUES;
			SET @num = @num - 1;
		END
END

/* drop proc CreateSeatAndRev */

EXEC CreateSeatAndRev 10001, 1, '2019-08-01', 149, 2161;
EXEC CreateSeatAndRev 10001, 2, '2019-08-02', 159, 2310;
EXEC CreateSeatAndRev 10001, 3, '2019-08-01', 50 ,2469;
EXEC CreateSeatAndRev 10011, 1, '2019-08-01', 167 ,2519;



-- changes made to change the primary key of Passenger.RESERVATION Table

------------------------------------------------------------------------------

ALTER TABLE Passenger.reservation 
DROP CONSTRAINT PK__reservat__397465D600CEA034;

ALTER TABLE Passenger.reservation DROP COLUMN rev_id;

ALTER TABLE Passenger.reservation ADD reservation_no INT PRIMARY KEY IDENTITY(1000,1);

------------------------------------------------------------------------
/* 
 * Alter table for aircraft model
 */
ALTER TABLE Aircraft.aircraft_model Add aircraft_model_name varchar(45); 

/* 
 * Insert data for aircraft model (premium count as eco)
 */

INSERT INTO Aircraft.aircraft_model 
(aircraft_model_id, aircraft_model_name, first_seats, business_seats, economy_seats)
VALUES(1, 'B787', 12, 24, 176), 
(2, 'A330', 16, 30, 237), 
(3, 'B737-800', 8, 16, 156), 
(4, 'B737-neo', 16, 0, 148),
(5, 'B747-400', 24, 44, 348), 
(6, 'B767-300', 20, 38, 170),
(7, 'B777-300ER', 8, 48, 160), 
(8, 'A321', 20, 29, 140), 
(9, 'A350', 24, 42, 244), 
(10, 'A380-800', 18, 64, 410);

/* 
 * Insert data for aircraft model, change the aircraft id with identity
 */

ALTER TABLE Aircraft.aircraft  
DROP CONSTRAINT FK__aircraft__aircra__10566F31; 

ALTER TABLE Flight.leg_instance
DROP CONSTRAINT FK__leg_insta__aircr__245D67DE; 

ALTER TABLE Aircraft.aircraft  
DROP CONSTRAINT PK__aircraft__0401539994CE153B; 

ALTER TABLE Aircraft.aircraft
DROP COLUMN aircraft_id;

ALTER TABLE Aircraft.aircraft
Add aircraft_id INT IDENTITY(10000,1) NOT NULL PRIMARY KEY (aircraft_id);

ALTER TABLE Aircraft.aircraft ADD FOREIGN KEY (aircraft_model_id) REFERENCES Aircraft.aircraft_model (aircraft_model_id);

ALTER TABLE Flight.leg_instance ADD FOREIGN KEY (aircraft_id) REFERENCES Aircraft.aircraft (aircraft_id);

INSERT INTO Aircraft.aircraft
(aircraft_model_id, aircraft_year)
VALUES(1, 2000), (2, 1999), (1, 1998), (1, 2000),
(1, 1999), (2, 1997), (1, 1998), (1, 2000),
(1, 2000), (2, 1999);

------------------------------------------------------------------------

/* Modify the name of column and insert value for ground cost
 * */

DROP TABLE Cost.ground_cost;

/* 
ALTER TABLE Cost.ground_cost
DROP COLUMN maintance;

ALTER TABLE Cost.ground_cost
ADD maintenance Money NOT NULL;
*/

CREATE TABLE Cost.ground_cost (
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
	wearing Money NOT NULL,
	maintenance Money NOT NULL,
	airport_usage_fee Money NOT NULL,
		CONSTRAINT PKGroundCost PRIMARY KEY CLUSTERED (flight_no, leg_no, date_of_travel),
		CONSTRAINT FKGroundCost FOREIGN KEY (flight_no, leg_no, date_of_travel) REFERENCES Flight.leg_instance(flight_no, leg_no, date_of_travel)
);

INSERT INTO Cost.ground_cost
(flight_no, leg_no, date_of_travel, wearing, maintenance, airport_usage_fee)
VALUES(10001, 1, '2019-08-01', 400, 200, 140), (10001, 2, '2019-08-02', 10, 20, 100), (10001, 3, '2019-08-01', 410, 220, 240), 
(10002, 1, '2019-08-01', 350, 120, 90), (10002, 2, '2019-08-02', 200, 40, 140), (10002, 3, '2019-08-01', 550, 160, 230),
(10003, 1, '2019-08-01', 400, 220, 150), (10003, 2, '2019-08-02', 100, 40, 140), (10003, 3, '2019-08-01', 500, 260, 290),
(10011, 1, '2019-08-01', 350, 180, 140), (10013, 1, '2019-08-01', 500, 160, 150);


insert into Cost.flight_cost values 
(10001,1,30000,3000),
(10001,2,10000,3000),
(10011,1,37500,4700);


/* view 1: RASM */

-- leg1

CREATE VIEW Revenue
AS 
SELECT flight_no AS [Flight Number], leg_no AS [Leg Number], date_of_travel AS [Date Of Travel],
	SUM(ticket_price) AS [Sum Ticket Price], SUM(baggage_price) AS [Sum Baggage Price]
FROM Passenger.reservation AS rev
LEFT JOIN Passenger.ticket AS tik
	On rev.ticket_no = tik.ticket_no
GROUP BY flight_no, leg_no, date_of_travel;


CREATE VIEW Distance
AS
SELECT fl.flight_no AS [Flight Number], fl.leg_no AS [Leg Number],
	distance
FROM Flight.flight_legs AS fl
LEFT JOIN Flight.route AS rt
	ON fl.route_id = rt.route_id;

CREATE VIEW Capacity
AS
SELECT flight_no AS [Flight Number], leg_no AS [Leg Number], date_of_travel AS [Date Of Travel], CAST(arr_time AS DATE) AS [Arrival Date],
	 first_seats + business_seats + economy_seats AS [Capacity]
FROM Flight.leg_instance AS li
LEFT JOIN Aircraft.aircraft AS ac
	ON li.aircraft_id = ac.aircraft_id
LEFT JOIN Aircraft.aircraft_model AS am
	ON am.aircraft_model_id = ac.aircraft_model_id;

CREATE VIEW report
AS
SELECT r.[Flight Number], r.[Leg Number], r.[Date Of Travel], c.[Arrival Date],
	[Sum Ticket Price], distance, [Capacity]
FROM Revenue AS r
LEFT JOIN Distance AS d
	ON r.[Flight Number] = d.[Flight Number] AND r.[Leg Number] = d.[Leg Number]
LEFT JOIN Capacity AS c
	ON r.[Flight Number] = c.[Flight Number] AND r.[Leg Number]  = c.[Leg Number] AND r.[Date Of Travel] = c.[Date Of Travel];
	
SELECT * FROM report;

DROP VIEW Revenue, Distance, Capacity,CalculateRASM;

-- this function is used to get the rasm for the each leg of one flight, the third leg means the whole leg.
CREATE FUNCTION GetRASM
(@flight_no INT, @departDate DATE, @arrivalDate DATE)
RETURNS @RASM TABLE ([Flight Number] INT, leg VARCHAR(45), RASM FLOAT)
AS 
BEGIN
	DECLARE @maxLeg INT;
	SET @maxLeg = 0;
	SELECT @maxLeg = MAX([Leg Number]) FROM report
		WHERE [Flight Number] = @flight_no And [Date Of Travel] = @departDate AND [Arrival Date] = @arrivalDate;
	IF @maxleg = 1 
		BEGIN
			DECLARE @RASM0 FLOAT;
			SELECT @RASM0 = ([Sum Ticket Price]/distance/[Capacity]) FROM report	
				WHERE [Flight Number] = @flight_no And [Date Of Travel] = @departDate;
			INSERT INTO @RASM VALUES (@flight_no, 'The first and total leg', @RASM0);
		END
	ELSE IF @maxleg = 3
		BEGIN
			DECLARE @RASM1 FLOAT;
			DECLARE @RASM2 FLOAT;
			DECLARE @Distance3 FLOAT;
			DECLARE @Capacity3 INT;
			DECLARE @Revenue1 Money;
			DECLARE @Revenue2 Money;
			DECLARE @Revenue3 Money;
			SELECT @RASM1 = ([Sum Ticket Price]/distance/[Capacity]),
				@Revenue1 = [Sum Ticket Price]
				FROM report	
				WHERE [Flight Number] = @flight_no And [Date Of Travel] = @departDate AND [Leg Number] = 1;
			SELECT @RASM2 = ([Sum Ticket Price]/distance/[Capacity]),
				@Revenue2 = [Sum Ticket Price]
				FROM report	
				WHERE [Flight Number] = @flight_no And [Arrival Date] = @arrivalDate AND [Leg Number] = 2;
			SELECT @Distance3 = distance, @Capacity3 = [Capacity],@Revenue3 = [Sum Ticket Price]
				FROM report
				WHERE [Flight Number] = @flight_no And [Arrival Date] = @arrivalDate AND [Leg Number] = 3;
			INSERT INTO @RASM VALUES (@flight_no, 'The first leg', @RASM1);
			INSERT INTO @RASM VALUES (@flight_no, 'The second leg', @RASM2);
			INSERT INTO @RASM VALUES (@flight_no, 'The total leg', ((@Revenue1+@Revenue2+@Revenue3)/@Distance3/@Capacity3));
		END
		RETURN;
END

SELECT * FROM GetRASM(10001, '2019-08-01', '2019-08-02');
SELECT * FROM GetRASM(10011, '2019-08-01', '2019-08-02');

DROP FUNCTION GetRASM;
























