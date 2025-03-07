### Expanded Explanation of Issues and Resolutions

#### **Issue 1: Importing the Excel File**

**Error Message**: _The 'Microsoft.ACE.OLEDB.16.0' provider is not registered on the local machine._

##### **Cause**:

This error occurs because the required Microsoft Access Database Engine driver is not installed or is incompatible with the system architecture (32-bit vs 64-bit). SQL Server relies on these drivers to import Excel files.

##### **Attempts to Resolve**:

- Installing the Access Database Engine did not work, likely due to conflicts between 32-bit and 64-bit Office installations or improper installation steps.
- As a workaround, Excel files were converted to CSV format, which bypasses the need for the OLEDB provider.

##### **Workaround Details**:

- Excel files were exported as CSV files using either Excel's _Save As_ functionality or Google Sheets for conversion. This ensured compatibility with SQL Server's import functionality[3][7].

##### **Recommended Fix**:

To resolve this issue permanently:

1. Download the Microsoft Access Database Engine 2016 Redistributable from Microsoft's official website[1].
2. Install the correct version (32-bit or 64-bit) based on your system architecture using the command:
   ```bash
   AccessDatabaseEngine.exe /quiet
   ```
   This installs the driver silently without UI prompts[1][2][8].
3. Ensure compatibility between Office versions and system architecture (e.g., uninstall conflicting Office components if necessary)[2].

---

#### **Issue 2: SQL Query Failure Due to Incorrect Data Type**

**Error Message**: _The varchar column "adr" cannot be multiplied with a number._

##### **Cause**:

The `adr` column, which stores Average Daily Rate values, was defined as `VARCHAR`. SQL Server cannot perform mathematical operations on text-based columns, leading to this error when attempting to calculate revenue.

##### **Resolution**:

To fix this issue, the column's data type was permanently altered from `VARCHAR` to `DECIMAL(10,2)` in all three tables (2018, 2019, and 2020). This change ensures accurate calculations without requiring constant data type conversions in queries.

**Code Used**:

```sql
ALTER TABLE [Projects].[dbo].[2018] ALTER COLUMN adr DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2019] ALTER COLUMN adr DECIMAL(10,2);
ALTER TABLE [Projects].[dbo].[2020] ALTER COLUMN adr DECIMAL(10,2);
```

##### **Impact of Change**:

- The column now stores numeric values directly, allowing mathematical operations such as multiplication.
- Queries calculating revenue (e.g., `(stays_in_week_nights + stays_in_weekend_nights) * adr`) now execute correctly without requiring casting or formatting functions[6][9].

##### **Additional Adjustment**:

A formatting issue necessitated dividing the calculated revenue by 10 in subsequent queries. This likely arose due to incorrect scaling during data type conversion or earlier data inconsistencies.

---

#### **Issue 3: Handling Non-Numeric Data During Conversion**

When altering a column from `VARCHAR` to `DECIMAL`, non-numeric values can cause errors during conversion.

##### **Resolution**:

To ensure smooth conversion:

1. Identify problematic rows using queries like:
   ```sql
   SELECT * FROM table_name WHERE TRY_CONVERT(DECIMAL(10,2), adr) IS NULL;
   ```
   Rows with non-numeric values will return NULL.
2. Clean up data by replacing invalid values with defaults (e.g., `0`) or removing them entirely[5][10].

---

### Summary of Findings and Fixes

1. **Excel Import Issue**: The workaround of converting Excel files to CSV successfully bypassed the OLEDB provider error. Permanent resolution requires installing the correct Access Database Engine driver.
2. **SQL Query Failure Due to Data Type**: Altering the `adr` column to `DECIMAL(10,2)` resolved mathematical operation errors and improved query performance.
3. **Data Cleanup During Conversion**: Using `TRY_CONVERT` ensures that non-numeric values are identified and handled appropriately during column type changes.

These fixes improved data usability and ensured seamless execution of SQL queries for exploratory analysis and reporting.
