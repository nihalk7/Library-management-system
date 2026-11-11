College Library Management - SQL Section C Research Project
Name : NIHAL NAREN NAIK
Class: BCA 3rd Semester, Section C

HOW TO RUN
1. Open MySQL 8.0+ (Workbench / command line).
2. Run library_setup.sql to create and fill the database librarydb.
3. Run library_project.sql (all queries C2 - C14, with comments).
   Command line:  mysql -u root -p < library_project.sql
4. ERD is in ERD.png (ERD.svg is the same drawing).
Note: C13 and C14 use CALL / copies of tables (books_copy, issues_copy),
so original data is never changed.

FILES
library_project.sql  - all queries, procedure, trigger, tests
ERD.png / ERD.svg    - entity relationship diagram
README.txt           - this file

C15 - CONCLUSION  (fill the <...> from YOUR query output before submitting)
1. Books to buy more copies of:
   Books at the top of C4 (most borrowed) and books in C12 (0 copies left
   but still pending returns) are in highest demand: <titles from C4/C12>.
   The most popular category (C11) <category> should get priority in budget.
2. Members who should get a reminder:
   Members in C6 whose due_date has already passed (currently holding
   books overdue), and members with the highest fines in C8:
   <names from C6 / C8>.
3. Suggestions to reduce late returns:
   - Send SMS/email reminders 2 days before the due date.
   - Increase the fine gradually or block new issues until fines are paid.
   - Allow renewals once, so honest borrowers need not return late.
   - Shorter loan period for high-demand books (C4), longer for others.
   - Keep extra copies of popular books so waiting members are not stuck.

WHAT I LEARNED
JOINs (INNER and LEFT), GROUP BY / HAVING, DATEDIFF for fines, subqueries,
RANK() window function, stored procedures and triggers.
