-- library_setup.sql : SAMPLE data for practice (MySQL 8.0+)
-- Name: NIHAL NAREN NAIK | BCA 3rd Sem | Section C
-- NOTE: Use your teacher's official library_setup.sql for the real project.
--       This file is for practice and has the same table structure.

DROP DATABASE IF EXISTS librarydb;
CREATE DATABASE librarydb;
USE librarydb;

CREATE TABLE members (
  member_id   INT PRIMARY KEY,
  member_name VARCHAR(50) NOT NULL,
  member_type VARCHAR(10) NOT NULL CHECK (member_type IN ('Student','Faculty')),
  joined_date DATE
);

CREATE TABLE books (
  book_id          INT PRIMARY KEY,
  title            VARCHAR(100) NOT NULL,
  author           VARCHAR(60),
  category         VARCHAR(30),
  price            DECIMAL(8,2),
  copies_available INT
);

CREATE TABLE issues (
  issue_id    INT PRIMARY KEY,
  member_id   INT NOT NULL,
  book_id     INT NOT NULL,
  issue_date  DATE,
  due_date    DATE,
  return_date DATE NULL,
  FOREIGN KEY (member_id) REFERENCES members(member_id),
  FOREIGN KEY (book_id)   REFERENCES books(book_id)
);

INSERT INTO members VALUES
  (1, 'Aarav Sharma', 'Student', '2024-07-01'),
  (2, 'Priya Nair', 'Student', '2024-07-03'),
  (3, 'Rohan Mehta', 'Student', '2024-08-10'),
  (4, 'Dr. Anita Rao', 'Faculty', '2020-06-15'),
  (5, 'Prof. Suresh Kumar', 'Faculty', '2019-01-20'),
  (6, 'Sneha Reddy', 'Student', '2025-01-12'),
  (7, 'Imran Khan', 'Student', '2025-02-05'),
  (8, 'Kavya Iyer', 'Student', '2025-07-18'),
  (9, 'Dr. Mohan Das', 'Faculty', '2021-09-01'),
  (10, 'Neha Gupta', 'Student', '2025-08-22'),
  (11, 'Vikram Singh', 'Student', '2025-09-09'),
  (12, 'Pooja Patel', 'Student', '2025-09-15');

INSERT INTO books VALUES
  (1, 'Database System Concepts', 'Silberschatz', 'Computer Science', 650, 3),
  (2, 'Let Us C', 'Yashavant Kanetkar', 'Computer Science', 350, 0),
  (3, 'Python Crash Course', 'Eric Matthes', 'Computer Science', 500, 2),
  (4, 'Wings of Fire', 'A.P.J. Abdul Kalam', 'Biography', 250, 4),
  (5, 'The Discovery of India', 'Jawaharlal Nehru', 'History', 400, 2),
  (6, 'Concept of Physics', 'H.C. Verma', 'Science', 450, 0),
  (7, 'Engineering Mathematics', 'B.S. Grewal', 'Mathematics', 600, 5),
  (8, 'Malgudi Days', 'R.K. Narayan', 'Fiction', 200, 3),
  (9, 'The Guide', 'R.K. Narayan', 'Fiction', 220, 1),
  (10, 'Operating System Concepts', 'Galvin', 'Computer Science', 700, 2),
  (11, 'Indian Polity', 'M. Laxmikanth', 'Civics', 550, 2),
  (12, 'Organic Chemistry', 'Morrison and Boyd', 'Science', 800, 1);

INSERT INTO issues VALUES
  (1, 1, 1, '2026-08-01', '2026-08-15', '2026-08-14'),
  (2, 1, 2, '2026-08-20', '2026-09-03', '2026-09-10'),
  (3, 2, 2, '2026-08-05', '2026-08-19', '2026-08-25'),
  (4, 2, 3, '2026-09-01', '2026-09-15', '2026-09-14'),
  (5, 3, 1, '2026-09-05', '2026-09-19', '2026-09-30'),
  (6, 3, 3, '2026-09-10', '2026-09-24', '2026-09-22'),
  (7, 4, 1, '2026-08-10', '2026-08-24', '2026-08-23'),
  (8, 4, 10, '2026-09-15', '2026-09-29', '2026-10-02'),
  (9, 5, 5, '2026-08-12', '2026-08-26', '2026-08-26'),
  (10, 5, 11, '2026-09-20', '2026-10-04', NULL),
  (11, 6, 4, '2026-09-02', '2026-09-16', '2026-09-18'),
  (12, 6, 2, '2026-10-01', '2026-10-15', NULL),
  (13, 7, 6, '2026-10-05', '2026-10-19', NULL),
  (14, 7, 3, '2026-08-25', '2026-09-08', '2026-09-20'),
  (15, 8, 8, '2026-09-12', '2026-09-26', '2026-09-25'),
  (16, 8, 9, '2026-10-02', '2026-10-16', '2026-10-14'),
  (17, 9, 7, '2026-08-18', '2026-09-01', '2026-09-01'),
  (18, 9, 12, '2026-10-10', '2026-10-24', NULL),
  (19, 10, 1, '2026-10-12', '2026-10-26', NULL),
  (20, 10, 4, '2026-09-25', '2026-10-09', '2026-10-12'),
  (21, 1, 3, '2026-10-08', '2026-10-22', '2026-10-20'),
  (22, 2, 1, '2026-10-14', '2026-10-28', NULL),
  (23, 3, 2, '2026-09-28', '2026-10-12', '2026-10-20'),
  (24, 4, 3, '2026-10-03', '2026-10-17', '2026-10-16'),
  (25, 6, 1, '2026-10-20', '2026-11-03', '2026-11-02');
