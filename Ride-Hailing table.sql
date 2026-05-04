CREATE DATABASE ride_hailing;
USE ride_hailing;
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    phone NVARCHAR(20),
    email NVARCHAR(100),
    rating DECIMAL(3,2),
    created_at DATETIME DEFAULT GETDATE()
);
CREATE TABLE Drivers (
    driver_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    phone NVARCHAR(20),
    license_number NVARCHAR(50),
    rating DECIMAL(3,2),
    status NVARCHAR(20) -- active / offline
);
CREATE TABLE Cars (
    car_id INT IDENTITY(1,1) PRIMARY KEY,
    driver_id INT,
    model NVARCHAR(50),
    plate_number NVARCHAR(20),
    color NVARCHAR(30),
    year INT,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);
CREATE TABLE Trips (
    trip_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    driver_id INT,
    car_id INT,
    pickup_location NVARCHAR(255),
    dropoff_location NVARCHAR(255),
    request_time DATETIME,
    start_time DATETIME NULL,
    end_time DATETIME NULL,
    status NVARCHAR(20), -- requested / completed / cancelled
    fare DECIMAL(10,2),
    distance DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);
CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    trip_id INT,
    amount DECIMAL(10,2),
    payment_method NVARCHAR(20),
    payment_status NVARCHAR(20),
    payment_time DATETIME,
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);
CREATE TABLE Ratings (
    rating_id INT IDENTITY(1,1) PRIMARY KEY,
    trip_id INT,
    user_rating INT,
    driver_rating INT,
    feedback NVARCHAR(255),
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);
