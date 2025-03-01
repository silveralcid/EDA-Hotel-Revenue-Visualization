-- Create 'hotels' table for easier access and analysis

WITH hotels AS(
SELECT * FROM [Projects].[dbo].[2018]
UNION
SELECT * FROM [Projects].[dbo].[2019]
UNION
SELECT * FROM [Projects].[dbo].[2020])

SELECT * FROM hotels

-- Q1: Is our hotel revenue growing yearly?

-- Derive revenue values from adr (average daily rate), stays_in_week_nights, and stays_in_weekend_nights. 

WITH hotels AS(
    SELECT * FROM [Projects].[dbo].[2018]
    UNION
    SELECT * FROM [Projects].[dbo].[2019]
    UNION
    SELECT * FROM [Projects].[dbo].[2020]
)

SELECT FORMAT((stays_in_week_nights + stays_in_weekend_nights) * CAST(adr AS DECIMAL(10,2)), 'N2') as revenue 
FROM hotels

-- Q2: Should we increase our parking lot size?

-- Q3: What trands can we see in the data

-- Q4: Which market segments contribute most to our revenue?

-- Q5: What is the average length of stay, and how does it affect revenue?

-- Q6: What are the booking patterns and cancellation rates throughout the year?