-- 1. Create the database
CREATE DATABASE UniversityDB;

-- 2. Select the database
USE UniversityDB;

-- 3. Create the Student table
CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(50) NOT NULL,
    Department VARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Marks DECIMAL(5,2),
    City VARCHAR(30)
);

-- 4. Display table structure
DESC Student;

-- 5. Insert ten student records
INSERT INTO Student
(Student_ID, Student_Name, Department, Year, Age, Gender, Marks, City)
VALUES
(101, 'Arun', 'CSE', 2, 19, 'Male', 85, 'Chennai'),
(102, 'Priya', 'ECE', 3, 20, 'Female', 92, 'Hyderabad'),
(103, 'Ravi', 'CSE', 2, 19, 'Male', 67, 'Vijayawada'),
(104, 'Sneha', 'AIML', 1, 18, 'Female', 88, 'Bengaluru'),
(105, 'Kiran', 'EEE', 4, 21, 'Male', 56, 'Chennai'),
(106, 'Divya', 'CSE', 3, 20, 'Female', 94, 'Tirupati'),
(107, 'Rahul', 'MECH', 2, 19, 'Male', 72, 'Nellore'),
(108, 'Anjali', 'AIML', 1, 18, 'Female', 81, 'Hyderabad'),
(109, 'Naveen', 'ECE', 4, 21, 'Male', 63, 'Guntur'),
(110, 'Kavya', 'CSE', 3, 20, 'Female', 90, 'Chennai');

-- 6. Retrieve all records
SELECT * FROM Student
ORDER BY Student_ID;

-- 7. Select three columns
SELECT Student_ID, Student_Name, Department
FROM Student
ORDER BY Student_ID;

-- 8. Display CSE students
SELECT Student_ID, Student_Name, Department
FROM Student
WHERE Department = 'CSE'
ORDER BY Student_ID;

-- 9. Use AND operator
SELECT Student_Name, Department, Marks
FROM Student
WHERE Department = 'CSE' AND Marks > 80
ORDER BY Student_ID;

-- 10. Use OR operator
SELECT Student_Name, Department
FROM Student
WHERE Department = 'AIML' OR Department = 'ECE'
ORDER BY Student_ID;

-- 11. Display distinct departments
SELECT DISTINCT Department
FROM Student
ORDER BY Department;

-- 12. Sort marks in ascending order
SELECT Student_Name, Marks
FROM Student
ORDER BY Marks ASC;

-- 13. Sort marks in descending order
SELECT Student_Name, Marks
FROM Student
ORDER BY Marks DESC;

-- 14. Find marks between 70 and 90
SELECT Student_Name, Marks
FROM Student
WHERE Marks BETWEEN 70 AND 90
ORDER BY Marks ASC;

-- 15. Find names starting with A
SELECT Student_ID, Student_Name
FROM Student
WHERE Student_Name LIKE 'A%'
ORDER BY Student_ID;

-- 16. Select students from specified departments
SELECT Student_Name, Department
FROM Student
WHERE Department IN ('CSE', 'ECE', 'AIML')
ORDER BY Student_ID;

-- 17. Find students with missing cities
SELECT Student_ID, Student_Name, City
FROM Student
WHERE City IS NULL;

-- 18. Display top three students by marks
SELECT Student_Name, Department, Marks
FROM Student
ORDER BY Marks DESC, Student_ID ASC
LIMIT 3;

-- 19. Count total students
SELECT COUNT(*) AS Total
FROM Student;

-- 20. Count distinct departments
SELECT COUNT(DISTINCT Department) AS Departments
FROM Student;

-- 21. Find highest and lowest marks
SELECT MAX(Marks) AS Highest, MIN(Marks) AS Lowest
FROM Student;

-- 22. List all AIML students
SELECT * FROM Student
WHERE Department = 'AIML';

-- 23. Students scoring above 85
SELECT * FROM Student
WHERE Marks > 85;

-- 24. Find second-year students
SELECT * FROM Student
WHERE Year = 2;

-- 25. Find students from Chennai
SELECT * FROM Student
WHERE City = 'Chennai';

-- 26. Sort student names alphabetically
SELECT Student_Name
FROM Student
ORDER BY Student_Name ASC;

-- 27. Find names ending with 'a'
SELECT Student_Name
FROM Student
WHERE Student_Name LIKE '%a';

-- 28. Find marks between 60 and 80
SELECT Student_Name, Marks
FROM Student
WHERE Marks BETWEEN 60 AND 80;

-- 29. Find students not in CSE
SELECT Student_Name, Department
FROM Student
WHERE Department <> 'CSE';

-- 30. Display top five students
SELECT Student_Name, Department, Marks
FROM Student
ORDER BY Marks DESC, Student_ID ASC
LIMIT 5;

-- 31. Third-year students scoring at least 90
SELECT Student_Name, Year, Marks
FROM Student
WHERE Year = 3 AND Marks >= 90;
