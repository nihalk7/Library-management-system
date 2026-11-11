# Practice Sheet: Sample Data + All Questions, Queries and Expected Output

Name: **NIHAL NAREN NAIK** | BCA 3rd Sem | Section C

Load `library_setup.sql` (12 members, 12 books, 25 issues) and run each query. Your output must match the table shown. Dates are 2026 and fine = Rs. 2 per late day.

## C1. ERD
See `ERD.png`. members (1) ---< (N) issues (N) >--- (1) books. PK: member_id, book_id, issue_id. FK in issues: member_id, book_id.

## C2. How many members, books and issue records are there?
```sql
SELECT (SELECT COUNT(*) FROM members) AS total_members, (SELECT COUNT(*) FROM books) AS total_books, (SELECT COUNT(*) FROM issues) AS total_issue_records;
```
**Idea:** COUNT(*) on each table, put side by side with scalar subqueries.

**Expected output:**

| total_members | total_books | total_issue_records |
|---|---|---|
| 12 | 12 | 25 |

## C3. How many titles and total copies in each category?
```sql
SELECT category, COUNT(*) AS total_titles, SUM(copies_available) AS total_copies FROM books GROUP BY category ORDER BY total_titles DESC, category;
```
**Idea:** GROUP BY makes one row per category; COUNT and SUM work inside each group.

**Expected output:**

| category | total_titles | total_copies |
|---|---|---|
| Computer Science | 4 | 7 |
| Fiction | 2 | 4 |
| Science | 2 | 1 |
| Biography | 1 | 4 |
| Civics | 1 | 2 |
| History | 1 | 2 |
| Mathematics | 1 | 5 |

## C4. Top 5 most borrowed books
```sql
SELECT b.book_id, b.title, COUNT(i.issue_id) AS times_borrowed FROM books b JOIN issues i ON i.book_id = b.book_id GROUP BY b.book_id, b.title ORDER BY times_borrowed DESC, b.book_id LIMIT 5;
```
**Idea:** Join books to issues, count issues per book, sort high to low, keep 5.

**Expected output:**

| book_id | title | times_borrowed |
|---|---|---|
| 1 | Database System Concepts | 6 |
| 3 | Python Crash Course | 5 |
| 2 | Let Us C | 4 |
| 4 | Wings of Fire | 2 |
| 5 | The Discovery of India | 1 |

## C5. Members who have never borrowed a book
```sql
SELECT m.member_id, m.member_name, m.member_type FROM members m LEFT JOIN issues i ON i.member_id = m.member_id WHERE i.issue_id IS NULL;
```
**Idea:** LEFT JOIN keeps every member; NULL on the issues side means no match = never borrowed.

**Expected output:**

| member_id | member_name | member_type |
|---|---|---|
| 11 | Vikram Singh | Student |
| 12 | Pooja Patel | Student |

## C6. Books currently issued (not returned): member, title, due date
```sql
SELECT m.member_name, b.title, i.due_date FROM issues i JOIN members m ON m.member_id = i.member_id JOIN books b ON b.book_id = i.book_id WHERE i.return_date IS NULL ORDER BY i.due_date;
```
**Idea:** Three-table join; return_date IS NULL means not yet returned.

**Expected output:**

| member_name | title | due_date |
|---|---|---|
| Prof. Suresh Kumar | Indian Polity | 2026-10-04 |
| Sneha Reddy | Let Us C | 2026-10-15 |
| Imran Khan | Concept of Physics | 2026-10-19 |
| Dr. Mohan Das | Organic Chemistry | 2026-10-24 |
| Neha Gupta | Database System Concepts | 2026-10-26 |
| Priya Nair | Database System Concepts | 2026-10-28 |

## C7. Books returned late with days late and fine (Rs. 2/day)
```sql
SELECT i.issue_id, m.member_name, b.title, i.due_date, i.return_date, DATEDIFF(i.return_date, i.due_date) AS days_late, DATEDIFF(i.return_date, i.due_date) * 2 AS fine_rs FROM issues i JOIN members m ON m.member_id = i.member_id JOIN books b ON b.book_id = i.book_id WHERE i.return_date IS NOT NULL AND i.return_date > i.due_date ORDER BY fine_rs DESC, i.issue_id;
```
**Idea:** Late = return_date after due_date. DATEDIFF gives days; multiply by 2.

**Expected output:**

| issue_id | member_name | title | due_date | return_date | days_late | fine_rs |
|---|---|---|---|---|---|---|
| 14 | Imran Khan | Python Crash Course | 2026-09-08 | 2026-09-20 | 12 | 24 |
| 5 | Rohan Mehta | Database System Concepts | 2026-09-19 | 2026-09-30 | 11 | 22 |
| 23 | Rohan Mehta | Let Us C | 2026-10-12 | 2026-10-20 | 8 | 16 |
| 2 | Aarav Sharma | Let Us C | 2026-09-03 | 2026-09-10 | 7 | 14 |
| 3 | Priya Nair | Let Us C | 2026-08-19 | 2026-08-25 | 6 | 12 |
| 8 | Dr. Anita Rao | Operating System Concepts | 2026-09-29 | 2026-10-02 | 3 | 6 |
| 20 | Neha Gupta | Wings of Fire | 2026-10-09 | 2026-10-12 | 3 | 6 |
| 11 | Sneha Reddy | Wings of Fire | 2026-09-16 | 2026-09-18 | 2 | 4 |

## C8. Total fine per member (only members with a fine)
```sql
SELECT m.member_id, m.member_name, SUM(DATEDIFF(i.return_date, i.due_date) * 2) AS total_fine_rs FROM issues i JOIN members m ON m.member_id = i.member_id WHERE i.return_date > i.due_date GROUP BY m.member_id, m.member_name HAVING total_fine_rs > 0 ORDER BY total_fine_rs DESC, m.member_id;
```
**Idea:** SUM the fines per member; HAVING filters after grouping.

**Expected output:**

| member_id | member_name | total_fine_rs |
|---|---|---|
| 3 | Rohan Mehta | 38 |
| 7 | Imran Khan | 24 |
| 1 | Aarav Sharma | 14 |
| 2 | Priya Nair | 12 |
| 4 | Dr. Anita Rao | 6 |
| 10 | Neha Gupta | 6 |
| 6 | Sneha Reddy | 4 |

## C9. Student vs Faculty: books borrowed
```sql
SELECT m.member_type, COUNT(i.issue_id) AS books_borrowed FROM members m JOIN issues i ON i.member_id = m.member_id GROUP BY m.member_type;
```
**Idea:** Join members to issues and group by member_type.

**Expected output:**

| member_type | books_borrowed |
|---|---|
| Faculty | 7 |
| Student | 18 |

## C10. Rank members by number of books borrowed (RANK)
```sql
SELECT m.member_id, m.member_name, COUNT(i.issue_id) AS books_borrowed, RANK() OVER (ORDER BY COUNT(i.issue_id) DESC) AS borrow_rank FROM members m LEFT JOIN issues i ON i.member_id = m.member_id GROUP BY m.member_id, m.member_name ORDER BY borrow_rank, m.member_name;
```
**Idea:** RANK gives equal rank to ties and skips the next number (1,2,2,4).

**Expected output:**

| member_id | member_name | books_borrowed | borrow_rank |
|---|---|---|---|
| 1 | Aarav Sharma | 3 | 1 |
| 4 | Dr. Anita Rao | 3 | 1 |
| 2 | Priya Nair | 3 | 1 |
| 3 | Rohan Mehta | 3 | 1 |
| 6 | Sneha Reddy | 3 | 1 |
| 9 | Dr. Mohan Das | 2 | 6 |
| 7 | Imran Khan | 2 | 6 |
| 8 | Kavya Iyer | 2 | 6 |
| 10 | Neha Gupta | 2 | 6 |
| 5 | Prof. Suresh Kumar | 2 | 6 |
| 12 | Pooja Patel | 0 | 11 |
| 11 | Vikram Singh | 0 | 11 |

## C11. Most popular category (issues per category)
```sql
SELECT b.category, COUNT(i.issue_id) AS total_issues FROM issues i JOIN books b ON b.book_id = i.book_id GROUP BY b.category ORDER BY total_issues DESC, b.category;
```
**Idea:** Join issues to books, group by category, count.

**Expected output:**

| category | total_issues |
|---|---|
| Computer Science | 16 |
| Biography | 2 |
| Fiction | 2 |
| Science | 2 |
| Civics | 1 |
| History | 1 |
| Mathematics | 1 |

## C12. Books with 0 copies available AND pending issues (subquery)
```sql
SELECT b.book_id, b.title, b.copies_available FROM books b WHERE b.copies_available = 0 AND b.book_id IN (SELECT i.book_id FROM issues i WHERE i.return_date IS NULL);
```
**Idea:** Inner query = books with pending issues; outer query keeps those with 0 copies.

**Expected output:**

| book_id | title | copies_available |
|---|---|---|
| 2 | Let Us C | 0 |
| 6 | Concept of Physics | 0 |

## C13 (test). member_history(1): all books borrowed by member 1
```sql
SELECT m.member_name, b.title, b.author, i.issue_date, i.due_date, i.return_date FROM issues i JOIN members m ON m.member_id = i.member_id JOIN books b ON b.book_id = i.book_id WHERE i.member_id = 1 ORDER BY i.issue_date;
```
**Idea:** This is the SELECT inside the procedure; CALL member_history(1) returns exactly this.

**Expected output:**

| member_name | title | author | issue_date | due_date | return_date |
|---|---|---|---|---|---|
| Aarav Sharma | Database System Concepts | Silberschatz | 2026-08-01 | 2026-08-15 | 2026-08-14 |
| Aarav Sharma | Let Us C | Yashavant Kanetkar | 2026-08-20 | 2026-09-03 | 2026-09-10 |
| Aarav Sharma | Python Crash Course | Eric Matthes | 2026-10-08 | 2026-10-22 | 2026-10-20 |

## C13. Stored procedure
```sql
DELIMITER //
CREATE PROCEDURE member_history(IN p_member_id INT)
BEGIN
    SELECT m.member_name, b.title, b.author, i.issue_date, i.due_date, i.return_date
    FROM issues i
    JOIN members m ON m.member_id = i.member_id
    JOIN books b ON b.book_id = i.book_id
    WHERE i.member_id = p_member_id
    ORDER BY i.issue_date;
END //
DELIMITER ;
CALL member_history(1);
```
Result of the CALL is the C13 table above.

## C14. Trigger
```sql
CREATE TABLE books_copy AS SELECT * FROM books;
CREATE TABLE issues_copy AS SELECT * FROM issues;
DELIMITER //
CREATE TRIGGER trg_reduce_copies AFTER INSERT ON issues_copy
FOR EACH ROW
BEGIN
    UPDATE books_copy SET copies_available = copies_available - 1 WHERE book_id = NEW.book_id;
END //
DELIMITER ;
SELECT book_id, title, copies_available FROM books_copy WHERE book_id = 1;   -- BEFORE
INSERT INTO issues_copy VALUES (9001, 1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL);
SELECT book_id, title, copies_available FROM books_copy WHERE book_id = 1;   -- AFTER
```
**Expected:** BEFORE copies_available = 3, AFTER = 2 (reduced by 1).

## C15. Conclusion (from this sample data)
- **Buy more copies:** Database System Concepts (borrowed 6 times, most popular), Python Crash Course (5) and Let Us C (4). Let Us C and Concept of Physics have 0 copies and still have pending issues (C12), so members are waiting. Computer Science is the most popular category with 16 of 25 issues (C11).
- **Reminders:** members with unreturned books (C6), especially Prof. Suresh Kumar (due 2026-10-04, oldest overdue) and Sneha Reddy, Imran Khan, Dr. Mohan Das, Neha Gupta and Priya Nair. Members with the highest fines (C8): Rohan Mehta (Rs. 38), Imran Khan (Rs. 24), Aarav Sharma (Rs. 14).
- **Reduce late returns:** SMS/email reminders 2 days before the due date, allow one renewal, block new issues until fines are paid, and shorter loan periods for high-demand books.

Extra observations: Faculty borrowed 7 books and Students 18. Vikram Singh and Pooja Patel never borrowed (C5), so the library can send them a welcome or awareness message.
