-- ============================================================================
-- EXPERIMENT 02: College Database Schema & Referential Integrity Constraints
-- ============================================================================
-- Aim: To design and implement a College Database relational schema, create MySQL
--      tables with Primary Key, NOT NULL, UNIQUE, ON DELETE CASCADE, and
--      ON DELETE SET NULL constraints, insert sample records, and demonstrate
--      referential integrity enforcement and cascading actions.
--
-- Tables:
--   1. Department (Dept_Id, Dept_Name)
--   2. Student    (Student_Id, Student_Name, Email, Dept_Id)
--   3. Course     (Course_Id, Course_Name, Credits)
--   4. Enrollment (Enroll_Id, Student_Id, Course_Id)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STEP 1: Database Initialization
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CollegeDB;
USE CollegeDB;

-- ----------------------------------------------------------------------------
-- STEP 2: Clean Reset (Drop child tables first, then parent tables)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;

-- ----------------------------------------------------------------------------
-- STEP 3: Table Creation with Constraints
-- ----------------------------------------------------------------------------

-- Parent Table 1: Department
CREATE TABLE Department (
    Dept_Id INT PRIMARY KEY,
    Dept_Name VARCHAR(50) NOT NULL UNIQUE
);

-- Parent Table 2: Course
CREATE TABLE Course (
    Course_Id INT PRIMARY KEY,
    Course_Name VARCHAR(50) NOT NULL,
    Credits INT NOT NULL
);

-- Child Table 1: Student (References Department with ON DELETE SET NULL)
CREATE TABLE Student (
    Student_Id INT PRIMARY KEY,
    Student_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Dept_Id INT NULL,
    CONSTRAINT fk_student_dept
        FOREIGN KEY (Dept_Id) 
        REFERENCES Department(Dept_Id) 
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Child Table 2: Enrollment (References Student & Course with ON DELETE CASCADE)
CREATE TABLE Enrollment (
    Enroll_Id INT PRIMARY KEY,
    Student_Id INT NOT NULL,
    Course_Id INT NOT NULL,
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (Student_Id) 
        REFERENCES Student(Student_Id) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_course
        FOREIGN KEY (Course_Id) 
        REFERENCES Course(Course_Id) 
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ----------------------------------------------------------------------------
-- STEP 4: Insert Sample Records (As recorded in lab notebook)
-- ----------------------------------------------------------------------------

-- Departments
INSERT INTO Department (Dept_Id, Dept_Name) VALUES
(1, 'CSE'),
(2, 'AIML');

-- Students
INSERT INTO Student (Student_Id, Student_Name, Email, Dept_Id) VALUES
(101, 'Rahul', 'rahul@gmail.com', 1),
(102, 'Vansh', 'vansh@gmail.com', 2);

-- Courses
INSERT INTO Course (Course_Id, Course_Name, Credits) VALUES
(201, 'DBMS', 4),
(202, 'OPERATING SYSTEM', 4);

-- Enrollments
INSERT INTO Enrollment (Enroll_Id, Student_Id, Course_Id) VALUES
(1, 101, 201),
(2, 102, 202);

-- ----------------------------------------------------------------------------
-- STEP 5: Verification Queries (Display Base Tables)
-- ----------------------------------------------------------------------------

SELECT '--- Department Table ---' AS Output_Section;
SELECT Dept_Id, Dept_Name FROM Department;

SELECT '--- Student Table ---' AS Output_Section;
SELECT Student_Id, Student_Name, Email, Dept_Id FROM Student;

SELECT '--- Course Table ---' AS Output_Section;
SELECT Course_Id, Course_Name, Credits FROM Course;

SELECT '--- Enrollment Table ---' AS Output_Section;
SELECT Enroll_Id, Student_Id, Course_Id FROM Enrollment;

-- Comprehensive Join View: Student Enrollment Details
SELECT '--- Consolidated Student Enrollment View ---' AS Output_Section;
SELECT 
    e.Enroll_Id,
    s.Student_Id,
    s.Student_Name,
    s.Email,
    d.Dept_Name,
    c.Course_Id,
    c.Course_Name,
    c.Credits
FROM Enrollment e
JOIN Student s ON e.Student_Id = s.Student_Id
LEFT JOIN Department d ON s.Dept_Id = d.Dept_Id
JOIN Course c ON e.Course_Id = c.Course_Id;

-- ----------------------------------------------------------------------------
-- STEP 6: Optional Referential Integrity & Constraint Tests
-- Note: These demonstrations are commented out so the sample dataset remains
--       intact for subsequent inspections. Uncomment individual blocks to test.
-- ----------------------------------------------------------------------------

/*
-- TEST A: Demonstrate ON DELETE SET NULL
-- When Department 1 is deleted, Rahul's Dept_Id will automatically become NULL.
DELETE FROM Department WHERE Dept_Id = 1;
SELECT * FROM Student;

-- TEST B: Demonstrate ON DELETE CASCADE
-- When Student 101 is deleted, Enrollment record 1 is automatically removed.
DELETE FROM Student WHERE Student_Id = 101;
SELECT * FROM Enrollment;

-- TEST C: Demonstrate Referential Integrity Violation (Expected Error: 1452)
-- Attempting to insert an enrollment with a non-existent student ID (999).
-- INSERT INTO Enrollment (Enroll_Id, Student_Id, Course_Id) VALUES (3, 999, 201);

-- TEST D: Demonstrate UNIQUE Constraint Violation (Expected Error: 1062)
-- Attempting to insert a duplicate email.
-- INSERT INTO Student (Student_Id, Student_Name, Email, Dept_Id) 
-- VALUES (103, 'Aman', 'rahul@gmail.com', 2);
*/
