CREATE DATABASE ride_hailing;
USE ride_hailing;
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100)NOT NULL,
    phone NVARCHAR(20)NOT NULL,
    email NVARCHAR(100)NOT NULL,
    rating DECIMAL(3,2),
    created_at DATETIME DEFAULT GETDATE()
);
CREATE TABLE Drivers (
    driver_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100)NOT NULL,
    phone NVARCHAR(20)NOT NULL,
    license_number NVARCHAR(50)NOT NULL,
    rating DECIMAL(3,2),
     status NVARCHAR(20) NOT NULL 
    CHECK (status IN ('active', 'offline'))

);
CREATE TABLE Cars (
    car_id INT IDENTITY(1,1) PRIMARY KEY,
    driver_id INT,
    model NVARCHAR(50) NOT NULL,
    plate_number NVARCHAR(20)NOT NULL UNIQUE,
    color NVARCHAR(30)NOT NULL,
    year INT,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);
CREATE TABLE Trips (
    trip_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    driver_id INT,
    car_id INT,
    pickup_location NVARCHAR(255) NOT NULL,
    dropoff_location NVARCHAR(255) NOT NULL,
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
    payment_method NVARCHAR(20) NOT NULL,
    payment_status NVARCHAR(20)NOT NULL,
    payment_time DATETIME,
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);
CREATE TABLE Ratings (
    rating_id INT IDENTITY(1,1) PRIMARY KEY,
    trip_id INT NOT NULL,
    user_rating INT NOT NULL ,
    driver_rating INT NOT NULL,
    feedback NVARCHAR(255),
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);
