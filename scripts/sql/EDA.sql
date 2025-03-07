-- Create a unified 'hotels' table for easier access and analysis
WITH hotels AS (
    SELECT * FROM [Projects].[dbo].[2018]
    UNION
    SELECT * FROM [Projects].[dbo].[2019]
    UNION
    SELECT * FROM [Projects].[dbo].[2020]
)
SELECT * FROM hotels;

-- Q1: Is our hotel revenue growing yearly?
-- Q1-A: Revenue grew significantly between 2018 and 2019 but dropped by ~29% in 2020.
--       - 2018: ~$3.72 Million
--       - 2019: ~$15.27 Million
--       - 2020: ~$10.85 Million

-- Alter 'adr' column type from VARCHAR to DECIMAL for accurate calculations
ALTER TABLE [Projects].[dbo].[2018] ALTER COLUMN adr DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2019] ALTER COLUMN adr DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2020] ALTER COLUMN adr DECIMAL(10,2);

-- Deriving revenue from adr (average daily rate), stays_in_week_nights, and stays_in_weekend_nights
WITH hotels AS (
    SELECT * FROM [Projects].[dbo].[2018]
    UNION
    SELECT * FROM [Projects].[dbo].[2019]
    UNION
    SELECT * FROM [Projects].[dbo].[2020]
)
SELECT
    arrival_date_year,
    SUM((stays_in_week_nights + stays_in_weekend_nights) * adr) AS revenue 
FROM hotels
GROUP BY arrival_date_year;

-- Q2: Should we increase our parking lot size?
-- Alter stays_in_week_nights and stays_in_weekend_nights to DECIMAL for accurate calculations
ALTER TABLE [Projects].[dbo].[2018] ALTER COLUMN stays_in_week_nights DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2018] ALTER COLUMN stays_in_weekend_nights DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2019] ALTER COLUMN stays_in_week_nights DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2019] ALTER COLUMN stays_in_weekend_nights DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2020] ALTER COLUMN stays_in_week_nights DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2020] ALTER COLUMN stays_in_weekend_nights DECIMAL(10,2);

-- Compute parking utilization percentage
WITH hotels AS (
    SELECT * FROM [Projects].[dbo].[2018]
    UNION
    SELECT * FROM [Projects].[dbo].[2019]
    UNION
    SELECT * FROM [Projects].[dbo].[2020]
)
SELECT
    arrival_date_year,
    hotel,
    SUM((stays_in_week_nights + stays_in_weekend_nights) * adr) AS revenue,
    CONCAT(ROUND((SUM(required_car_parking_spaces) / SUM(stays_in_week_nights + stays_in_weekend_nights)) * 100, 2), '%') 
    AS parking_percentage
FROM hotels
GROUP BY arrival_date_year, hotel;

-- Q2-A: Parking utilization has not exceeded 3.9% in the last three years. No need for expansion.

-- Q3: What trends can we observe in the data?
-- Before visualization, prepare the SQL queries by joining market segment and meal cost tables
WITH hotels AS (
    SELECT * FROM [Projects].[dbo].[2018]
    UNION
    SELECT * FROM [Projects].[dbo].[2019]
    UNION
    SELECT * FROM [Projects].[dbo].[2020]
)
SELECT * FROM hotels
LEFT JOIN dbo.[market-segment] ON hotels.market_segment = [market-segment].market_segment
LEFT JOIN dbo.[meal-cost] ON [meal-cost].meal = hotels.meal;
