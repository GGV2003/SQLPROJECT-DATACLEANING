-- DATA CLEANING USING SQL (HOUSING DATA)

SELECT * FROM PortfolioProject..Housing

-- Standardizing Date format

SELECT SalesDateConverted, CONVERT(date,SaleDate)AS DATEOFSALES
FROM PortfolioProject..Housing

--UPDATE PortfolioProject..Housing
--SET SaleDate =  CONVERT(date,SaleDate)

ALTER TABLE PortfolioProject..Housing
ADD SalesDateConverted Date;

UPDATE PortfolioProject..Housing
SET SalesDateConverted = CONVERT(date,SaleDate)


--Populate Property Address data 

SELECT *
FROM PortfolioProject.dbo.Housing
WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.Housing a
JOIN PortfolioProject.dbo.Housing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null













UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.Housing a
JOIN PortfolioProject.dbo.Housing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null


--Breaking down address into Individual columns (Address,City,State)

SELECT PropertyAddress 
FROM PortfolioProject.dbo.Housing

SELECT SUBSTRING(OwnerAddress, 1, CHARINDEX(',', PropertyAddress)) as ADDRESS

FROM PortfolioProject.dbo.Housing





SELECT OwnerAddress
FROM PortfolioProject.dbo.Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) AS LOCAL_ADDRESS
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)AS CITY
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)AS STATE
FROM PortfolioProject.dbo.Housing



--CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD

SELECT Distinct(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.Housing
GROUP BY SoldAsVacant

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	   WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.Housing

UPDATE Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END


--Removing Duplicates
WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				  UniqueID
				  )
				  row_num
FROM PortfolioProject.dbo.Housing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


--DELETING UNUSED COLUMNS 

SELECT * FROM PortfolioProject.dbo.Housing

ALTER TABLE PortfolioProject.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
























