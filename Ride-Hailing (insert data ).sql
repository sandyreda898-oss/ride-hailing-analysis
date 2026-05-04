USE ride_hailing;
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Users (name, phone, email, rating)
    VALUES (
        CONCAT('User_', @i),
        CONCAT('010', RIGHT('00000000' + CAST(@i AS VARCHAR), 8)),
        CONCAT('user', @i, '@mail.com'),
        RAND() * 5
    );

    SET @i = @i + 1;
END;
SELECT * FROM Users
DECLARE @i INT;
SET @i = 1;

WHILE @i <= 200
BEGIN
    INSERT INTO Drivers (name, phone, license_number, rating, status)
    VALUES (
        'Driver_' + CAST(@i AS VARCHAR(10)),
        '011' + RIGHT('00000000' + CAST(@i AS VARCHAR(8)), 8),
        'LIC' + CAST(@i AS VARCHAR(10)),
        3 + (RAND() * 2),
        CASE WHEN RAND() > 0.2 THEN 'active' ELSE 'offline' END
    )

    SET @i = @i + 1
END
SELECT * FROM Drivers
DECLARE @i INT = 1;

WHILE @i <= 200
BEGIN
    INSERT INTO Cars (driver_id, model, plate_number, color, year)
    VALUES (
        @i,
        CASE WHEN RAND() > 0.5 THEN 'Toyota' ELSE 'Hyundai' END,
        CONCAT('CAR', @i),
        CASE WHEN RAND() > 0.5 THEN 'White' ELSE 'Black' END,
        2015 + (RAND() * 10)
    );

    SET @i = @i + 1;
END;
SELECT * FROM Cars
DECLARE @i INT = 1;

WHILE @i <= 5000
BEGIN
    INSERT INTO Trips
    (user_id, driver_id, car_id, pickup_location, dropoff_location, request_time, start_time, end_time, status, fare, distance)
    VALUES (
        FLOOR(RAND()*1000)+1,
        FLOOR(RAND()*200)+1,
        FLOOR(RAND()*200)+1,
        'Location_A',
        'Location_B',
        DATEADD(DAY, -RAND()*30, GETDATE()),
        GETDATE(),
        GETDATE(),
        CASE WHEN RAND() > 0.1 THEN 'completed' ELSE 'cancelled' END,
        RAND()*200,
        RAND()*30
    );

    SET @i = @i + 1;
END;

SELECT * FROM Trips
DECLARE @i INT;
SET @i = 1;

WHILE @i <= 5000
BEGIN
    INSERT INTO Payments (trip_id, amount, payment_method, payment_status, payment_time)
    VALUES (
        @i,
        50 + (RAND() * 200), -- fare عشوائي
        CASE 
            WHEN RAND() < 0.4 THEN 'cash'
            WHEN RAND() < 0.8 THEN 'card'
            ELSE 'wallet'
        END,
        'paid',
        DATEADD(MINUTE, -FLOOR(RAND()*10000), GETDATE())
    );

    SET @i = @i + 1;
END;

SELECT * FROM Payments 
DECLARE @i INT;
SET @i = 1;

WHILE @i <= 5000
BEGIN
    IF EXISTS (SELECT 1 FROM Trips WHERE trip_id = @i AND status = 'completed')
    BEGIN
        INSERT INTO Ratings (trip_id, user_rating, driver_rating, feedback)
        VALUES (
            @i,
            3 + FLOOR(RAND() * 3),  -- من 3 لـ 5
            3 + FLOOR(RAND() * 3),
            CASE 
                WHEN RAND() < 0.3 THEN 'Excellent service'
                WHEN RAND() < 0.6 THEN 'Good ride'
                ELSE 'Average experience'
            END
        );
    END

    SET @i = @i + 1;
END;
SELECT * FROM Ratings
