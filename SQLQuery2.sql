-- Data Cleaning Code


-- Select all items of the database

Select *
From SQLProject2..NashvilleHousing


--See the Saledate and change it to only date not containing the time

Select SaleDateConverted, Convert(date, SaleDate) as OnlySaleDate
From SQLProject2..NashvilleHousing


-- Change saleDate to OnlySaleDate [DOESN'T WORK]

Update NashvilleHousing
Set SaleDate = Convert(date, SaleDate)


--Create an alternate table

Alter table NashvilleHousing
Add SaleDateConverted Date;

-- Update the table 

Update NashvilleHousing
Set SaleDateConverted = Convert(date, SaleDate)

--Address Change trial

Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From SQLProject2..NashvilleHousing a
Join SQLProject2..NashvilleHousing b
on a.parcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null 

-- address change update
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From SQLProject2..NashvilleHousing a
Join SQLProject2..NashvilleHousing b
on a.parcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null 

-- Address splitting by Address, City

Select PropertyAddress,Substring(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1) as address,
Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+ 1  , LEN(PropertyAddress)) as City
From SQLProject2..NashvilleHousing

--Add the changed address tables

--Create an alternate table

Alter table NashvilleHousing
Add ChangedAddress nvarchar(255);

-- Update the table 

Update NashvilleHousing
Set ChangedAddress = Substring(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1)

--Create an alternate table

Alter table NashvilleHousing
Add ChangedCity nvarchar(255);

-- Update the table 

Update NashvilleHousing
Set ChangedCity = Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+ 1  , LEN(PropertyAddress))

--Select Owner Address to do Operations

Select OwnerAddress
From SQLProject2..NashvilleHousing

-- Using ParseName to split owner address [EASIER VERSION OF SUBSTRING]

Select PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
From SQLProject2..NashvilleHousing

--Main Operation by altering the tables

--Create an alternate table op1

Alter table NashvilleHousing
Add OwnerAddressConverted nvarchar(255);

-- Update the table 

Update NashvilleHousing
Set OwnerAddressConverted = PARSENAME(Replace(OwnerAddress,',','.'),3)

--Create an alternate table op2

Alter table NashvilleHousing
Add OwnerCityConverted nvarchar(255);

-- Update the table 

Update NashvilleHousing
Set OwnerCityConverted = PARSENAME(Replace(OwnerAddress,',','.'),2)

--Create an alternate table op3

Alter table NashvilleHousing
Add OwnerStateConverted nvarchar(255);

-- Update the table 

Update NashvilleHousing
Set OwnerStateConverted = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select * 
From SQLProject2..NashvilleHousing

--Yes and No count

Select Distinct(SoldAsVacant),Count(SoldAsVacant) 
From SQLProject2..NashvilleHousing
Group By SoldAsVacant
Order By 2

--Update the table

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 END
From SQLProject2..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant  = Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 END 

-- Finding Duplicates

Select *, ROW_NUMBER() over
(Partition By ParcelID,
			  PropertyAddress,
			  SaleDate,
			  SalePrice,
			  LegalReference
			  Order By 
			  UniqueID) row_num
From SQLProject2..NashvilleHousing
Order By ParcelID

-- Select and see the values

With RowNumCTE 
As
(
Select *, ROW_NUMBER() over
(Partition By ParcelID,
			  PropertyAddress,
			  SaleDate,
			  SalePrice,
			  LegalReference
			  Order By 
			  UniqueID) row_num
From SQLProject2..NashvilleHousing
--Order By ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order By ParcelID

--Delete the values

With RowNumCTE 
As
(
Select *, ROW_NUMBER() over
(Partition By ParcelID,
			  PropertyAddress,
			  SaleDate,
			  SalePrice,
			  LegalReference
			  Order By 
			  UniqueID) row_num
From SQLProject2..NashvilleHousing
--Order By ParcelID
)

Delete 
From RowNumCTE
Where row_num > 1
--Order By ParcelID

--Delete Unused Columns

Select *
From SQLProject2..NashvilleHousing

Alter Table NashvilleHousing
Drop Column PropertyAddress, OwnerAddress, TaxDistrict

Alter Table NashvilleHousing
Drop Column SaleDate




