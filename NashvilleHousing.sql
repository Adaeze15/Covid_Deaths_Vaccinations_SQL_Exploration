Select *
From PortfolioProject.dbo.NashvilleHousing

---Updating the saleDate column----
Select SaleDate
From PortfolioProject.dbo.NashvilleHousing

---Adding a new column(SaleDateConverted) to table---
Alter table NashvilleHousing
Add SaleDateConverted Date;

----Updating the records in the new added column----
Update NashvilleHousing
Set SaleDateConverted = Convert(Date, SaleDate)

Select SaleDateConverted, Convert(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

---Working with property address column----
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is Null

Select *
From PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is Null

Select *
From PortfolioProject.dbo.NashvilleHousing
Order by ParcelID

Select *
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---Breaking out Address into individual columns(Address, City, State)
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address
From PortfolioProject.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
From PortfolioProject.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))AS Address
From PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter table NashvilleHousing
Add PropertySplitcity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',','.'),1)
,PARSENAME(Replace(OwnerAddress, ',','.'),2)
,PARSENAME(Replace(OwnerAddress, ',','.'),3)
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',','.'),3)
,PARSENAME(Replace(OwnerAddress, ',','.'),2)
,PARSENAME(Replace(OwnerAddress, ',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.'),3)

Alter table NashvilleHousing
Add OwnerSplitcity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitcity = PARSENAME(Replace(OwnerAddress, ',','.'),2)

Alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'),1)

Select *
From PortfolioProject.dbo.NashvilleHousing

---Changing Y and N to Yes and No in "Sold as Vacant" Column
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant	
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant	
order by 2

---Remove Duplicates---
WITH RowNumCTE AS(
Select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						) row_num

From PortfolioProject.dbo.NashvilleHousing
---Order By ParcelID
)
Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress

WITH RowNumCTE AS(
Select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						) row_num

From PortfolioProject.dbo.NashvilleHousing
---Order By ParcelID
)
Delete
From RowNumCTE
Where row_num >1
---Order by PropertyAddress

WITH RowNumCTE AS(
Select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						) row_num

From PortfolioProject.dbo.NashvilleHousing
---Order By ParcelID
)
Select *
FRom RowNumCTE
Where row_num >1
Order by PropertyAddress

----Deleting Unused Columns----
Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict,PropertyAddress,SaleDate

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate