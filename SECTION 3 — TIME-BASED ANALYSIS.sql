USE ride_hailing;
-- 3.1  Peak hours — demand and revenue heat map by hour
--      Combines trip volume with revenue to find true peak value windows,
--      not just busy periods.
SELECT
    DATEPART(HOUR, request_time)                AS hour_of_day,
    COUNT(*)                                    AS trip_count,
    ROUND(SUM(fare), 2)                         AS hourly_revenue,
    ROUND(AVG(fare), 2)                         AS avg_fare,
    -- Classify each hour bucket
    CASE
        WHEN DATEPART(HOUR, request_time) BETWEEN 7  AND 9  THEN 'Morning Rush'
        WHEN DATEPART(HOUR, request_time) BETWEEN 12 AND 14 THEN 'Lunch Hour'
        WHEN DATEPART(HOUR, request_time) BETWEEN 17 AND 20 THEN 'Evening Rush'
        WHEN DATEPART(HOUR, request_time) BETWEEN 21 AND 23 THEN 'Night Life'
        WHEN DATEPART(HOUR, request_time) BETWEEN 0  AND 5  THEN 'Late Night'
        ELSE 'Off-Peak'
    END                                         AS period_label,
    RANK() OVER (ORDER BY COUNT(*) DESC)        AS demand_rank
FROM Trips
WHERE status = 'completed'
GROUP BY DATEPART(HOUR, request_time)
ORDER BY hour_of_day;
 
-- 3.2  Trip duration analysis — distribution by bucket
--      Segments trips into duration bands to understand the dominant trip
--      length and inform pricing/distance models.
WITH TripDurations AS (
    SELECT
        trip_id,
        fare,
        distance,
        DATEDIFF(MINUTE, start_time, end_time)  AS duration_min
    FROM Trips
    WHERE status   = 'completed'
      AND start_time IS NOT NULL
      AND end_time   IS NOT NULL
)
SELECT
    CASE
        WHEN duration_min <= 5              THEN '0-5 min'
        WHEN duration_min BETWEEN 6  AND 15 THEN '6-15 min'
        WHEN duration_min BETWEEN 16 AND 30 THEN '16-30 min'
        WHEN duration_min BETWEEN 31 AND 60 THEN '31-60 min'
        ELSE '60+ min'
    END                                      AS duration_bucket,
    COUNT(*)                                 AS trip_count,
    ROUND(AVG(fare),     2)                  AS avg_fare,
    ROUND(AVG(distance), 2)                  AS avg_distance_km,
    ROUND(AVG(CAST(duration_min AS FLOAT)), 1) AS avg_duration_min
FROM TripDurations
GROUP BY
    CASE
        WHEN duration_min <= 5              THEN '0-5 min'
        WHEN duration_min BETWEEN 6  AND 15 THEN '6-15 min'
        WHEN duration_min BETWEEN 16 AND 30 THEN '16-30 min'
        WHEN duration_min BETWEEN 31 AND 60 THEN '31-60 min'
        ELSE '60+ min'
    END
ORDER BY MIN(duration_min);
 
