-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS RetailConstraintDB;
USE RetailConstraintDB;

-- 2. CREATE CUSTOMERS TABLE
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(60) NOT NULL,
    email VARCHAR(80) NOT NULL UNIQUE,
    city VARCHAR(40) DEFAULT 'Chennai'
) ENGINE = InnoDB;

-- 3. CREATE PRODUCTS TABLE
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    sku VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(60) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_stock CHECK (stock >= 0)
) ENGINE = InnoDB;

-- 4. CREATE ORDERS TABLE
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_status VARCHAR(12) NOT NULL DEFAULT 'Pending',
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT fk_order_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id),

    CONSTRAINT chk_quantity CHECK (quantity > 0),

    CONSTRAINT chk_status CHECK (
        order_status IN ('Pending', 'Confirmed', 'Cancelled')
    )
) ENGINE = InnoDB;

-- 5. INSERT CUSTOMERS
INSERT INTO Customers
(customer_id, customer_name, email, city)
VALUES
(201, 'Asha', 'asha@example.com', 'Chennai'),
(202, 'Bala', 'bala@example.com', 'Hyderabad'),
(203, 'Charu', 'charu@example.com', 'Bengaluru');

-- 6. INSERT PRODUCTS
INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES
(301, 'KB-01', 'Keyboard', 850.00, 25),
(302, 'MS-02', 'Mouse', 450.00, 40),
(303, 'HD-03', 'Hard Drive', 4200.00, 10);

-- 7. INSERT ORDERS
INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES
(401, 201, 301, 2, 'Pending'),
(402, 202, 302, 3, 'Confirmed'),
(403, 203, 303, 1, 'Pending');

-- 8. TEST DEFAULT CITY
INSERT INTO Customers
(customer_id, customer_name, email)
VALUES
(204, 'Deepa', 'deepa@example.com');

SELECT customer_id, customer_name, city
FROM Customers
WHERE customer_id = 204;

-- Expected city: Chennai

-- 9. TEST DUPLICATE PRIMARY KEY
-- Expected failure: Duplicate primary key 201.
INSERT INTO Customers
(customer_id, customer_name, email)
VALUES
(201, 'Duplicate', 'duplicate@example.com');

-- 10. TEST DUPLICATE UNIQUE EMAIL
-- Expected failure: Email already exists.
INSERT INTO Customers
(customer_id, customer_name, email)
VALUES
(205, 'Esha', 'asha@example.com');

-- 11. TEST NOT NULL CONSTRAINT
-- Expected failure: customer_name cannot be NULL.
INSERT INTO Customers
(customer_id, customer_name, email)
VALUES
(205, NULL, 'esha@example.com');

-- 12. TEST CHECK CONSTRAINT ON PRICE
-- Expected failure: Price must be greater than zero.
INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES
(304, 'BAD-04', 'Invalid Product', -10.00, 5);

-- 13. TEST CHECK CONSTRAINT ON QUANTITY
-- Expected failure: Quantity must be positive.
INSERT INTO Orders
(order_id, customer_id, product_id, quantity)
VALUES
(404, 201, 301, 0);

-- 14. TEST FOREIGN KEY CONSTRAINT
-- Expected failure: Customer 999 does not exist.
INSERT INTO Orders
(order_id, customer_id, product_id, quantity)
VALUES
(404, 999, 301, 1);

-- 15. TEST CHECK CONSTRAINT ON STATUS
-- Expected failure: Shipped is not an approved status.
INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES
(404, 201, 301, 1, 'Shipped');

-- 16. DISPLAY ALL CUSTOMERS
SELECT customer_id, customer_name, email, city
FROM Customers
ORDER BY customer_id;

-- 17. DISPLAY ALL PRODUCTS
SELECT *
FROM Products
ORDER BY product_id;

-- 18. DISPLAY ALL ORDERS
SELECT order_id, customer_id, product_id,
       quantity, order_status, order_date
FROM Orders
ORDER BY order_id;

-- 19. DISPLAY TABLE CONSTRAINT DEFINITIONS
SHOW CREATE TABLE Customers;
SHOW CREATE TABLE Products;
SHOW CREATE TABLE Orders;

-- 20. COUNT VALID RECORDS
SELECT COUNT(*) AS Total_Customers
FROM Customers;

SELECT COUNT(*) AS Total_Products
FROM Products;

SELECT COUNT(*) AS Total_Orders
FROM Orders;

-- 21. DISPLAY ORDERS WITH CUSTOMER NAMES
SELECT O.order_id, C.customer_name,
       P.product_name, O.quantity,
       O.order_status, O.order_date
FROM Orders O
JOIN Customers C ON O.customer_id = C.customer_id
JOIN Products P ON O.product_id = P.product_id
ORDER BY O.order_id;

-- PRACTICE EXERCISES

-- 22. Insert a customer with default city
INSERT INTO Customers
(customer_id, customer_name, email)
VALUES
(205, 'Esha', 'esha@example.com');

-- 23. Attempt duplicate SKU
-- Expected failure: SKU KB-01 already exists.
INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES
(305, 'KB-01', 'Gaming Keyboard', 2500.00, 10);

-- 24. Insert a product with zero stock (valid)
INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES
(306, 'SP-06', 'Speaker', 1500.00, 0);

-- 25. Attempt negative stock (expected failure)
INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES
(307, 'SP-07', 'Invalid Speaker', 1200.00, -5);

-- 26. Attempt an order with nonexistent product
-- Expected failure: Product 999 does not exist.
INSERT INTO Orders
(order_id, customer_id, product_id, quantity)
VALUES
(405, 201, 999, 1);

-- 27. Attempt negative quantity (expected failure)
INSERT INTO Orders
(order_id, customer_id, product_id, quantity)
VALUES
(406, 201, 301, -2);

-- 28. Attempt invalid order status (expected failure)
INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES
(407, 201, 301, 1, 'Returned');

-- 29. FINAL VERIFICATION
SELECT * FROM Customers ORDER BY customer_id;
SELECT * FROM Products ORDER BY product_id;
SELECT * FROM Orders ORDER BY order_id;
