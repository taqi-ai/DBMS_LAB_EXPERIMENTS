-- ============================================================================
-- EXPERIMENT 05: Views, Updatability, and Recursive CTEs
-- ============================================================================
-- Aim: To create SQL views for department salary summary and employee hierarchy,
--      test the updatability of views, and implement a recursive CTE to display
--      reporting chains.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STEP 1: Database Initialization & Safe Reset
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CompanyDB_Exp05;
USE CompanyDB_Exp05;

-- Drop views first, then tables to avoid dependency errors
DROP VIEW IF EXISTS Employee_Hierarchy;
DROP VIEW IF EXISTS Department_Salary_Summary;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

-- ----------------------------------------------------------------------------
-- STEP 2: Schema Creation (Departments & Employees with Manager Hierarchy)
-- ----------------------------------------------------------------------------

CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(100) NOT NULL,
    Job_Title VARCHAR(100),
    Salary DECIMAL(10, 2),
    Dept_ID INT,
    Manager_ID INT NULL,
    CONSTRAINT fk_exp5_emp_dept
        FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_exp5_emp_mgr
        FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- ----------------------------------------------------------------------------
-- STEP 3: Insert Sample Data
-- ----------------------------------------------------------------------------

-- 5 Departments
INSERT INTO Department (Dept_ID, Dept_Name) VALUES 
(1, 'Engineering'), 
(2, 'Sales'), 
(3, 'Human Resources'), 
(4, 'Finance'), 
(5, 'Operations');

-- 30 Employees (Root Managers first with Manager_ID = NULL)
INSERT INTO Employee (Emp_ID, Emp_Name, Job_Title, Salary, Dept_ID, Manager_ID) VALUES 
-- Root Department Managers (Manager_ID IS NULL)
(4,  'Noah Smith',      'Engineering Manager',   85000.00, 1, NULL),
(9,  'Amelia Miller',   'Sales Manager',         78000.00, 2, NULL),
(16, 'Daniel White',    'HR Manager',            80000.00, 3, NULL),
(21, 'Emily Hall',      'Finance Manager',       88000.00, 4, NULL),
(27, 'Chloe Green',     'Operations Manager',    82000.00, 5, NULL),

-- Engineering Team (Reporting to Noah Smith - ID 4)
(1,  'Ava Patel',       'Developer',             60000.00, 1, 4),
(2,  'Liam Chen',       'Developer',             62000.00, 1, 4),
(3,  'Mia Garcia',      'Analyst',               58000.00, 1, 4),
(5,  'Olivia Jones',    'Developer',             61000.00, 1, 4),
(6,  'Ethan Brown',     'Analyst',               59000.00, 1, 4),

-- Sales Team (Reporting to Amelia Miller - ID 9)
(7,  'Sophia Wilson',   'Sales Representative',  52000.00, 2, 9),
(8,  'Lucas Davis',     'Sales Representative',  54000.00, 2, 9),
(10, 'James Taylor',    'Sales Representative',  51000.00, 2, 9),
(11, 'Isabella Anderson','Sales Representative', 53000.00, 2, 9),
(12, 'Benjamin Thomas', 'Sales Representative',  55000.00, 2, 9),

-- HR Team (Reporting to Daniel White - ID 16)
(13, 'Charlotte Moore', 'HR Specialist',         57000.00, 3, 16),
(14, 'Elijah Martin',   'HR Specialist',         56000.00, 3, 16),
(15, 'Harper Lee',      'Recruiter',             59000.00, 3, 16),
(17, 'Evelyn Harris',   'HR Specialist',         58000.00, 3, 16),
(18, 'Henry Clark',     'Recruiter',             60000.00, 3, 16),

-- Finance Team (Reporting to Emily Hall - ID 21)
(19, 'Abigail Lewis',   'Accountant',            63000.00, 4, 21),
(20, 'Sebastian Walker','Accountant',            64000.00, 4, 21),
(22, 'Jack Allen',      'Accountant',            65000.00, 4, 21),
(23, 'Ella Young',      'Financial Analyst',     67000.00, 4, 21),
(24, 'Owen King',       'Financial Analyst',     66000.00, 4, 21),

-- Operations Team (Reporting to Chloe Green - ID 27)
(25, 'Grace Wright',    'Operations Specialist', 55000.00, 5, 27),
(26, 'Matthew Scott',   'Operations Specialist', 56000.00, 5, 27),
(28, 'Wyatt Baker',     'Operations Specialist', 57000.00, 5, 27),
(29, 'Lily Adams',      'Coordinator',           52000.00, 5, 27),
(30, 'Gabriel Nelson',  'Coordinator',           54000.00, 5, 27);

-- ----------------------------------------------------------------------------
-- STEP 4: View 1 - Department Salary Summary (Aggregate View)
-- ----------------------------------------------------------------------------
CREATE VIEW Department_Salary_Summary AS 
SELECT 
    D.Dept_ID, 
    D.Dept_Name, 
    COUNT(E.Emp_ID) AS Total_Employees, 
    AVG(E.Salary) AS Average_Salary, 
    MAX(E.Salary) AS Maximum_Salary, 
    MIN(E.Salary) AS Minimum_Salary 
FROM Department D 
LEFT JOIN Employee E 
    ON D.Dept_ID = E.Dept_ID 
GROUP BY D.Dept_ID, D.Dept_Name;

SELECT '--- View: Department Salary Summary ---' AS Query_Section;
SELECT * FROM Department_Salary_Summary;

-- ----------------------------------------------------------------------------
-- STEP 5: View 2 - Employee Hierarchy (Self-Join View)
-- ----------------------------------------------------------------------------
CREATE VIEW Employee_Hierarchy AS 
SELECT 
    E.Emp_ID, 
    E.Emp_Name, 
    E.Job_Title, 
    E.Salary, 
    E.Manager_ID, 
    M.Emp_Name AS Manager_Name 
FROM Employee E 
LEFT JOIN Employee M 
    ON E.Manager_ID = M.Emp_ID;

SELECT '--- View: Employee Hierarchy ---' AS Query_Section;
SELECT * FROM Employee_Hierarchy;

-- ----------------------------------------------------------------------------
-- STEP 6: View Updatability Tests
-- ----------------------------------------------------------------------------
-- View Updatability Rule in MySQL:
-- 1. Views containing aggregates (COUNT, AVG, MIN, MAX) or GROUP BY are NOT updatable.
-- 2. Simple views or underlying table modifications reflect immediately in view outputs.

-- Update salary in underlying table and verify reflection in views
SELECT '--- Updatability Demonstration: Modifying Base Table ---' AS Query_Section;
UPDATE Employee 
SET Salary = 63500.00 
WHERE Emp_ID = 1;

-- Check updated value in base table and views
SELECT Emp_ID, Emp_Name, Salary FROM Employee WHERE Emp_ID = 1;
SELECT * FROM Department_Salary_Summary WHERE Dept_ID = 1;
SELECT * FROM Employee_Hierarchy WHERE Emp_ID = 1;

-- Optional test: Attempting to update the non-updatable aggregate view
-- This will fail with MySQL Error 1288 (The target table ... of the UPDATE is not updatable)
/*
UPDATE Department_Salary_Summary
SET Average_Salary = 70000
WHERE Dept_ID = 1;
*/

-- ----------------------------------------------------------------------------
-- STEP 7: Recursive CTE - Reporting Chains & Organizational Depth
-- ----------------------------------------------------------------------------
-- Anchor member: Select root managers (where Manager_ID IS NULL) at Level 1.
-- Recursive member: Join Employee with CTE to traverse down the reporting chain.
SELECT '--- Recursive CTE: Reporting Chain Hierarchy ---' AS Query_Section;
WITH RECURSIVE Employee_Chain AS 
( 
    -- Anchor Member
    SELECT 
        Emp_ID, 
        Emp_Name, 
        Job_Title,
        Manager_ID, 
        1 AS Level 
    FROM Employee 
    WHERE Manager_ID IS NULL 

    UNION ALL 

    -- Recursive Member
    SELECT 
        E.Emp_ID, 
        E.Emp_Name, 
        E.Job_Title,
        E.Manager_ID, 
        EC.Level + 1 
    FROM Employee E 
    INNER JOIN Employee_Chain EC 
        ON E.Manager_ID = EC.Emp_ID 
) 
SELECT 
    Emp_ID, 
    Emp_Name, 
    Job_Title,
    Manager_ID, 
    Level 
FROM Employee_Chain 
ORDER BY Level, Emp_ID;
