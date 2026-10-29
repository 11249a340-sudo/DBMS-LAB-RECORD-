-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS RetailSalesDB;
USE RetailSalesDB;

-- 2. CREATE SALES TABLE
CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Product_Name VARCHAR(40) NOT NULL,
    Category VARCHAR(25) NOT NULL,
    Region VARCHAR(20) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Unit_Price DECIMAL(10,2) NOT NULL CHECK (Unit_Price >= 0)
);

-- 3. INSERT 12 RECORDS
INSERT INTO Sales VALUES
(1, 'Laptop', 'Electronics', 'South', 2, 45000),
(2, 'Mouse', 'Electronics', 'North', 10, 600),
(3, 'Chair', 'Furniture', 'South', 4, 3500),
(4, 'Desk', 'Furniture', 'East', 3, 8000),
(5, 'Notebook', 'Stationery', 'West', 20, 80),
(6, 'Pen', 'Stationery', 'North', 50, 20),
(7, 'Monitor', 'Electronics', 'East', 5, 12000),
(8, 'Chair', 'Furniture', 'North', 6, 3200),
(9, 'Notebook', 'Stationery', 'South', 30, 75),
(10, 'Keyboard', 'Electronics', 'West', 8, 1200),
(11, 'Desk', 'Furniture', 'West', 2, 8500),
(12, 'Pen', 'Stationery', 'East', 40, 25);

-- QUERY 1: COUNT - TOTAL RECORDS
SELECT COUNT(*) AS Total_Records
FROM Sales;

-- QUERY 2: SUM - TOTAL UNITS SOLD
SELECT SUM(Quantity) AS Total_Units
FROM Sales;

-- QUERY 3: SUM - TOTAL REVENUE
SELECT SUM(Quantity * Unit_Price) AS Total_Revenue
FROM Sales;

-- QUERY 4: AVG - AVERAGE UNIT PRICE
SELECT ROUND(AVG(Unit_Price), 2) AS Avg_Price
FROM Sales;

-- QUERY 5: MIN AND MAX - PRICE RANGE
SELECT MIN(Unit_Price) AS Lowest_Price,
       MAX(Unit_Price) AS Highest_Price
FROM Sales;

-- QUERY 6: COUNT DISTINCT - NUMBER OF CATEGORIES
SELECT COUNT(DISTINCT Category) AS Categories
FROM Sales;

-- QUERY 7: GROUP BY - RECORDS PER CATEGORY
SELECT Category, COUNT(*) AS Sale_Records
FROM Sales
GROUP BY Category
ORDER BY Category;

-- QUERY 8: GROUP BY - UNITS SOLD PER CATEGORY
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category
ORDER BY Category;

-- QUERY 9: GROUP BY - REVENUE PER CATEGORY
SELECT Category,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
ORDER BY Category;

-- QUERY 10: GROUP BY - REGION-WISE REVENUE
SELECT Region,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Region
ORDER BY Revenue DESC, Region;

-- QUERY 11: HAVING - CATEGORIES WITH MORE THAN 20 UNITS
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category
HAVING SUM(Quantity) > 20
ORDER BY Category;

-- QUERY 12: HAVING - REGIONS WITH REVENUE ABOVE 30000
SELECT Region,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Region
HAVING SUM(Quantity * Unit_Price) > 30000
ORDER BY Revenue DESC;

-- QUERY 13: WHERE AND HAVING
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
WHERE Region IN ('North', 'South')
GROUP BY Category
HAVING SUM(Quantity) >= 10
ORDER BY Category;

-- QUERY 14: GROUP BY MULTIPLE COLUMNS
SELECT Category, Region, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category, Region
ORDER BY Category, Region;

-- QUERY 15: TOP CATEGORY BY REVENUE
SELECT Category,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
ORDER BY Revenue DESC, Category
LIMIT 1;

-- QUERY 16: AVERAGE QUANTITY PER CATEGORY
SELECT Category,
       ROUND(AVG(Quantity), 2) AS Avg_Quantity
FROM Sales
GROUP BY Category
ORDER BY Category;

-- VERIFICATION QUERIES
SELECT COUNT(*) AS Transactions,
       SUM(Quantity) AS Units,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales;

SELECT COUNT(DISTINCT Region) AS Total_Regions
FROM Sales;

-- PRACTICE EXERCISES

-- 1. Total sales records in the North region
SELECT COUNT(*) AS North_Transactions
FROM Sales
WHERE Region = 'North';

-- 2. Total quantity of Furniture sold
SELECT SUM(Quantity) AS Furniture_Units
FROM Sales
WHERE Category = 'Furniture';

-- 3. Average unit price of Electronics
SELECT ROUND(AVG(Unit_Price), 2) AS Avg_Electronics_Price
FROM Sales
WHERE Category = 'Electronics';

-- 4. Minimum and maximum quantity
SELECT MIN(Quantity) AS Minimum_Quantity,
       MAX(Quantity) AS Maximum_Quantity
FROM Sales;

-- 5. Transaction count for each region
SELECT Region, COUNT(*) AS Transaction_Count
FROM Sales
GROUP BY Region
ORDER BY Region;

-- 6. Total revenue for each product name
SELECT Product_Name,
       SUM(Quantity * Unit_Price) AS Total_Revenue
FROM Sales
GROUP BY Product_Name
ORDER BY Product_Name;

-- 7. Categories with revenue exceeding 30000
SELECT Category,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
HAVING SUM(Quantity * Unit_Price) > 30000
ORDER BY Revenue DESC;

-- FINAL DISPLAY
SELECT * FROM Sales
ORDER BY Sale_ID;
