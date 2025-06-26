-- Beginner Level – SQL Basics


--List all available tables and views.

SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
ORDER BY  TABLE_NAME;


-- Select all columns from the DimProduct table.
SELECT * 
FROM DimProduct


-- Retrieve the first 10 products with their name, number, and color.

SELECT TOP 10
	EnglishProductName,
	ProductAlternateKey,
	Color
FROM DimProduct


-- List all products that are black. 
SELECT *
FROM DimProduct
WHERE Color='Black';


-- ·  ·  Get distinct product names.
SELECT DISTINCT EnglishProductName 
from DimProduct

--·  · Count how many products exist per color.
SELECT Color, COUNT(*) AS ProductCount
FROM DimProduct
GROUP BY Color
ORDER BY ProductCount DESC


 -- Filter products with StandardCost greater than 100.
SELECT *
FROM DimProduct
WHERE StandardCost > 100

-- Order products by ListPrice in descending order.

SELECT *
FROM DimProduct
ORDER BY ListPrice desc

