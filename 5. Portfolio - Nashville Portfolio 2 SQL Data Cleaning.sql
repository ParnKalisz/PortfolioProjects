--Cleaning Data in SQL Queries
SELECT *
FROM [Data Base Portflio]..NashvilleHousing


--Standarize Data Format
SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM [Data Base Portflio]..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)


-- Populate Property Address Data
SELECT *
FROM [Data Base Portflio]..NashvilleHousing
WHERE PropertyAddress is null

--JOIN TO do not have duplicates
SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) /*A new column with filled NULLS for Property Address*/
FROM [Data Base Portflio]..NashvilleHousing a
JOIN [Data Base Portflio]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	-- IF PARCELID are the same but UNIQUEID are different, other columns will be populated 
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- WE UPDATE NULLS for column PROPERTY ADDRESS
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Data Base Portflio]..NashvilleHousing a
JOIN [Data Base Portflio]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- Breaking out Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM [Data Base Portflio]..NashvilleHousing

SELECT
--SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as ADDRESS /* The SQL will go thorugh PropertyAddress till to meet first ',' after that rest of values will be deleted */
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address -- Every address is differently long, so I want to have specific address

FROM [Data Base Portflio]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT*
FROM [Data Base Portflio]..NashvilleHousing

SELECT OwnerAddress
From [Data Base Portflio]..NashvilleHousing

--Sepearte one column into three sepearet
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From [Data Base Portflio]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--Change Y and N to YTes and No in "Sold as Vacant field

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM [Data Base Portflio]..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM [Data Base Portflio]..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID
	) row_num
FROM [Data Base Portflio]..NashvilleHousing
--ORDER BY ParcelID
)
SELECT*
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--DELTE DUPLICATES
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID
	) row_num
FROM [Data Base Portflio]..NashvilleHousing
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


-- DELETE UNUSED COLUMNS
SELECT *
FROM [Data Base Portflio]..NashvilleHousing

ALTER TABLE [Data Base Portflio]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Data Base Portflio]..NashvilleHousing
DROP COLUMN SaleDate
