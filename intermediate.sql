-- Intermediate Level – Business Logic Queries
-- Join FactResellerSales with DimProduct to view sales by product.

create view vw_Sales_By_Product as
SELECT frs.TotalProductCost, frs.SalesAmount, dp.EnglishProductName
FROM FactResellerSales as frs JOIN DimProduct as dp
ON frs.ProductKey = dp.ProductKey;

-- Calculate total sales (SalesAmount) per year.
create view vw_Total_Sales_Per_Year as
SELECT 
    YEAR(OrderDate) AS SalesYear,
    SUM(SalesAmount) AS TotalSales
FROM FactResellerSales
WHERE YEAR(OrderDate) = 2011
GROUP BY YEAR(OrderDate);

-- ·  ·  Group sales by region (DimSalesTerritory).

create view vw_Sales_By_Region as
SELECT 
    dst.SalesTerritoryRegion,
    SUM(frs.SalesAmount) AS TotalSales
FROM FactResellerSales AS frs
JOIN DimSalesTerritory AS dst 
    ON frs.SalesTerritoryKey = dst.SalesTerritoryKey
GROUP BY dst.SalesTerritoryRegion
ORDER BY TotalSales DESC;


-- Show the top 5 best-selling products by quantity (OrderQuantity).
create view vw_Top5_Products_By_Quantity as
SELECT TOP 5 
    dp.EnglishProductName, 
    SUM(frs.OrderQuantity) AS OrderQuantity
FROM FactResellerSales AS frs 
JOIN DimProduct AS dp 
    ON frs.ProductKey = dp.ProductKey
GROUP BY dp.EnglishProductName 
ORDER BY OrderQuantity DESC;

-- Calculate gross margin per sale (SalesAmount - TotalProductCost).
create view vw_Gross_Margin_Per_Sale as
SELECT frs.SalesOrderNumber, frs.SalesAmount, frs.TotalProductCost,
(frs.SalesAmount - frs.TotalProductCost) as [Gross Margin]
from FactResellerSales as frs

-- Join FactResellerSales with DimReseller to display sales per reseller.
create view vw_Sales_By_Reseller as
Select dr.ResellerName, SUM(frs.SalesAmount) as TotalSales
from DimReseller as dr JOIN FactResellerSales as frs
on dr.ResellerKey = frs.ResellerKey
Group by dr.ResellerName
order by TotalSales desc

-- Count how many products exist per subcategory (DimProductSubcategory).
create view vw_Products_Per_Subcategory as
select dps.EnglishProductSubcategoryName , COUNT(dp.ProductKey) as ProductsSub
from DimProductSubcategory as dps JOIN DimProduct as dp
on dps.ProductSubcategoryKey = dp.ProductSubcategoryKey
group by dps.EnglishProductSubcategoryName
order by ProductsSub asc;

--Filter products with negative margins
create view vw_Negative_Margin_Products as
SELECT 
    dp.EnglishProductName,
    frs.SalesAmount,
    frs.TotalProductCost,
    (frs.SalesAmount - frs.TotalProductCost) AS GrossMargin
FROM FactResellerSales AS frs
JOIN DimProduct AS dp
    ON frs.ProductKey = dp.ProductKey
WHERE (frs.SalesAmount - frs.TotalProductCost) < 0;



    
