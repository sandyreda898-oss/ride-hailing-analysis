SELECT
    (SELECT COUNT(*) FROM Users)   AS total_users,
    (SELECT COUNT(*) FROM Drivers) AS total_drivers,
    (SELECT COUNT(*) FROM Cars)    AS total_cars,
    (SELECT COUNT(*) FROM Trips)   AS total_trips,
    (SELECT COUNT(*) FROM Payments)AS total_payments,
    (SELECT COUNT(*) FROM Ratings) AS total_ratings;
 
 -- 1.2  Trip status breakdown
--      Shows how trips are distributed across statuses (completed, cancelled,
--      in-progress, etc.), giving an instant health check on operations.

SELECT
    status,
    COUNT(*)AS trip_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM Trips
GROUP BY status
ORDER BY trip_count DESC;
-- 1.3  Core trip metrics — average fare, distance, and duration
--      Baseline KPIs that describe the typical trip profile on the platform.
SELECT
    COUNT(*)                                       AS completed_trips,
    ROUND(AVG(fare),     2)                        AS avg_fare,
    ROUND(AVG(distance), 2)                        AS avg_distance_km,
    ROUND(AVG(CAST(DATEDIFF(MINUTE, start_time, end_time) AS FLOAT)), 1)
                                                   AS avg_duration_min,
    ROUND(MIN(fare),  2)                           AS min_fare,
    ROUND(MAX(fare),  2)                           AS max_fare,
    ROUND(MIN(distance), 2)                        AS min_distance_km,
    ROUND(MAX(distance), 2)                        AS max_distance_km
FROM Trips
WHERE status = 'completed'
  AND start_time IS NOT NULL
  AND end_time   IS NOT NULL;
 -- 1.3  Core trip metrics — average fare, distance, and duration
--      Baseline KPIs that describe the typical trip profile on the platform.


 SELECT
    COUNT(*)                                       AS completed_trips,
    ROUND(AVG(fare),     2)                        AS avg_fare,
    ROUND(AVG(distance), 2)                        AS avg_distance_km,
    ROUND(AVG(CAST(DATEDIFF(MINUTE, start_time, end_time) AS FLOAT)), 1)
                                                   AS avg_duration_min,
    ROUND(MIN(fare),  2)                           AS min_fare,
    ROUND(MAX(fare),  2)                           AS max_fare,
    ROUND(MIN(distance), 2)                        AS min_distance_km,
    ROUND(MAX(distance), 2)                        AS max_distance_km
FROM Trips
WHERE status = 'completed'
  AND start_time IS NOT NULL
  AND end_time   IS NOT NULL;
 
 
 -- 1.4  Busiest hours of the day
--      Counts trip requests grouped by hour to reveal demand patterns and
--      inform driver supply scheduling.
SELECT
    DATEPART(HOUR, request_time)   AS hour_of_day,
    COUNT(*)                       AS trip_requests,
    ROUND(AVG(fare), 2)            AS avg_fare
FROM Trips
GROUP BY DATEPART(HOUR, request_time)
ORDER BY trip_requests DESC;
-- 1.5  Busiest days of the week
--      Reveals which weekdays drive the most demand (1 = Sunday in SQL Server).
SELECT
    DATENAME(WEEKDAY, request_time) AS day_of_week,
    DATEPART(WEEKDAY, request_time) AS day_number,
    COUNT(*)                        AS trip_count,
    ROUND(SUM(fare), 2)             AS total_revenue
FROM Trips
WHERE status = 'completed'
GROUP BY DATENAME(WEEKDAY, request_time),
         DATEPART(WEEKDAY, request_time)
ORDER BY day_number;
-- 1.6  User registration growth over time (monthly)
--      Measures how the user base has grown month-by-month.
SELECT
    FORMAT(created_at, 'yyyy-MM')  AS registration_month,
    COUNT(*)                       AS new_users,
    SUM(COUNT(*)) OVER (
        ORDER BY FORMAT(created_at, 'yyyy-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                              AS cumulative_users
FROM Users
GROUP BY FORMAT(created_at, 'yyyy-MM')
ORDER BY registration_month;


