--Part 2 – Implementation
--Write the DDL (CREATE) statements to create the database implementing the PK and FK constraints.

DROP SCHEMA IF EXISTS Flight_mgmt CASCADE;

CREATE SCHEMA IF NOT EXISTS Flight_mgmt;

SET search_path TO Flight_mgmt;

CREATE TABLE Booking_agents (
    Agent_id INT NOT NULL,
    Agent_name VARCHAR NOT NULL,
    Agent_details VARCHAR,
	PRIMARY KEY (Agent_id)
);

CREATE TABLE Ref_calendar (
    day_date DATE  NOT NULL,
    day_number INT,
    business_day_yn BOOLEAN NOT NULL,
	PRIMARY KEY (day_date)
);

CREATE TABLE Passengers (
    Passenger_id INT NOT NULL,
    First_name VARCHAR(25) NOT NULL,
    Second_name VARCHAR(25),
    Last_name VARCHAR(25) NOT NULL,
    Phone_number BIGINT,
    Email_address VARCHAR(50),
    Address_lines VARCHAR,
    City VARCHAR(30),
    State_province_county VARCHAR(2),
    Country VARCHAR(30),
    Other_passenger_details VARCHAR,
	PRIMARY KEY (Passenger_id)
);

CREATE TABLE Airports (
    airport_code VARCHAR(3) NOT NULL,
    airport_name VARCHAR(50),
    airport_location VARCHAR(50),
    other_details VARCHAR,
	PRIMARY KEY (airport_code)
);

CREATE TABLE Payments (
    Payment_id INT NOT NULL,
    Payment_status_code INT NOT NULL,
    Payment_date DATE NOT NULL,
    Payment_amount DECIMAL(8, 2) NOT NULL,
	PRIMARY KEY (Payment_id),
	FOREIGN KEY (Payment_date) REFERENCES Ref_calendar(Day_date)
);

CREATE TABLE Flight_costs (
    Flight_number INT NOT NULL,
    Aircraft_type_code INT NOT NULL,
    valid_from_date DATE NOT NULL,
    valid_to_date DATE NOT NULL,
    flight_cost DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY (Flight_number, Aircraft_type_code),
	UNIQUE (Aircraft_type_code),
	UNIQUE (Flight_number)
);

CREATE TABLE Itinerary_reservations (
    Reservation_id INT NOT NULL,
	Flight_number INT NOT NULL,
    Agent_id INT NOT NULL,
    Passenger_id INT NOT NULL,
    Reservation_status_code INT NOT NULL,
    Ticket_type_code INT NOT NULL,
    Travel_class_code INT NOT NULL,
    Date_reservation_made DATE NOT NULL,
    Number_in_party INT,
	PRIMARY KEY (Reservation_id),
    FOREIGN KEY (Agent_id) REFERENCES Booking_agents(Agent_id),
    FOREIGN KEY (Passenger_id) REFERENCES Passengers(Passenger_id),
	FOREIGN KEY (Flight_number) REFERENCES Flight_costs(Flight_number),
	FOREIGN KEY (Date_reservation_made) REFERENCES Ref_calendar(Day_date)
);

CREATE TABLE Itinerary_legs (
    Reservation_id INT NOT NULL,
    Leg_id INT NOT NULL,
	Flight_number INT NOT NULL,
    PRIMARY KEY (Reservation_id, Leg_id),
    FOREIGN KEY (Reservation_id) REFERENCES Itinerary_reservations(Reservation_id),
	FOREIGN KEY (Flight_number) REFERENCES Flight_costs(Flight_number)
);

CREATE TABLE Reservation_payments (
    Reservation_id INT NOT NULL,
    Payment_id INT NOT NULL,
    PRIMARY KEY (Reservation_id, Payment_id),
    FOREIGN KEY (Reservation_id) REFERENCES Itinerary_reservations(Reservation_id),
    FOREIGN KEY (Payment_id) REFERENCES Payments(Payment_id)
);

CREATE TABLE Flight_schedules (
    Flight_number INT NOT NULL,
    Airline_code INT NOT NULL,
    Usual_aircraft_type_code INT NOT NULL,
    Origin_airport_code VARCHAR(3) NOT NULL,
    Destination_airport_code VARCHAR(3) NOT NULL,
    Departure_date_time TIMESTAMP NOT NULL,
    Arrival_date_time TIMESTAMP NOT NULL,
	PRIMARY KEY (Flight_number),
	FOREIGN KEY (Usual_aircraft_type_code) REFERENCES Flight_costs(Aircraft_type_code),
	FOREIGN KEY (Origin_airport_code) REFERENCES Airports(airport_code),
	FOREIGN KEY (Destination_airport_code) REFERENCES Airports(airport_code)
);

CREATE TABLE Legs (
    Leg_id INT NOT NULL,
    Flight_number INT NOT NULL,
    Origin_airport VARCHAR(3) NOT NULL,
    Destination_airport VARCHAR(3) NOT NULL,
    Actual_departure_time TIMESTAMP,
    Actual_arrival_time TIMESTAMP,
	PRIMARY KEY (Leg_id),
	FOREIGN KEY (Flight_number) REFERENCES Flight_schedules(Flight_number),
	FOREIGN KEY (Origin_airport) REFERENCES Airports(airport_code),
	FOREIGN KEY (Destination_airport) REFERENCES Airports(airport_code)
);

--Sample data
INSERT INTO Booking_agents (Agent_id, Agent_name, Agent_details)
VALUES
    (1, 'Jon Jones', 'Generic details about Jon Jones'),
    (2, 'Daniel Cormier', 'Generic details about Daniel Cormier');

INSERT INTO Ref_calendar (day_date, day_number, business_day_yn)
VALUES
    ('2023-09-21', 1, true),
    ('2023-09-23', 2, false);

INSERT INTO Passengers (Passenger_id, First_name, Second_name, Last_name, Phone_number, Email_address, Address_lines, City, State_province_county, Country, Other_passenger_details)
VALUES
    (1, 'Tim', 'Cam', 'Thomas', 1234567890, 'tim@bruins.com', '123 Main St', 'Burlington', 'VT', 'USA', 'Generic details about Tim'),
    (2, 'Jeremy', 'Jeremiah', 'Swayman', 9876543210, 'jeremy@bruins.com', '456 Causeway St', 'Boston', 'MA', 'USA', 'Generic details about Jeremy');

INSERT INTO Airports (airport_code, airport_name, airport_location, other_details)
VALUES
    ('BOS', 'Logan', 'Boston', 'Generic details about BOS'),
    ('LAX', 'Los Angeles International', 'Los Angeles', 'Generic details about LAX');

INSERT INTO Payments (Payment_id, Payment_status_code, Payment_date, Payment_amount)
VALUES
    (1, 101, '2023-09-21', 100.00),
    (2, 102, '2023-09-23', 150.00);

INSERT INTO Flight_costs (Flight_number, Aircraft_type_code, valid_from_date, valid_to_date, flight_cost)
VALUES
    (101, 201, '2023-09-21', '2023-09-30', 200.00),
    (102, 202, '2023-09-21', '2023-09-30', 250.00);

INSERT INTO Itinerary_reservations (Reservation_id, Flight_number, Agent_id, Passenger_id, Reservation_status_code, Ticket_type_code, Travel_class_code, Date_reservation_made, Number_in_party)
VALUES
    (1, 101, 1, 1, 301, 401, 501, '2023-09-21', 2),
    (2, 102, 2, 2, 302, 402, 502, '2023-09-23', 1);

INSERT INTO Itinerary_legs (Reservation_id, Leg_id, Flight_number)
VALUES
    (1, 1, 102),
    (2, 2, 101);

INSERT INTO Reservation_payments (Reservation_id, Payment_id)
VALUES
    (1, 1),
    (2, 2);

INSERT INTO Flight_schedules (Flight_number, Airline_code, Usual_aircraft_type_code, Origin_airport_code, Destination_airport_code, Departure_date_time, Arrival_date_time)
VALUES
    (101, 1001, 201, 'BOS', 'LAX', '2023-09-21 08:00:00', '2023-09-21 10:00:00'),
    (102, 1002, 202, 'LAX', 'BOS', '2023-09-23 09:00:00', '2023-09-23 11:00:00');

INSERT INTO Legs (Leg_id, Flight_number, Origin_airport, Destination_airport, Actual_departure_time, Actual_arrival_time)
VALUES
    (1, 101, 'BOS', 'LAX', '2023-09-21 09:00:00', '2023-09-21 11:00:00'),
    (2, 102, 'LAX', 'BOS', '2023-09-23 09:00:00', '2023-09-23 11:00:00');

--Write the SQL queries/views for the highlighted requirements in section 2.3

-- Create a view for customers to view their itineraries
CREATE VIEW CustomerItinerary AS
WITH Itineraries AS (
    SELECT ir.Passenger_id, ir.Reservation_id, ir.Date_reservation_made, ir.Number_in_party,
           f.Flight_number, f.Origin_airport_code, f.Destination_airport_code, f.Departure_date_time, f.Arrival_date_time,
           l.Actual_departure_time, l.Actual_arrival_time
    FROM Itinerary_reservations ir
    INNER JOIN Flight_schedules f ON ir.Flight_number = f.Flight_number
    LEFT JOIN Legs l ON ir.Flight_number = l.Flight_number
)
SELECT * FROM Itineraries;

SELECT * FROM CustomerItinerary WHERE Passenger_id = 1 
-- Customer Functions

-- Get All Customers with Seats Reserved on a Given Flight:
CREATE VIEW FlightCustomers AS
WITH CustomersByFlight AS (
    SELECT p.Passenger_id, p.First_name, p.Last_name, ir.Reservation_id, f.Flight_number
    FROM Passengers p
    INNER JOIN Itinerary_reservations ir ON p.Passenger_id = ir.Passenger_id
    INNER JOIN Itinerary_legs il ON ir.Reservation_id = il.Reservation_id
    INNER JOIN Flight_schedules f ON il.Flight_number = f.Flight_number
)
SELECT * FROM CustomersByFlight;

SELECT * FROM FlightCustomers WHERE Flight_number = 102;

-- Get All Flights for a Given Airport:
CREATE VIEW AirportFlights AS
	SELECT *
	FROM Flight_schedules;

SELECT * FROM AirportFlights WHERE Origin_airport_code = 'LAX' OR Destination_airport_code = 'LAX';

-- View Flight Schedule
CREATE VIEW FlightSchedule AS
	SELECT *
	FROM Flight_schedules;

SELECT * From FlightSchedule;

--Get All Flights Whose Arrival and Departure Times Are On Time:
CREATE VIEW OnTimeFlights AS
WITH FlightStat AS (
    SELECT fs.Flight_number, fs.Origin_airport_code, fs.Destination_airport_code, 
	fs.Arrival_date_time, fs.Departure_date_time, l.Actual_arrival_time, l.Actual_departure_time,
           CASE
               WHEN fs.Arrival_date_time < l.Actual_arrival_time OR fs.Departure_date_time < l.Actual_departure_time THEN 'Delayed'
               ELSE 'On Time'
           END AS FlightStat
    FROM Flight_schedules fs
    JOIN Legs l ON fs.Flight_number = l.Flight_number
)
SELECT * FROM FlightStat WHERE FlightStat = 'On Time';

SELECT * FROM OnTimeFlights;

--Delayed:
CREATE VIEW DelayedFlights AS
WITH FlightStat AS (
    SELECT fs.Flight_number, fs.Origin_airport_code, fs.Destination_airport_code, 
	fs.Arrival_date_time, fs.Departure_date_time, l.Actual_arrival_time, l.Actual_departure_time,
           CASE
               WHEN fs.Arrival_date_time < l.Actual_arrival_time OR fs.Departure_date_time < l.Actual_departure_time THEN 'Delayed'
               ELSE 'On Time'
           END AS FlightStat
    FROM Flight_schedules fs
    JOIN Legs l ON fs.Flight_number = l.Flight_number
)
SELECT * FROM FlightStat WHERE FlightStat = 'Delayed';

SELECT * FROM DelayedFlights;

-- Calculate Total Sales for a Given Flight:
CREATE VIEW SalesPerFlight AS
WITH FlightSales AS (
    SELECT f.Flight_number, SUM(p.Payment_amount) AS Total_Sales
    FROM Flight_schedules f
    JOIN Itinerary_legs il ON f.Flight_number = il.Flight_number
    JOIN Reservation_payments rp ON il.Reservation_id = rp.Reservation_id
    JOIN Payments p ON rp.Payment_id = p.Payment_id
    GROUP BY f.Flight_number
)
SELECT * FROM FlightSales;

SELECT * FROM SalesPerFlight WHERE Flight_number = 101;
