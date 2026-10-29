-- OPERATION 1: CREATE DATABASE AND TABLE

CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;

CREATE TABLE BankAccount (
    Account_ID INT PRIMARY KEY,
    Holder_Name VARCHAR(50) NOT NULL,
    Branch VARCHAR(30) NOT NULL,
    Balance DECIMAL(12,2) NOT NULL CHECK (Balance >= 0),
    Account_Type VARCHAR(20) NOT NULL
) ENGINE = InnoDB;

-- OPERATION 2: INSERT FIVE ACCOUNTS

INSERT INTO BankAccount
(Account_ID, Holder_Name, Branch, Balance, Account_Type)
VALUES
(201, 'Anand', 'Chennai', 50000.00, 'Savings'),
(202, 'Bhavya', 'Hyderabad', 35000.00, 'Savings'),
(203, 'Charan', 'Vijayawada', 20000.00, 'Current'),
(204, 'Deepa', 'Chennai', 45000.00, 'Savings'),
(205, 'Eshan', 'Bengaluru', 60000.00, 'Current');

-- OPERATION 3: VIEW INITIAL BALANCES

SELECT Account_ID, Holder_Name, Balance
FROM BankAccount
ORDER BY Account_ID;

-- OPERATION 4: CREATE A TEST TELLER USER
-- Run as a MySQL administrator.

CREATE USER 'lab_teller3'@'localhost'
IDENTIFIED BY 'LabDemo_ChangeMe_2026!';

-- OPERATION 5: GRANT READ PERMISSION

GRANT SELECT ON BankDB.BankAccount
TO 'lab_teller3'@'localhost';

-- OPERATION 6: VERIFY USER PERMISSIONS

SHOW GRANTS FOR 'lab_teller3'@'localhost';

-- OPERATION 7: TEST TELLER PERMISSIONS
-- Connect separately as lab_teller3 to test these statements.
-- SELECT should succeed; UPDATE should fail with a permission error.

SELECT Account_ID, Balance
FROM BankDB.BankAccount;

UPDATE BankDB.BankAccount
SET Balance = Balance + 100
WHERE Account_ID = 201;

-- OPERATION 8: REVOKE READ PERMISSION
-- Run again as administrator.

REVOKE SELECT ON BankDB.BankAccount
FROM 'lab_teller3'@'localhost';

SHOW GRANTS FOR 'lab_teller3'@'localhost';

-- OPERATION 9: COMMIT A DEPOSIT

START TRANSACTION;

UPDATE BankAccount
SET Balance = Balance + 5000
WHERE Account_ID = 201;

COMMIT;

SELECT Account_ID, Balance
FROM BankAccount
WHERE Account_ID = 201;

-- Expected balance: 55000.00

-- OPERATION 10: ROLLBACK A WITHDRAWAL

START TRANSACTION;

UPDATE BankAccount
SET Balance = Balance - 3000
WHERE Account_ID = 202;

ROLLBACK;

SELECT Account_ID, Balance
FROM BankAccount
WHERE Account_ID = 202;

-- Expected balance: 35000.00

-- OPERATION 11: SAVEPOINT AND PARTIAL ROLLBACK

START TRANSACTION;

UPDATE BankAccount
SET Balance = Balance + 1000
WHERE Account_ID = 203;

SAVEPOINT after_first_change;

UPDATE BankAccount
SET Balance = Balance + 2000
WHERE Account_ID = 204;

ROLLBACK TO SAVEPOINT after_first_change;

COMMIT;

SELECT Account_ID, Balance
FROM BankAccount
WHERE Account_ID IN (203, 204)
ORDER BY Account_ID;

-- Expected:
-- Account 203 = 21000.00
-- Account 204 = 45000.00

-- OPERATION 12: ATOMIC FUND TRANSFER
-- Debit and credit must both succeed before COMMIT.

START TRANSACTION;

UPDATE BankAccount
SET Balance = Balance - 4000
WHERE Account_ID = 201
  AND Balance >= 4000;

SELECT ROW_COUNT() AS Debit_Rows;

-- Continue only if Debit_Rows = 1.

UPDATE BankAccount
SET Balance = Balance + 4000
WHERE Account_ID = 202;

SELECT ROW_COUNT() AS Credit_Rows;

-- If either row count is not 1, execute ROLLBACK
-- instead of COMMIT.
-- If both row counts are 1, execute:

COMMIT;

SELECT Account_ID, Balance
FROM BankAccount
WHERE Account_ID IN (201, 202)
ORDER BY Account_ID;

-- Expected:
-- Account 201 = 51000.00
-- Account 202 = 39000.00

-- OPERATION 13: RELEASE SAVEPOINT

START TRANSACTION;

SAVEPOINT test_point;

RELEASE SAVEPOINT test_point;

ROLLBACK;

-- OPERATION 14: REMOVE TEST USER
-- Run as administrator after permission testing.

DROP USER 'lab_teller3'@'localhost';

-- FINAL VERIFICATION

SELECT Account_ID, Holder_Name, Balance
FROM BankAccount
ORDER BY Account_ID;

SELECT SUM(Balance) AS Total_Balance
FROM BankAccount;

-- Expected total balance: 216000.00
