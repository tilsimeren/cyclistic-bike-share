-- ============================================
-- Title: Bike Share Data Analysis
-- Description: SQL scripts for combining, cleaning, and analyzing bike share data.
-- Author: Tılsım
-- Date: 2025-01-21
-- ============================================

-- Step 1: Combine all 12 months (FY) data into one table
CREATE TABLE 2023_FY_tripdata AS
SELECT * FROM bike_share.2023_01_tripdata
UNION ALL
SELECT * FROM bike_share.2023_02_tripdata
UNION ALL
SELECT * FROM bike_share.2023_03_tripdata
-- Added remaining months similarly to above structure
;

-- Step 2: Identify and handle data quality issues

-- Check for null and missing values
SELECT * 
FROM 2023_FY_tripdata
WHERE ride_length IS NULL OR day_of_week IS NULL;

-- Check for duplicates
SELECT ride_id, COUNT(*)
FROM 2023_FY_tripdata
GROUP BY ride_id
HAVING COUNT(*) > 1;

-- Check for negative or zero ride lengths
SELECT * 
FROM 2023_FY_tripdata
WHERE ride_length <= TIME '00:00:00';

-- Step 3: Clean data by removing duplicates and invalid ride lengths
SELECT DISTINCT *
FROM 2023_FY_tripdata
WHERE ride_length > TIME '00:00:00';

-- Step 4: Add day names to the dataset
SELECT *,
    CASE
        WHEN day_of_week = 1 THEN 'Sunday'
        WHEN day_of_week = 2 THEN 'Monday'
        WHEN day_of_week = 3 THEN 'Tuesday'
        WHEN day_of_week = 4 THEN 'Wednesday'
        WHEN day_of_week = 5 THEN 'Thursday'
        WHEN day_of_week = 6 THEN 'Friday'
        WHEN day_of_week = 7 THEN 'Saturday'
    END AS day_name
FROM 2023_FY_tripdata;

-- ============================================
-- ANALYSIS QUERIES
-- ============================================

-- Daily Patterns
SELECT 
    member_casual,
    COUNT(*) AS total_rides,
    AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS avg_ride_minutes,
    day_name,
    COUNT(*) AS rides_per_day
FROM 2023_FY_tripdata
GROUP BY member_casual, day_name
ORDER BY member_casual, rides_per_day DESC;

-- Peak Usage Times
SELECT 
    member_casual,
    EXTRACT(HOUR FROM started_at) AS hour_of_day,
    COUNT(*) AS number_of_rides
FROM 2023_FY_tripdata
GROUP BY member_casual, hour_of_day
ORDER BY member_casual, hour_of_day;

-- Popular Routes and Stations
SELECT 
    member_casual,
    start_station_name,
    COUNT(*) AS station_usage
FROM 2023_FY_tripdata
WHERE start_station_name IS NOT NULL
GROUP BY member_casual, start_station_name
ORDER BY member_casual, station_usage DESC;

-- Seasonal Usage
SELECT 
    member_casual,
    EXTRACT(MONTH FROM started_at) AS month,
    COUNT(*) AS rides_per_month
FROM 2023_FY_tripdata
GROUP BY member_casual, month
ORDER BY member_casual, month;

-- Average Ride Duration by Hour
SELECT 
    member_casual,
    EXTRACT(HOUR FROM started_at) AS hour_of_day,
    AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS avg_duration_minutes,
    COUNT(*) AS number_of_rides
FROM 2023_FY_tripdata
GROUP BY member_casual, hour_of_day
ORDER BY member_casual, hour_of_day;

-- Weekend vs. Weekday Usage
SELECT 
    member_casual,
    CASE 
        WHEN day_name IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_rides,
    AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS avg_ride_minutes
FROM 2023_FY_tripdata
GROUP BY member_casual, day_type
ORDER BY member_casual, day_type;

-- Round Trip Analysis
SELECT 
    member_casual,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN start_station_name = end_station_name THEN 1 ELSE 0 END) AS round_trips,
    ROUND(SUM(CASE WHEN start_station_name = end_station_name THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS round_trip_percentage
FROM 2023_FY_tripdata
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
GROUP BY member_casual;

-- Most Popular Station Pairs
SELECT 
    member_casual,
    start_station_name,
    end_station_name,
    COUNT(*) AS route_count
FROM 2023_FY_tripdata
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
GROUP BY member_casual, start_station_name, end_station_name
HAVING route_count > 100
ORDER BY member_casual, route_count DESC;

-- User Behavior During Peak vs. Off-Peak Hours
SELECT 
    member_casual,
    CASE 
        WHEN EXTRACT(HOUR FROM started_at) BETWEEN 7 AND 9 
            OR EXTRACT(HOUR FROM started_at) BETWEEN 16 AND 18 THEN 'Peak Hours'
        ELSE 'Off-Peak Hours'
    END AS time_category,
    COUNT(*) AS total_rides,
    AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS avg_ride_minutes
FROM 2023_FY_tripdata
GROUP BY member_casual, time_category
ORDER BY member_casual, time_category;

-- Short vs. Long Rides Analysis
SELECT 
    member_casual,
    CASE 
        WHEN TIME_DIFF(ride_length, TIME '00:00:00', MINUTE) < 10 THEN 'Very Short (<10min)'
        WHEN TIME_DIFF(ride_length, TIME '00:00:00', MINUTE) < 30 THEN 'Short (10-30min)'
        WHEN TIME_DIFF(ride_length, TIME '00:00:00', MINUTE) < 60 THEN 'Medium (30-60min)'
        ELSE 'Long (>60min)'
    END AS ride_duration_category,
    COUNT(*) AS number_of_rides,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY member_casual), 2) AS percentage
FROM `MyBigQueryProjectName.bike_share.2023_01_tripdata`
GROUP BY member_casual, ride_duration_category
ORDER BY member_casual, ride_duration_category;
