-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS LibraryExp5;
USE LibraryExp5;

-- 2. CREATE BOOKS TABLE
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(80) NOT NULL,
    category VARCHAR(30) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    copies INT NOT NULL,
    CHECK (price >= 0),
    CHECK (copies >= 0)
);

-- 3. CREATE MEMBERS TABLE
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(60) NOT NULL,
    department VARCHAR(20) NOT NULL
);

-- 4. CREATE LOANS TABLE
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- 5. INSERT BOOKS
INSERT INTO Books VALUES
(1, 'SQL Basics', 'Database', 400, 5),
(2, 'Advanced SQL', 'Database', 650, 3),
(3, 'Python Guide', 'Programming', 550, 4),
(4, 'Java Handbook', 'Programming', 700, 2),
(5, 'Data Science', 'Analytics', 900, 2),
(6, 'Statistics 101', 'Analytics', 450, 6),
(7, 'Web Design', 'Web', 300, 5),
(8, 'Cloud Computing', 'Cloud', 800, 3);

-- 6. INSERT MEMBERS
INSERT INTO Members VALUES
(101, 'Asha', 'CSE'),
(102, 'Bala', 'ECE'),
(103, 'Charan', 'CSE'),
(104, 'Deepa', 'AIML'),
(105, 'Esha', 'MECH');

-- 7. INSERT LOANS
INSERT INTO Loans VALUES
(201, 1, 101, '2026-09-01'),
(202, 3, 101, '2026-09-02'),
(203, 2, 102, '2026-09-03'),
(204, 5, 104, '2026-09-04'),
(205, 4, 103, '2026-09-05');

-- 8. IN OPERATOR
-- Books in Database or Analytics categories
SELECT book_id, title
FROM Books
WHERE category IN ('Database', 'Analytics')
ORDER BY book_id;

-- 9. ANY OPERATOR
-- Books priced above at least one Database book
SELECT book_id, title, price
FROM Books
WHERE price > ANY (
    SELECT price
    FROM Books
    WHERE category = 'Database'
)
ORDER BY book_id;

-- 10. ALL OPERATOR
-- Books priced above every Database book
SELECT book_id, title, price
FROM Books
WHERE price > ALL (
    SELECT price
    FROM Books
    WHERE category = 'Database'
)
ORDER BY book_id;

-- 11. EXISTS OPERATOR
-- Members who borrowed at least one book
SELECT m.member_id, m.member_name
FROM Members m
WHERE EXISTS (
    SELECT 1
    FROM Loans l
    WHERE l.member_id = m.member_id
)
ORDER BY m.member_id;

-- 12. NOT EXISTS OPERATOR
-- Members who never borrowed a book
SELECT m.member_id, m.member_name
FROM Members m
WHERE NOT EXISTS (
    SELECT 1
    FROM Loans l
    WHERE l.member_id = m.member_id
)
ORDER BY m.member_id;

-- 13. IN WITH SUBQUERY
-- Books that have been borrowed
SELECT book_id, title
FROM Books
WHERE book_id IN (
    SELECT book_id
    FROM Loans
)
ORDER BY book_id;

-- 14. UNION OPERATOR
-- CSE or AIML member names
SELECT member_name
FROM Members
WHERE department = 'CSE'
UNION
SELECT member_name
FROM Members
WHERE department = 'AIML'
ORDER BY member_name;

-- 15. INTERSECT OPERATOR
-- CSE members who have borrowed books
SELECT member_id
FROM Members
WHERE department = 'CSE'
INTERSECT
SELECT member_id
FROM Loans
ORDER BY member_id;

-- 16. UNION WITH PRICE CONDITIONS
-- Books priced below 500 or above 750
SELECT title
FROM Books
WHERE price < 500
UNION
SELECT title
FROM Books
WHERE price > 750
ORDER BY title;

-- 17. INTERSECT OPERATOR
-- Programming books that have been borrowed
SELECT book_id
FROM Books
WHERE category = 'Programming'
INTERSECT
SELECT book_id
FROM Loans
ORDER BY book_id;

-- 18. NOT EXISTS
-- Books that have never been borrowed
SELECT b.book_id, b.title
FROM Books b
WHERE NOT EXISTS (
    SELECT 1
    FROM Loans l
    WHERE l.book_id = b.book_id
)
ORDER BY b.book_id;

-- 19. CHECK CONSTRAINT TEST
-- Run separately; an error is expected.
INSERT INTO Books VALUES
(9, 'Invalid Price', 'Test', -50, 2);

-- 20. FOREIGN KEY CONSTRAINT TEST
-- Run separately; an error is expected.
INSERT INTO Loans VALUES
(206, 999, 101, '2026-09-06');

-- 21. VERIFY TABLE COUNTS
SELECT
    (SELECT COUNT(*) FROM Books) AS books,
    (SELECT COUNT(*) FROM Members) AS members,
    (SELECT COUNT(*) FROM Loans) AS loans;

-- Expected: books = 8, members = 5, loans = 5

-- PRACTICE EXERCISES

-- 22. Books priced above ANY Analytics book
SELECT book_id, title, price
FROM Books
WHERE price > ANY (
    SELECT price
    FROM Books
    WHERE category = 'Analytics'
)
ORDER BY book_id;

-- 23. Books priced below ALL Programming books
SELECT book_id, title, price
FROM Books
WHERE price < ALL (
    SELECT price
    FROM Books
    WHERE category = 'Programming'
)
ORDER BY book_id;

-- 24. Members who borrowed a Database book
SELECT m.member_id, m.member_name
FROM Members m
WHERE EXISTS (
    SELECT 1
    FROM Loans l
    JOIN Books b ON l.book_id = b.book_id
    WHERE l.member_id = m.member_id
      AND b.category = 'Database'
)
ORDER BY m.member_id;

-- 25. Members who have never borrowed
SELECT member_id, member_name
FROM Members m
WHERE NOT EXISTS (
    SELECT 1
    FROM Loans l
    WHERE l.member_id = m.member_id
)
ORDER BY member_id;

-- 26. Books borrowed by member 101
SELECT book_id, title
FROM Books
WHERE book_id IN (
    SELECT book_id
    FROM Loans
    WHERE member_id = 101
)
ORDER BY book_id;

-- 27. UNION: Analytics and Cloud titles
SELECT title
FROM Books
WHERE category = 'Analytics'
UNION
SELECT title
FROM Books
WHERE category = 'Cloud'
ORDER BY title;

-- 28. INTERSECT: Books priced over 500 that were borrowed
SELECT book_id
FROM Books
WHERE price > 500
INTERSECT
SELECT book_id
FROM Loans
ORDER BY book_id;

-- 29. UNION ALL: Demonstrate duplicate retention
SELECT member_name
FROM Members
WHERE department = 'CSE'
UNION ALL
SELECT member_name
FROM Members
WHERE member_id IN (101, 103)
ORDER BY member_name;

-- 30. FINAL VERIFICATION
SELECT * FROM Books ORDER BY book_id;
SELECT * FROM Members ORDER BY member_id;
SELECT * FROM Loans ORDER BY loan_id;
