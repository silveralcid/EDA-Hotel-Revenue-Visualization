-- Create 'hotels' table for easier access and analysis

WITH hotels AS(
SELECT * FROM [Projects].[dbo].[2018]
UNION
SELECT * FROM [Projects].[dbo].[2019]
UNION
SELECT * FROM [Projects].[dbo].[2020])

SELECT * FROM hotels