-- Create 'hotels' table for easier access and analysis

WITH hotels AS(
SELECT * FROM [Projects].[dbo].[2018]
UNION
SELECT * FROM [Projects].[dbo].[2019]
UNION
SELECT * FROM [Projects].[dbo].[2020])

SELECT * FROM hotels

-- Q1: Is our hotel revenue growing yearly?
-- Q1-A: The revenue grew significantly between 2018 and 2019, however between 2019 and 2020, the revenue dropped by approximately 29%. In 2018, the total revenue was approx. $3.72 Million. In 2019, $15.27 Million. In 2020, $10.85 Million. 

-- Alter adr from VARCHAR to DECIMAL

ALTER TABLE [Projects].[dbo].[2018] 
ALTER COLUMN adr DECIMAL(10,2);

ALTER TABLE [Projects].[dbo].[2019] 
ALTER COLUMN adr DECIMAL(10,2);

ALTER TABLE [Projects].[dbo].[2020] 
ALTER COLUMN adr DECIMAL(10,2);


-- Derive revenue values from adr (average daily rate), stays_in_week_nights, and stays_in_weekend_nights. 

WITH hotels AS(
    SELECT * FROM [Projects].[dbo].[2018]
    UNION
    SELECT * FROM [Projects].[dbo].[2019]
    UNION
    SELECT * FROM [Projects].[dbo].[2020]
)

SELECT
arrival_date_year,
    SUM(((stays_in_week_nights + stays_in_weekend_nights) * adr / 10)) as revenue 
FROM hotels
GROUP BY arrival_date_year

-- Q2: Should we increase our parking lot size?

-- Q3: What trands can we see in the data

-- Q4: Which market segments contribute most to our revenue?

-- Q5: What is the average length of stay, and how does it affect revenue?

-- Q6: What are the booking patterns and cancellation rates throughout the year?