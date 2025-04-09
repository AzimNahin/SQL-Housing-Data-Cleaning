-- Cleaning Data

SELECT *
FROM HousingDatabase..NashvilleHousing;

-- SaleDate is DateTime Column
-- Convert DateTime Column to Date Column

SELECT SaleDate, CONVERT(date,SaleDate) AS SaleDate
FROM HousingDatabase..NashvilleHousing;

-- Didn't Work
-- UPDATE HousingDatabase..NashvilleHousing
-- SET SaleDate = CONVERT(date,SaleDate);

ALTER TABLE HousingDatabase..NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE HousingDatabase..NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate);

SELECT SaleDate, SaleDateConverted
FROM HousingDatabase..NashvilleHousing;

-- Populate Property Address Data
-- Same Parcel Ids Have Same Property Address

SELECT COUNT(*)
FROM HousingDatabase..NashvilleHousing
WHERE PropertyAddress iS NULL;

SELECT h1.UniqueID, h1.ParcelID, h1.PropertyAddress, h2.UniqueID, h1.ParcelID, h2.PropertyAddress
FROM HousingDatabase..NashvilleHousing AS h1
JOIN HousingDatabase..NashvilleHousing AS h2
ON h1.ParcelID = h2.ParcelID
WHERE h1.PropertyAddress iS NULL
AND h2.PropertyAddress iS NOT NULL
ORDER BY h1.UniqueID;

UPDATE h1
SET h1.PropertyAddress = h2.PropertyAddress
FROM HousingDatabase..NashvilleHousing AS h1
JOIN HousingDatabase..NashvilleHousing AS h2
ON h1.ParcelID = h2.ParcelID
WHERE h1.PropertyAddress iS NULL
AND h2.PropertyAddress iS NOT NULL;


-- Breaking out Address into Individual Columns (Address, City, State)

--Property Address

SELECT PropertyAddress, 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) - 1) AS PropertySplitAddress,
TRIM(SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))) AS PropertySplitCity
FROM HousingDatabase..NashvilleHousing;

ALTER TABLE HousingDatabase..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

ALTER TABLE HousingDatabase..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE HousingDatabase..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) - 1);

UPDATE HousingDatabase..NashvilleHousing
SET PropertySplitCity = TRIM(SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)));

SELECT *
FROM HousingDatabase..NashvilleHousing;

-- Owner Address

SELECT OwnerAddress, 
REPLACE(OwnerAddress,',','.') AS ReplacedAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State
FROM HousingDatabase..NashvilleHousing
WHERE OwnerAddress IS NOT NULL; 

ALTER TABLE HousingDatabase..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

ALTER TABLE HousingDatabase..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

ALTER TABLE HousingDatabase..NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE HousingDatabase..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

UPDATE HousingDatabase..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

UPDATE HousingDatabase..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

SELECT *
FROM HousingDatabase..NashvilleHousing;

-- Change Y to Yes and N to No in SoldAsVacant

SELECT SoldAsVacant, COUNT(SoldAsVacant) AS Count
FROM HousingDatabase..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY Count;

SELECT SoldAsVacant, 
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
END AS SoldAsVacantUpdated
FROM HousingDatabase..NashvilleHousing;

UPDATE HousingDatabase..NashvilleHousing
SET SoldAsVacant =  
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
END;

SELECT SoldAsVacant, COUNT(SoldAsVacant) AS Count
FROM HousingDatabase..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY Count;

-- Remove Duplicates

SELECT *
FROM HousingDatabase..NashvilleHousing;

SELECT COUNT(*) -- 56477
FROM HousingDatabase..NashvilleHousing;

SELECT COUNT(DISTINCT UniqueID) -- 56477
FROM HousingDatabase..NashvilleHousing;

WITH RowCTE AS
(SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SaleDate,
			SalePrice,
			LegalReference
ORDER BY UniqueID) AS row_num
FROM HousingDatabase..NashvilleHousing)

DELETE 
FROM RowCTE
WHERE row_num > 1;

SELECT COUNT(*) -- 56373
FROM HousingDatabase..NashvilleHousing;

SELECT *
FROM HousingDatabase..NashvilleHousing;

-- Remove Unnecessary Columns

SELECT *
FROM HousingDatabase..NashvilleHousing;

ALTER TABLE HousingDatabase..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate;

SELECT *
FROM HousingDatabase..NashvilleHousing;
