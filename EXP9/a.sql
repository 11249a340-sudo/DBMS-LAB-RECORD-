CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE Employees (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(40) NOT NULL,
    Dept_ID INT NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

CREATE TABLE Projects (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(60) NOT NULL,
    Dept_ID INT NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

CREATE TABLE Assignments (
    Emp_ID INT NOT NULL,
    Project_ID INT NOT NULL,
    Hours INT NOT NULL,
    PRIMARY KEY (Emp_ID, Project_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID),
    FOREIGN KEY (Project_ID) REFERENCES Projects(Project_ID)
);

INSERT INTO Departments VALUES
(10, 'Development'),
(20, 'Testing'),
(30, 'HR'),
(40, 'Research');

INSERT INTO Employees VALUES
(101, 'Arun', 10, 60000),
(102, 'Priya', 10, 75000),
(103, 'Ravi', 20, 50000),
(104, 'Sneha', 20, 55000),
(105, 'Kiran', 30, 45000),
(106, 'Divya', 40, 90000),
(107, 'Rahul', 10, 65000);

INSERT INTO Projects VALUES
(201, 'Web Portal', 10, 300000),
(202, 'Mobile App', 10, 450000),
(203, 'QA Automation', 20, 200000),
(204, 'AI Prototype', 40, 600000),
(205, 'Recruitment Portal', 30, 120000);

INSERT INTO Assignments VALUES
(101, 201, 30),
(102, 201, 25),
(102, 202, 35),
(103, 203, 40),
(104, 203, 20),
(106, 204, 45),
(107, 202, 30);

-- 1. INNER JOIN: Employees and Departments
SELECT e.Emp_Name, d.Dept_Name
FROM Employees e
INNER JOIN Departments d ON e.Dept_ID = d.Dept_ID
ORDER BY e.Emp_ID;

-- 2. JOIN THREE TABLES: Project Assignments
SELECT e.Emp_Name, p.Project_Name, a.Hours
FROM Assignments a
JOIN Employees e ON a.Emp_ID = e.Emp_ID
JOIN Projects p ON a.Project_ID = p.Project_ID
ORDER BY a.Emp_ID, a.Project_ID;

-- 3. LEFT JOIN: All Employees, Including Unassigned
SELECT e.Emp_Name, p.Project_Name
FROM Employees e
LEFT JOIN Assignments a ON e.Emp_ID = a.Emp_ID
LEFT JOIN Projects p ON a.Project_ID = p.Project_ID
ORDER BY e.Emp_ID, p.Project_ID;

-- 4. RIGHT JOIN: All Projects, Including Unassigned
SELECT p.Project_Name, e.Emp_Name
FROM Assignments a
RIGHT JOIN Projects p ON a.Project_ID = p.Project_ID
LEFT JOIN Employees e ON a.Emp_ID = e.Emp_ID
ORDER BY p.Project_ID, e.Emp_ID;

-- 5. CROSS JOIN: Department and Project Combinations
SELECT d.Dept_Name, p.Project_Name
FROM Departments d
CROSS JOIN Projects p
WHERE d.Dept_ID = 30
ORDER BY p.Project_ID;

-- 6. SELF JOIN: Employees in the Same Department
SELECT
    a.Emp_Name AS Employee1,
    b.Emp_Name AS Employee2
FROM Employees a
JOIN Employees b
    ON a.Dept_ID = b.Dept_ID
    AND a.Emp_ID < b.Emp_ID
ORDER BY a.Emp_ID, b.Emp_ID;

-- 7. SCALAR SUBQUERY: Salary Above Company Average
SELECT Emp_Name, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
ORDER BY Salary DESC;

-- 8. IN SUBQUERY: Employees in Departments with Projects Budgeted at Least 400000
SELECT Emp_Name, Dept_ID
FROM Employees
WHERE Dept_ID IN (
    SELECT Dept_ID
    FROM Projects
    WHERE Budget >= 400000
)
ORDER BY Emp_ID;

-- 9. EXISTS: Employees Assigned to Projects
SELECT e.Emp_Name
FROM Employees e
WHERE EXISTS (
    SELECT 1
    FROM Assignments a
    WHERE a.Emp_ID = e.Emp_ID
)
ORDER BY e.Emp_ID;

-- 10. NOT EXISTS: Employees Without Assignments
SELECT e.Emp_Name
FROM Employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM Assignments a
    WHERE a.Emp_ID = e.Emp_ID
)
ORDER BY e.Emp_ID;

-- 11. CORRELATED SUBQUERY: Employees Earning Above Department Average
SELECT e.Emp_Name, e.Dept_ID, e.Salary
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(x.Salary)
    FROM Employees x
    WHERE x.Dept_ID = e.Dept_ID
)
ORDER BY e.Emp_ID;

-- 12. MAX SUBQUERY: Highest-Paid Employee
SELECT Emp_Name, Salary
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);

-- 13. JOIN WITH GROUP BY: Number of Employees Assigned to Each Project
SELECT
    p.Project_Name,
    COUNT(a.Emp_ID) AS Staff
FROM Projects p
LEFT JOIN Assignments a ON p.Project_ID = a.Project_ID
GROUP BY p.Project_ID, p.Project_Name
ORDER BY p.Project_ID;

-- 14. NOT EXISTS: Projects Without Employees
SELECT p.Project_Name
FROM Projects p
WHERE NOT EXISTS (
    SELECT 1
    FROM Assignments a
    WHERE a.Project_ID = p.Project_ID
)
ORDER BY p.Project_ID;

-- 15. VERIFY TOTAL RECORDS
SELECT
    (SELECT COUNT(*) FROM Departments) AS Departments,
    (SELECT COUNT(*) FROM Employees) AS Employees,
    (SELECT COUNT(*) FROM Projects) AS Projects,
    (SELECT COUNT(*) FROM Assignments) AS Assignments;
