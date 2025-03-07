# Hotel Booking Data Analysis

## Introduction

This project analyzes hotel booking data to extract insights on revenue trends, parking capacity, and other business metrics. The analysis utilizes SQL Server Management Studio (SSMS) for database management, SQL for data querying, and Power BI for data visualization.

## Tools Used

- **SQL Server Management Studio (SSMS)**
- **SQL**
- **Power BI**

## Methodology

### 1. Database Creation

- Created a database in SSMS to store hotel booking data.
- Imported data from Excel sheets for the years 2018, 2019, and 2020.

### 2. Data Querying and Analysis

- Used SQL queries to fetch and combine data from different years.
- Conducted exploratory data analysis (EDA) to address business questions, such as revenue growth.

### 3. Integration with Power BI

- Connected SQL database to Power BI.
- Preprocessed data using SQL joins with market segment and meal cost tables.

### 4. Data Visualization

- Created visualizations to highlight trends, including:
  - Revenue trends over time.
  - Parking lot capacity utilization.
  - Average daily rates (ADR) and booking patterns.

## Findings

### 1. Revenue Trends

- Revenue increased from 2018 to 2019 but declined in 2020.
- City hotels exhibited more stable revenue compared to resort hotels.

### 2. Parking Lot Capacity

- No immediate need to expand parking capacity, as utilization remained below 4%.

### 3. Other Trends

- ADR increased in 2020, but total nights booked declined.
- Discounts varied across market segments, influencing revenue fluctuations.

## Conclusion

SQL and Power BI proved valuable in analyzing hospitality data. Key insights include revenue fluctuations and parking capacity sufficiency. Future work could explore seasonal trends and customer demographics for enhanced decision-making.

## Future Work

- Analyze seasonal variations in bookings.
- Integrate additional data sources, such as customer feedback.
- Examine local events' impact on booking trends.

---

## SQL Queries for Exploratory Analysis

### 1. Creating a Unified `hotels` Table

```sql
WITH hotels AS (
    SELECT * FROM [Projects].[dbo].[2018]
    UNION
    SELECT * FROM [Projects].[dbo].[2019]
    UNION
    SELECT * FROM [Projects].[dbo].[2020]
)
SELECT * FROM hotels;
```

**Purpose**: Combines data from all years for easier analysis.

### 2. Revenue Growth Analysis

```sql
ALTER TABLE [Projects].[dbo].[2018] ALTER COLUMN adr DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2019] ALTER COLUMN adr DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2020] ALTER COLUMN adr DECIMAL(10,2);

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
```

**Findings**:

- **2018**: $3.72M revenue.
- **2019**: $15.27M revenue.
- **2020**: $10.85M revenue (29% decrease).

### 3. Parking Lot Capacity Analysis

```sql
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
```

**Findings**:

- Parking usage never exceeded **3.9%** over three years.
- No need for expansion at present.

### 4. Data Joining for Further Analysis

```sql
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
```

**Purpose**: Prepares data for Power BI analysis by linking market segment and meal cost data.

---

## Issue Resolution

### **Issue 1: Importing Excel File**

**Error Message**: _The 'Microsoft.ACE.OLEDB.16.0' provider is not registered._

#### **Fix**:

1. Convert Excel files to CSV format.
2. Install the correct **Access Database Engine**.
3. Ensure Office and SQL Server architecture compatibility.

---

### **Issue 2: SQL Query Failure Due to Data Type**

**Error**: _VARCHAR column "adr" cannot be multiplied with a number._

#### **Fix**:

Converted `adr` column to `DECIMAL(10,2)` in all tables:

```sql
ALTER TABLE [Projects].[dbo].[2018] ALTER COLUMN adr DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2019] ALTER COLUMN adr DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2020] ALTER COLUMN adr DECIMAL(10,2);
```

---

### **Issue 3: Handling Non-Numeric Data in Conversion**

**Problem**: Converting VARCHAR to DECIMAL fails if non-numeric data exists.

#### **Fix**:

Identified problematic rows using:

```sql
SELECT * FROM table_name WHERE TRY_CONVERT(DECIMAL(10,2), adr) IS NULL;
```

Then, cleaned up invalid entries before conversion.

---

## Summary

- **SQL and Power BI** enabled data-driven decisions for hotel management.
- **Revenue trends** showed a drop in 2020 after growth in 2019.
- **Parking capacity** remains sufficient based on usage data.
- **Data cleaning** was essential for accurate calculations and reporting.

Future work will involve seasonal trend analysis and demographic insights to further optimize business strategies.
