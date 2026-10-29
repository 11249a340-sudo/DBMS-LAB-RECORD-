-- STEP 1: CREATE DATABASE
CREATE DATABASE IF NOT EXISTS NormalizationLabDB;
USE NormalizationLabDB;

-- STEP 2: UNNORMALIZED FORM (UNF)
CREATE TABLE EnrollmentRaw (
    StudentID INT,
    StudentName VARCHAR(40),
    CourseList VARCHAR(100)
);

INSERT INTO EnrollmentRaw VALUES
(1, 'Anu', 'C101,C102'),
(2, 'Bala', 'C101'),
(3, 'Chitra', 'C102');

SELECT * FROM EnrollmentRaw ORDER BY StudentID;


-- STEP 3: FIRST NORMAL FORM (1NF)
CREATE TABLE Enrollment1NF (
    StudentID INT,
    StudentName VARCHAR(40),
    CourseID VARCHAR(8),
    CourseName VARCHAR(40),
    InstructorID VARCHAR(8),
    InstructorName VARCHAR(40),
    Grade CHAR(1),
    PRIMARY KEY (StudentID, CourseID)
);

INSERT INTO Enrollment1NF VALUES
(1, 'Anu', 'C101', 'DBMS', 'I10', 'Rao', 'A'),
(1, 'Anu', 'C102', 'Networks', 'I20', 'Sen', 'B'),
(2, 'Bala', 'C101', 'DBMS', 'I10', 'Rao', 'B'),
(3, 'Chitra', 'C102', 'Networks', 'I20', 'Sen', 'A');

SELECT StudentID, CourseID, Grade
FROM Enrollment1NF
ORDER BY StudentID, CourseID;


-- STEP 4: SECOND NORMAL FORM (2NF)
CREATE TABLE Students2NF (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(40) NOT NULL
);

CREATE TABLE Courses2NF (
    CourseID VARCHAR(8) PRIMARY KEY,
    CourseName VARCHAR(40),
    InstructorID VARCHAR(8),
    InstructorName VARCHAR(40)
);

CREATE TABLE Registrations2NF (
    StudentID INT,
    CourseID VARCHAR(8),
    Grade CHAR(1),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID)
        REFERENCES Students2NF(StudentID),
    FOREIGN KEY (CourseID)
        REFERENCES Courses2NF(CourseID)
);

INSERT INTO Students2NF VALUES
(1, 'Anu'),
(2, 'Bala'),
(3, 'Chitra');

INSERT INTO Courses2NF VALUES
('C101', 'DBMS', 'I10', 'Rao'),
('C102', 'Networks', 'I20', 'Sen');

INSERT INTO Registrations2NF VALUES
(1, 'C101', 'A'),
(1, 'C102', 'B'),
(2, 'C101', 'B'),
(3, 'C102', 'A');

SELECT * FROM Students2NF;
SELECT * FROM Courses2NF;
SELECT * FROM Registrations2NF;


-- STEP 5: THIRD NORMAL FORM (3NF)
CREATE TABLE Instructors3NF (
    InstructorID VARCHAR(8) PRIMARY KEY,
    InstructorName VARCHAR(40) NOT NULL
);

CREATE TABLE Courses3NF (
    CourseID VARCHAR(8) PRIMARY KEY,
    CourseName VARCHAR(40) NOT NULL,
    InstructorID VARCHAR(8) NOT NULL,
    FOREIGN KEY (InstructorID)
        REFERENCES Instructors3NF(InstructorID)
);

INSERT INTO Instructors3NF VALUES
('I10', 'Rao'),
('I20', 'Sen');

INSERT INTO Courses3NF VALUES
('C101', 'DBMS', 'I10'),
('C102', 'Networks', 'I20');

-- Retrieve enrollment details using JOIN
SELECT
    r.StudentID,
    s.StudentName,
    c.CourseName,
    i.InstructorName,
    r.Grade
FROM Registrations2NF r
JOIN Students2NF s
    ON s.StudentID = r.StudentID
JOIN Courses3NF c
    ON c.CourseID = r.CourseID
JOIN Instructors3NF i
    ON i.InstructorID = c.InstructorID
ORDER BY r.StudentID, c.CourseID;


-- STEP 6: DEMONSTRATE 4NF VIOLATION
CREATE TABLE StudentInterestRaw (
    StudentID INT,
    Hobby VARCHAR(30),
    Language VARCHAR(30),
    PRIMARY KEY (StudentID, Hobby, Language)
);

INSERT INTO StudentInterestRaw VALUES
(1, 'Chess', 'English'),
(1, 'Chess', 'Tamil'),
(1, 'Music', 'English'),
(1, 'Music', 'Tamil');

SELECT *
FROM StudentInterestRaw
ORDER BY Hobby, Language;


-- STEP 7: FOURTH NORMAL FORM (4NF)
CREATE TABLE StudentHobby4NF (
    StudentID INT,
    Hobby VARCHAR(30),
    PRIMARY KEY (StudentID, Hobby)
);

CREATE TABLE StudentLanguage4NF (
    StudentID INT,
    Language VARCHAR(30),
    PRIMARY KEY (StudentID, Language)
);

INSERT INTO StudentHobby4NF VALUES
(1, 'Chess'),
(1, 'Music');

INSERT INTO StudentLanguage4NF VALUES
(1, 'English'),
(1, 'Tamil');

-- Reconstruct the original combinations
SELECT
    h.StudentID,
    h.Hobby,
    l.Language
FROM StudentHobby4NF h
JOIN StudentLanguage4NF l
    ON h.StudentID = l.StudentID
ORDER BY h.Hobby, l.Language;


-- STEP 8: DEMONSTRATE 5NF
CREATE TABLE SupplyRaw (
    SupplierID VARCHAR(8),
    PartID VARCHAR(8),
    ProjectID VARCHAR(8),
    PRIMARY KEY (SupplierID, PartID, ProjectID)
);

INSERT INTO SupplyRaw VALUES
('S1', 'P1', 'J1'),
('S1', 'P2', 'J1'),
('S2', 'P1', 'J1');

-- Create binary projections
CREATE TABLE SupplierPart5NF AS
SELECT DISTINCT SupplierID, PartID
FROM SupplyRaw;

CREATE TABLE SupplierProject5NF AS
SELECT DISTINCT SupplierID, ProjectID
FROM SupplyRaw;

CREATE TABLE PartProject5NF AS
SELECT DISTINCT PartID, ProjectID
FROM SupplyRaw;

-- Add primary keys
ALTER TABLE SupplierPart5NF
ADD PRIMARY KEY (SupplierID, PartID);

ALTER TABLE SupplierProject5NF
ADD PRIMARY KEY (SupplierID, ProjectID);

ALTER TABLE PartProject5NF
ADD PRIMARY KEY (PartID, ProjectID);

-- Reconstruct the ternary relation
SELECT
    sp.SupplierID,
    sp.PartID,
    sj.ProjectID
FROM SupplierPart5NF sp
JOIN SupplierProject5NF sj
    ON sj.SupplierID = sp.SupplierID
JOIN PartProject5NF pj
    ON pj.PartID = sp.PartID
   AND pj.ProjectID = sj.ProjectID
ORDER BY sp.SupplierID, sp.PartID, sj.ProjectID;


-- STEP 9: VERIFY LOSSLESS RECONSTRUCTION
SELECT COUNT(*) AS OriginalRows
FROM SupplyRaw;

SELECT COUNT(*) AS ReconstructedRows
FROM (
    SELECT
        sp.SupplierID,
        sp.PartID,
        sj.ProjectID
    FROM SupplierPart5NF sp
    JOIN SupplierProject5NF sj
        ON sj.SupplierID = sp.SupplierID
    JOIN PartProject5NF pj
        ON pj.PartID = sp.PartID
       AND pj.ProjectID = sj.ProjectID
) AS Reconstructed;

-- Check differences in both directions
WITH Reconstructed AS (
    SELECT
        sp.SupplierID,
        sp.PartID,
        sj.ProjectID
    FROM SupplierPart5NF sp
    JOIN SupplierProject5NF sj
        ON sj.SupplierID = sp.SupplierID
    JOIN PartProject5NF pj
        ON pj.PartID = sp.PartID
       AND pj.ProjectID = sj.ProjectID
)
SELECT
    'Original only' AS DifferenceType,
    o.SupplierID,
    o.PartID,
    o.ProjectID
FROM SupplyRaw o
LEFT JOIN Reconstructed r
    ON r.SupplierID = o.SupplierID
   AND r.PartID = o.PartID
   AND r.ProjectID = o.ProjectID
WHERE r.SupplierID IS NULL

UNION ALL

SELECT
    'Reconstructed only' AS DifferenceType,
    r.SupplierID,
    r.PartID,
    r.ProjectID
FROM Reconstructed r
LEFT JOIN SupplyRaw o
    ON o.SupplierID = r.SupplierID
   AND o.PartID = r.PartID
   AND o.ProjectID = r.ProjectID
WHERE o.SupplierID IS NULL;


-- FINAL VERIFICATION
SELECT COUNT(*) AS Enrollment1NF_Rows
FROM Enrollment1NF;

SELECT COUNT(*) AS Student_Count
FROM Students2NF;

SELECT COUNT(*) AS Course_Count
FROM Courses3NF;

SELECT COUNT(*) AS Registration_Count
FROM Registrations2NF;

SELECT COUNT(*) AS Hobby_Count
FROM StudentHobby4NF;

SELECT COUNT(*) AS Language_Count
FROM StudentLanguage4NF;

SELECT COUNT(*) AS Supply_Count
FROM SupplyRaw;
