-- Advanced Level – Analytical Queries

--   Calculate monthly sales growth year over year. 

create view vw_Monthly_YoY_Growth as
WITH MonthlySales AS (
    SELECT
        YEAR(OrderDate) AS SalesYear,
        MONTH(OrderDate) AS SalesMonth,
        SUM(SalesAmount - TotalProductCost) AS NetSales
    FROM FactResellerSales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
MonthlyGrowth AS (
    SELECT
        SalesYear,
        SalesMonth,
        NetSales,
        LAG(NetSales) OVER (PARTITION BY SalesMonth ORDER BY SalesYear) AS PrevYearNetSales
    FROM MonthlySales
)
SELECT
    SalesYear,
    SalesMonth,
    NetSales,
    PrevYearNetSales,
    CASE 
        WHEN PrevYearNetSales IS NULL THEN NULL
        ELSE ROUND(((NetSales - PrevYearNetSales) * 100.0) / PrevYearNetSales, 2)
    END AS YoYGrowthPercent
FROM MonthlyGrowth
ORDER BY SalesYear, SalesMonth;


-- Get average sales and standard deviation per category.

create view vw_Avg_StdDev_Per_Category as
SELECT 
    dpc.EnglishProductCategoryName AS CategoryName,
    AVG(frs.SalesAmount) AS AvgSales,
    STDEV(frs.SalesAmount) AS SalesStdDev
FROM FactResellerSales AS frs
JOIN DimProduct AS dp ON frs.ProductKey = dp.ProductKey
JOIN DimProductSubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
JOIN DimProductCategory AS dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
GROUP BY dpc.EnglishProductCategoryName
ORDER BY AvgSales DESC;

-- Ventas por SubCategoria 'Mountain Bikes'

create view vw_Mountain_Bikes_Sales as
SELECT 
    dpc.EnglishProductCategoryName AS Category,
    dps.EnglishProductSubcategoryName AS Subcategory,
    SUM(frs.SalesAmount) AS TotalSales
FROM FactResellerSales AS frs
JOIN DimProduct AS dp ON frs.ProductKey = dp.ProductKey
JOIN DimProductSubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
JOIN DimProductCategory AS dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
WHERE dpc.EnglishProductCategoryName = 'Bikes'
  AND dps.EnglishProductSubcategoryName = 'Mountain Bikes'
GROUP BY 
    dpc.EnglishProductCategoryName,
    dps.EnglishProductSubcategoryName;
    
-- Identify the region with the highest average margin.

create view vw_Highest_Margin_Region as
SELECT TOP 1
    st.SalesTerritoryRegion,
    ROUND(AVG(CAST((frs.SalesAmount - frs.TotalProductCost) AS FLOAT) / NULLIF(frs.SalesAmount, 0)), 4) AS AvgMargin
FROM FactResellerSales frs
JOIN DimSalesTerritory st ON frs.SalesTerritoryKey = st.SalesTerritoryKey
GROUP BY st.SalesTerritoryRegion
ORDER BY AvgMargin DESC;


--  ·  Rank products based on total profit (RANK() OVER).

CREATE VIEW vw_Product_Profit_Rank AS
WITH ProductProfits AS (
    SELECT 
        dp.EnglishProductName,
        SUM(frs.SalesAmount - frs.TotalProductCost) AS TotalProfit
    FROM FactResellerSales AS frs
    JOIN DimProduct AS dp ON frs.ProductKey = dp.ProductKey
    GROUP BY dp.EnglishProductName
)
SELECT 
    EnglishProductName,
    TotalProfit,
    RANK() OVER (ORDER BY TotalProfit DESC) AS ProfitRank
FROM ProductProfits;

-- ·  Detect outliers in price using subqueries or CTEs.

create view vw_Price_Outliers as
SELECT 
    ProductKey,
    EnglishProductName,
    ListPrice
FROM DimProduct
WHERE 
    ListPrice > (
        SELECT AVG(ListPrice) + 2 * STDEV(ListPrice) FROM DimProduct
    )
    OR
    ListPrice < (
        SELECT AVG(ListPrice) - 2 * STDEV(ListPrice) FROM DimProduct
    )

  --  ·  Compare sales between two specific years using PIVOT.

  create view vw_Sales_Comparison_2011_2012 as
  SELECT *
FROM (
    SELECT 
        dp.EnglishProductName,
        YEAR(frs.OrderDate) AS SalesYear,
        frs.SalesAmount
    FROM FactResellerSales AS frs
    JOIN DimProduct AS dp ON frs.ProductKey = dp.ProductKey
    WHERE YEAR(frs.OrderDate) IN (2011, 2012)
) AS SalesData
PIVOT (
    SUM(SalesAmount)
    FOR SalesYear IN ([2011], [2012])
) AS PivotTable
ORDER BY [2012] DESC;

-- Find products that have never been sold.

create view vw_Unsold_Products as
select
    dp.ProductKey,dp.EnglishProductName, frs.SalesAmount
from DimProduct as dp left join FactResellerSales as frs
    on dp.ProductKey = frs.ProductKey
where frs.SalesAmount is null


SELECT 
    CAST(COUNT(DISTINCT dp.ProductKey) - COUNT(DISTINCT frs.ProductKey) AS FLOAT) 
    / COUNT(DISTINCT dp.ProductKey) AS UnsoldProductsPercentage
FROM DimProduct dp
LEFT JOIN FactResellerSales frs 
    ON dp.ProductKey = frs.ProductKey;