-- =====================================================================
--  SQL Section C - Research Project : College Library Management
--  Name    : NIHAL NAREN NAIK
--  Class   : BCA 3rd Semester, Section C
--  Database: librarydb   (load first with library_setup.sql)
--  Tested for MySQL 8.0+ (RANK() needs 8.0)
-- =====================================================================

USE librarydb;

-- ---------------------------------------------------------------------
-- Look at every table first
-- ---------------------------------------------------------------------
SELECT * FROM members LIMIT 10;
SELECT * FROM books   LIMIT 10;
SELECT * FROM issues  LIMIT 10;

-- =====================================================================
-- PHASE 1 : KNOW YOUR DATA
-- =====================================================================

-- C1 : ERD -> see ERD.png / ERD.svg
--   members (1) ----< (N) issues (N) >---- (1) books
--   issues.member_id -> members.member_id (FK)
--   issues.book_id   -> books.book_id     (FK)

-- C2 : Count of members, books and issue records
SELECT
    (SELECT COUNT(*) FROM members) AS total_members,
    (SELECT COUNT(*) FROM books)   AS total_books,
    (SELECT COUNT(*) FROM issues)  AS total_issue_records;

-- =====================================================================
-- PHASE 2 : BUSINESS QUESTIONS
-- =====================================================================

-- C3 : Titles and total copies in each category
SELECT category,
       COUNT(*)              AS total_titles,
       SUM(copies_available) AS total_copies
FROM books
GROUP BY category
ORDER BY total_titles DESC;

-- C4 : Top 5 most borrowed books
SELECT b.book_id, b.title, COUNT(i.issue_id) AS times_borrowed
FROM books b
JOIN issues i ON i.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC
LIMIT 5;

-- C5 : Members who have never borrowed a book (LEFT JOIN ... IS NULL)
SELECT m.member_id, m.member_name, m.member_type
FROM members m
LEFT JOIN issues i ON i.member_id = m.member_id
WHERE i.issue_id IS NULL;

-- C6 : Books currently issued (not returned): member, title, due date
SELECT m.member_name, b.title, i.due_date
FROM issues i
JOIN members m ON m.member_id = i.member_id
JOIN books   b ON b.book_id   = i.book_id
WHERE i.return_date IS NULL
ORDER BY i.due_date;

-- C7 : Books returned late, days late and fine (Rs. 2 per day)
SELECT i.issue_id, m.member_name, b.title,
       i.due_date, i.return_date,
       DATEDIFF(i.return_date, i.due_date)     AS days_late,
       DATEDIFF(i.return_date, i.due_date) * 2 AS fine_rs
FROM issues i
JOIN members m ON m.member_id = i.member_id
JOIN books   b ON b.book_id   = i.book_id
WHERE i.return_date IS NOT NULL
  AND i.return_date > i.due_date
ORDER BY fine_rs DESC;

-- C8 : Total fine per member (only members with a fine)
SELECT m.member_id, m.member_name,
       SUM(DATEDIFF(i.return_date, i.due_date) * 2) AS total_fine_rs
FROM issues i
JOIN members m ON m.member_id = i.member_id
WHERE i.return_date > i.due_date
GROUP BY m.member_id, m.member_name
HAVING total_fine_rs > 0
ORDER BY total_fine_rs DESC;

-- C9 : Student vs Faculty usage
SELECT m.member_type, COUNT(i.issue_id) AS books_borrowed
FROM members m
JOIN issues i ON i.member_id = m.member_id
GROUP BY m.member_type;

-- C10 : Rank members by number of books borrowed (RANK window function)
SELECT m.member_id, m.member_name,
       COUNT(i.issue_id) AS books_borrowed,
       RANK() OVER (ORDER BY COUNT(i.issue_id) DESC) AS borrow_rank
FROM members m
LEFT JOIN issues i ON i.member_id = m.member_id
GROUP BY m.member_id, m.member_name
ORDER BY borrow_rank, m.member_name;

-- C11 : Most popular category (issues per category)
SELECT b.category, COUNT(i.issue_id) AS total_issues
FROM issues i
JOIN books b ON b.book_id = i.book_id
GROUP BY b.category
ORDER BY total_issues DESC;

-- C12 : Books with zero copies available AND pending issues (subquery)
SELECT b.book_id, b.title, b.copies_available
FROM books b
WHERE b.copies_available = 0
  AND b.book_id IN (SELECT i.book_id
                    FROM issues i
                    WHERE i.return_date IS NULL);

-- =====================================================================
-- PHASE 3 : AUTOMATE  (work on COPIES so original data stays safe)
-- =====================================================================

-- C13 : Stored procedure - all books borrowed by one member
DROP PROCEDURE IF EXISTS member_history;
DELIMITER //
CREATE PROCEDURE member_history(IN p_member_id INT)
BEGIN
    SELECT m.member_name, b.title, b.author,
           i.issue_date, i.due_date, i.return_date
    FROM issues i
    JOIN members m ON m.member_id = i.member_id
    JOIN books   b ON b.book_id   = i.book_id
    WHERE i.member_id = p_member_id
    ORDER BY i.issue_date;
END //
DELIMITER ;

-- Test call (change 1 to any valid member_id)
CALL member_history(1);

-- C14 : Trigger on copies of the tables
DROP TABLE IF EXISTS issues_copy;
DROP TABLE IF EXISTS books_copy;
CREATE TABLE books_copy  AS SELECT * FROM books;
CREATE TABLE issues_copy AS SELECT * FROM issues;

DROP TRIGGER IF EXISTS trg_reduce_copies;
DELIMITER //
CREATE TRIGGER trg_reduce_copies
AFTER INSERT ON issues_copy
FOR EACH ROW
BEGIN
    UPDATE books_copy
    SET copies_available = copies_available - 1
    WHERE book_id = NEW.book_id;
END //
DELIMITER ;

-- Test: BEFORE
SELECT book_id, title, copies_available FROM books_copy WHERE book_id = 1;

-- Insert a new issue (issue_id 9001 chosen to avoid clashes; use valid member/book ids)
INSERT INTO issues_copy (issue_id, member_id, book_id, issue_date, due_date, return_date)
VALUES (9001, 1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL);

-- Test: AFTER  -> copies_available must be 1 less than BEFORE
SELECT book_id, title, copies_available FROM books_copy WHERE book_id = 1;

-- =====================================================================
-- PHASE 4 : CONCLUSION (C15) -> see README.txt
-- Supporting queries: C4 (popular), C6 (pending), C7/C8 (late & fines),
-- C12 (out of stock + pending)
-- =====================================================================
