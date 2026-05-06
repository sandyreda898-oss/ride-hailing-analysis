USE ride_hailing;

-- 2.1  Top 10 drivers by completed trips
--      Identifies high-performing, reliable drivers who complete the most rides.
SELECT TOP 10
    d.driver_id,
    d.name                        AS driver_name,
    d.rating                      AS driver_rating,
    COUNT(t.trip_id)              AS completed_trips,
    ROUND(SUM(t.fare), 2)         AS total_earnings,
    ROUND(AVG(t.fare), 2)         AS avg_fare_per_trip
FROM Drivers d
JOIN Trips   t ON d.driver_id = t.driver_id
WHERE t.status = 'completed'
GROUP BY d.driver_id, d.name, d.rating
ORDER BY completed_trips DESC;
 
 -- 2.2  Top 20 users by total spending
--      Highlights the platform's highest-value customers for loyalty programs
--      or targeted promotions.
SELECT TOP 20
    u.user_id,
    u.name                          AS user_name,
    u.rating                        AS user_rating,
    COUNT(t.trip_id)                AS total_trips,
    ROUND(SUM(t.fare), 2)           AS total_spent,
    ROUND(AVG(t.fare), 2)           AS avg_spend_per_trip
FROM Users u
JOIN Trips t ON u.user_id = t.user_id
WHERE t.status = 'completed'
GROUP BY u.user_id, u.name, u.rating
ORDER BY total_spent DESC;
-- 2.3  Most popular pickup locations (Top 15)
--      Identifies demand hotspots to optimise driver positioning and
--      surge-pricing zones.
SELECT TOP 15
    pickup_location,
    COUNT(*)              AS pickup_count,
    ROUND(AVG(fare), 2)   AS avg_fare
FROM Trips
WHERE status = 'completed'
GROUP BY pickup_location
ORDER BY pickup_count DESC;
-- 2.4  Most popular dropoff locations (Top 15)
--      Shows where riders are heading — useful for return-trip opportunities.
SELECT TOP 15
    dropoff_location,
    COUNT(*)              AS dropoff_count,
    ROUND(AVG(fare), 2)   AS avg_fare
FROM Trips
WHERE status = 'completed'
GROUP BY dropoff_location
ORDER BY dropoff_count DESC;
-- 2.5  Driver performance analysis — trips, ratings, and earnings combined
--      A composite view of each driver's activity and quality score to support
--      performance reviews and incentive decisions.
WITH DriverStats AS (
    SELECT
        d.driver_id,
        d.name                                     AS driver_name,
        d.status                                   AS driver_status,
        d.rating                                   AS profile_rating,
        COUNT(t.trip_id)                           AS total_trips,
        SUM(CASE WHEN t.status = 'completed'  THEN 1 ELSE 0 END) AS completed_trips,
        SUM(CASE WHEN t.status = 'cancelled'  THEN 1 ELSE 0 END) AS cancelled_trips,
        ROUND(SUM(t.fare), 2)                      AS total_earnings,
        ROUND(AVG(t.fare), 2)                      AS avg_fare,
        ROUND(AVG(r.driver_rating), 2)             AS avg_passenger_rating
    FROM Drivers d
    LEFT JOIN Trips   t ON d.driver_id  = t.driver_id
    LEFT JOIN Ratings r ON t.trip_id    = r.trip_id
    GROUP BY d.driver_id, d.name, d.status, d.rating
)
SELECT
    driver_id,
    driver_name,
    driver_status,
    profile_rating,
    total_trips,
    completed_trips,
    cancelled_trips,
    ROUND(
        CASE WHEN total_trips > 0
             THEN cancelled_trips * 100.0 / total_trips
             ELSE 0 END, 2
    )                                              AS cancellation_rate_pct,
    total_earnings,
    avg_fare,
    avg_passenger_rating,
    -- Rank drivers by total earnings within their status group
    RANK() OVER (
        PARTITION BY driver_status
        ORDER BY total_earnings DESC
    )                                              AS earnings_rank_in_status
FROM DriverStats
ORDER BY total_earnings DESC;
 
