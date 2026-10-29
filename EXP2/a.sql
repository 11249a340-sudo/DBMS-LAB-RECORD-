-- 1. Create database
CREATE DATABASE PayrollLabDB;
USE PayrollLabDB;

-- 2. Create Employee table
CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50) NOT NULL,
    Department VARCHAR(25) NOT NULL,
    Designation VARCHAR(30) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    City VARCHAR(30),
    Join_Date DATE NOT NULL
);

-- 3. Insert eight initial records
INSERT INTO Employee
(Emp_ID, Emp_Name, Department, Designation, Salary, City, Join_Date)
VALUES
(201, 'Asha', 'HR', 'Executive', 38000, 'Chennai', '2023-06-12'),
(202, 'Bharat', 'IT', 'Developer', 52000, 'Hyderabad', '2022-08-01'),
(203, 'Charan', 'Sales', 'Associate', 32000, 'Vijayawada', '2024-01-15'),
(204, 'Deepa', 'IT', 'Analyst', 48000, 'Bengaluru', '2023-03-20'),
(205, 'Eshan', 'Finance', 'Accountant', 45000, 'Chennai', '2021-11-05'),
(206, 'Farah', 'HR', 'Recruiter', 41000, 'Hyderabad', '2024-02-10'),
(207, 'Gopal', 'Sales', 'Executive', 35000, 'Nellore', '2022-07-18'),
(208, 'Hema', 'IT', 'Developer', 56000, 'Tirupati', '2021-09-30');

-- 4. View initial records
SELECT * FROM Employee ORDER BY Emp_ID;

-- 5. Insert a new employee
INSERT INTO Employee
VALUES (209, 'Ishita', 'Marketing', 'Coordinator',
        39000, 'Guntur', '2025-01-06');

SELECT * FROM Employee WHERE Emp_ID = 209;

-- 6. Update Bharat's salary
UPDATE Employee
SET Salary = 55000
WHERE Emp_ID = 202;

SELECT Emp_ID, Emp_Name, Salary
FROM Employee
WHERE Emp_ID = 202;

-- 7. Increase Sales salaries by 10%
UPDATE Employee
SET Salary = ROUND(Salary * 1.10, 2)
WHERE Department = 'Sales';

SELECT Emp_ID, Emp_Name, Salary
FROM Employee
WHERE Department = 'Sales'
ORDER BY Emp_ID;

-- 8. Modify Farah's department
UPDATE Employee
SET Department = 'Operations'
WHERE Emp_ID = 206;

SELECT Emp_ID, Emp_Name, Department
FROM Employee
WHERE Emp_ID = 206;

-- 9. Add Email column
ALTER TABLE Employee
ADD COLUMN Email VARCHAR(80) NULL;

SHOW COLUMNS FROM Employee LIKE 'Email';

-- 10. Populate Email column
UPDATE Employee
SET Email = 'asha@company.test'
WHERE Emp_ID = 201;

UPDATE Employee
SET Email = 'bharat@company.test'
WHERE Emp_ID = 202;

SELECT Emp_ID, Emp_Name, Email
FROM Employee
WHERE Email IS NOT NULL
ORDER BY Emp_ID;

-- 11. Modify Designation column size
ALTER TABLE Employee
MODIFY COLUMN Designation VARCHAR(50) NOT NULL;

SHOW COLUMNS FROM Employee LIKE 'Designation';

-- 12. View employees earning at least 45000
SELECT Emp_ID, Emp_Name, Department, Salary
FROM Employee
WHERE Salary >= 45000
ORDER BY Salary DESC, Emp_ID;

-- 13. Delete Ishita
DELETE FROM Employee
WHERE Emp_ID = 209;

SELECT COUNT(*) AS Total_Employees
FROM Employee;

-- 14. Delete Farah by condition
DELETE FROM Employee
WHERE Department = 'Operations'
AND Emp_ID = 206;

SELECT Emp_ID, Emp_Name, Department
FROM Employee
ORDER BY Emp_ID;

-- 15. View final payroll
SELECT Emp_ID, Emp_Name, Department, Salary, Email
FROM Employee
ORDER BY Emp_ID;

-- 16. Final employee count
SELECT COUNT(*) AS Final_Count
FROM Employee;

-- 17. Display Sales employees
SELECT Emp_Name, Salary
FROM Employee
WHERE Department = 'Sales'
ORDER BY Emp_ID;

-- 18. Display table structure
SHOW COLUMNS FROM Employee;

-- PRACTICE EXERCISES

-- 19. Insert employee 210
INSERT INTO Employee
(Emp_ID, Emp_Name, Department, Designation, Salary, City, Join_Date)
VALUES
(210, 'Jaya', 'IT', 'Tester', 42000, 'Chennai', '2025-03-10');

-- 20. Change Deepa's city
UPDATE Employee
SET City = 'Chennai'
WHERE Emp_ID = 204;

-- 21. Increase Finance salary by 5%
UPDATE Employee
SET Salary = ROUND(Salary * 1.05, 2)
WHERE Department = 'Finance';

-- 22. List employees earning over 40000
SELECT * FROM Employee
WHERE Salary > 40000;

-- 23. Add Phone column
ALTER TABLE Employee
ADD COLUMN Phone VARCHAR(15) NULL;

-- 24. Populate Phone for Asha
UPDATE Employee
SET Phone = '9876543210'
WHERE Emp_ID = 201;

-- 25. Display IT employees by salary
SELECT * FROM Employee
WHERE Department = 'IT'
ORDER BY Salary ASC;

-- 26. Delete employee 210
DELETE FROM Employee
WHERE Emp_ID = 210;

-- 27. Display employees with NULL email
SELECT Emp_ID, Emp_Name
FROM Employee
WHERE Email IS NULL;

-- 28. Final count after practice exercises
SELECT COUNT(*) AS Final_Count
FROM Employee;
