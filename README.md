# 🏡 Nashville Housing Data Cleaning Project (SQL Server)

This project focuses on cleaning and transforming real-world housing data from Nashville, Tennessee using **SQL Server Management Studio (SSMS)**. The dataset contains property records such as parcel information, sales data, and property features.

The project demonstrates the power of SQL in handling raw, semi-structured datasets, and preparing them for downstream analysis or reporting.

---

## 📁 Files Included

| File | Description |
|------|-------------|
| `Nashville Housing Data.xlsx` | Raw housing dataset |
| `Data_Cleaning.sql` | SQL script used to clean and structure the data |

---

## 📊 Dataset Overview

- **Rows**: 56,477
- **Columns**: 19
- **Source**: Public property records from Nashville

### Key Fields:
- `ParcelID`: Unique property identifier
- `SaleDate`: Date of property sale
- `SalePrice`: Transaction price
- `PropertyAddress`, `OwnerAddress`: Raw address data
- `LandUse`: Type of property (e.g., Single Family, Duplex)
- `YearBuilt`, `Bedrooms`, `FullBath`, `HalfBath`: Property characteristics
- `LandValue`, `BuildingValue`, `TotalValue`: Assessed property values

---

## 🧹 Data Cleaning Steps

All cleaning operations were performed in **SQL Server Management Studio (SSMS)** using T-SQL. Here are the actual transformations carried out:

### 1. 🗓️ Convert Sale Date
- `SaleDate` was originally stored as `DATETIME`
- A new column `SaleDateConverted` was added to store only the `DATE` portion

### 2. 🏷️ Fill Missing Property Addresses
- For records with missing `PropertyAddress`, values were filled using other records with the same `ParcelID` but a valid address

### 3. 🧱 Split Property Address into Columns
- `PropertyAddress` was split into two new columns:
  - `PropertySplitAddress`: Street address
  - `PropertySplitCity`: City name  
  (Using `SUBSTRING()` and `CHARINDEX()`)

### 4. 🧍 Split Owner Address into Columns
- `OwnerAddress` was split into:
  - `OwnerSplitAddress` (street)
  - `OwnerSplitCity` (city)
  - `OwnerSplitState` (state)
  (Using `REPLACE()` and `PARSENAME()` to parse comma-separated values)

### 5. 🧮 Normalize 'SoldAsVacant' Field
- Cleaned inconsistencies in the `SoldAsVacant` column
- Converted variations like `'Yes'`, `'No'`, `'Y'`, `'N'` into standard `'Yes'` and `'No'`

### 6. 🧼 Remove Duplicates
- Removed exact duplicate rows based on all relevant fields to ensure data integrity

### 7. ❌ Remove Unnecessary Columns
- After creating split address columns and cleaned values, the original columns (`PropertyAddress`, `OwnerAddress`, `SaleDate`) were no longer needed and were dropped from the final table

---

## 🛠 Tools & Technologies Used

- **SQL Server Management Studio (SSMS)** – for SQL querying and transformation
- **T-SQL (Transact-SQL)** – for all data manipulation and logic
- **Microsoft Excel** – original raw data source (imported into SQL Server)

---

## 👤 Contributor

- [Azim Nahin](https://github.com/AzimNahin)

---

## 📌 Project Outcome

After executing the cleaning steps, the dataset was successfully:
- Normalized and standardized
- Free of NULLs in critical fields
- Enriched with structured address fields
- Ready for reporting, visualization, or further analytics

This project demonstrates how SQL alone can handle robust data preparation workflows, especially when working with legacy or unstructured formats like raw Excel files.
