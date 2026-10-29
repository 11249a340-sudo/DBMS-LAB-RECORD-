-- QUERY 1: Create and select database
CREATE DATABASE WarehouseDB;
USE WarehouseDB;

-- QUERY 2: Create Product table
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(60) NOT NULL,
    Category VARCHAR(30) NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    Stock_Qty INT NOT NULL,
    Warehouse VARCHAR(30) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1001;

-- QUERY 3: Insert eight sample products
INSERT INTO Product
(Product_Name, Category, Unit_Price, Stock_Qty, Warehouse)
VALUES
('Keyboard', 'Electronics', 800, 40, 'Chennai'),
('Mouse', 'Electronics', 450, 12, 'Chennai'),
('Office Chair', 'Furniture', 4500, 8, 'Bengaluru'),
('Desk', 'Furniture', 7200, 15, 'Chennai'),
('Notebook', 'Stationery', 60, 100, 'Hyderabad'),
('Pen Pack', 'Stationery', 120, 25, 'Hyderabad'),
('Monitor', 'Electronics', 12500, 6, 'Bengaluru'),
('Printer', 'Electronics', 9500, 4, 'Chennai');

-- QUERY 4: Create product catalog view
CREATE VIEW vw_product_catalog AS
SELECT Product_ID, Product_Name, Category, Unit_Price
FROM Product;

-- QUERY 5: Retrieve data from the view
SELECT *
FROM vw_product_catalog
ORDER BY Product_ID;

-- QUERY 6: Create low-stock view
CREATE VIEW vw_low_stock AS
SELECT Product_ID, Product_Name, Stock_Qty
FROM Product
WHERE Stock_Qty < 10;

-- QUERY 7: Display low-stock products
SELECT *
FROM vw_low_stock
ORDER BY Product_ID;

-- QUERY 8: Replace low-stock view
CREATE OR REPLACE VIEW vw_low_stock AS
SELECT Product_ID, Product_Name, Category, Stock_Qty
FROM Product
WHERE Stock_Qty <= 12;

-- QUERY 9: Insert a product with an automatic ID
INSERT INTO Product
(Product_Name, Category, Unit_Price, Stock_Qty, Warehouse)
VALUES
('Webcam', 'Electronics', 2200, 18, 'Chennai');

SELECT LAST_INSERT_ID() AS New_Product_ID;

-- QUERY 10: Create an index
CREATE INDEX idx_product_category
ON Product(Category);

-- QUERY 11: Display indexes
SHOW INDEX FROM Product;

-- QUERY 12: Explain query execution plan
EXPLAIN
SELECT *
FROM Product
WHERE Category = 'Electronics';

-- QUERY 13: Start transaction and create savepoint
START TRANSACTION;

UPDATE Product
SET Stock_Qty = Stock_Qty - 5
WHERE Product_ID = 1001;

SAVEPOINT sp_after_keyboard;

UPDATE Product
SET Stock_Qty = Stock_Qty - 3
WHERE Product_ID = 1002;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- QUERY 14: Roll back to savepoint
ROLLBACK TO SAVEPOINT sp_after_keyboard;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- QUERY 15: Commit retained changes
COMMIT;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- QUERY 16: Demonstrate full rollback
START TRANSACTION;

UPDATE Product
SET Stock_Qty = 0
WHERE Product_ID = 1003;

ROLLBACK;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID = 1003;

-- QUERY 17: Drop secondary index
DROP INDEX idx_product_category ON Product;

SHOW INDEX FROM Product;

-- FINAL VERIFICATION
SELECT COUNT(*) AS Total_Products
FROM Product;

SELECT Product_ID, Product_Name, Stock_Qty
FROM Product
ORDER BY Product_ID;

SHOW FULL TABLES IN WarehouseDB;
