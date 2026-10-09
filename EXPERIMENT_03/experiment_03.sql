-- ============================================================================
-- EXPERIMENT 03: Employee-Department-Project Queries & Aggregations
-- ============================================================================
-- Aim: Create an Employee-Department-Project schema. Insert at least 30 
--      employees across 5 departments and 8 projects. Write SQL queries 
--      demonstrating selection, projection, aggregates, GROUP BY, HAVING, 
--      CASE expressions, and ORDER BY.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STEP 1: Database Initialization & Safe Reset
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CompanyDB_Exp03;
USE CompanyDB_Exp03;

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;

-- ----------------------------------------------------------------------------
-- STEP 2: Table Creation
-- ----------------------------------------------------------------------------

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50) NOT NULL,
    dept_id INT,
    CONSTRAINT fk_project_dept
        FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    dept_id INT,
    project_id INT,
    salary DECIMAL(10,2) NOT NULL,
    city VARCHAR(50) NOT NULL,
    CONSTRAINT fk_employee_dept
        FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_employee_proj
        FOREIGN KEY (project_id) REFERENCES Project(project_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ----------------------------------------------------------------------------
-- STEP 3: Insert Sample Data
-- ----------------------------------------------------------------------------

-- 5 Departments
INSERT INTO Department (dept_id, dept_name) VALUES 
(1, 'HR'), 
(2, 'Finance'), 
(3, 'IT'), 
(4, 'Marketing'), 
(5, 'Operations');

-- 8 Projects
INSERT INTO Project (project_id, project_name, dept_id) VALUES 
(101, 'Recruitment System', 1), 
(102, 'Payroll Automation', 2), 
(103, 'Cybersecurity Upgrade', 3), 
(104, 'Website Revamp', 3), 
(105, 'Ad Campaign', 4), 
(106, 'Market Research', 4), 
(107, 'Logistics Optimization', 5), 
(108, 'Inventory System', 5);

-- 30 Employees
INSERT INTO Employee (emp_id, emp_name, dept_id, project_id, salary, city) VALUES 
(1, 'Alice', 1, 101, 45000.00, 'Delhi'), 
(2, 'Bob', 1, 101, 42000.00, 'Mumbai'), 
(3, 'Charlie', 1, 101, 47000.00, 'Pune'), 
(4, 'David', 2, 102, 55000.00, 'Delhi'), 
(5, 'Eva', 2, 102, 60000.00, 'Lucknow'), 
(6, 'Frank', 2, 102, 52000.00, 'Chennai'), 
(7, 'Grace', 3, 103, 70000.00, 'Bangalore'), 
(8, 'Hannah', 3, 103, 68000.00, 'Hyderabad'), 
(9, 'Ian', 3, 104, 72000.00, 'Delhi'), 
(10, 'Jack', 3, 104, 65000.00, 'Pune'), 
(11, 'Karen', 3, 104, 64000.00, 'Mumbai'), 
(12, 'Leo', 4, 105, 48000.00, 'Delhi'), 
(13, 'Mia', 4, 105, 50000.00, 'Lucknow'), 
(14, 'Nina', 4, 106, 51000.00, 'Chennai'), 
(15, 'Oscar', 4, 106, 53000.00, 'Delhi'), 
(16, 'Paul', 5, 107, 56000.00, 'Hyderabad'), 
(17, 'Quinn', 5, 107, 57000.00, 'Bangalore'), 
(18, 'Rita', 5, 107, 59000.00, 'Delhi'), 
(19, 'Sam', 5, 108, 60000.00, 'Lucknow'), 
(20, 'Tina', 5, 108, 61000.00, 'Mumbai'), 
(21, 'Uma', 5, 108, 62000.00, 'Chennai'), 
(22, 'Victor', 2, 102, 53000.00, 'Delhi'), 
(23, 'Wendy', 2, 102, 54000.00, 'Hyderabad'), 
(24, 'Xavier', 3, 103, 71000.00, 'Bangalore'), 
(25, 'Yara', 3, 104, 66000.00, 'Lucknow'), 
(26, 'Zane', 4, 105, 49000.00, 'Delhi'), 
(27, 'Aditi', 4, 106, 52000.00, 'Mumbai'), 
(28, 'Bhavya', 1, 101, 46000.00, 'Chennai'), 
(29, 'Chetan', 1, 101, 43000.00, 'Lucknow'), 
(30, 'Devika', 5, 107, 58000.00, 'Delhi');

-- ----------------------------------------------------------------------------
-- STEP 4: Query Demonstrations
-- ----------------------------------------------------------------------------

-- 1. Selection using WHERE (Filter employees located in Delhi)
SELECT '--- 1. Selection: Employees in Delhi ---' AS Query_Demo;
SELECT *  
FROM Employee  
WHERE city = 'Delhi';

-- 2. Projection (Select specific columns: Employee Name & Salary)
SELECT '--- 2. Projection: Employee Name & Salary ---' AS Query_Demo;
SELECT emp_name, salary  
FROM Employee;

-- 3. Aggregates and GROUP BY (Average salary per department)
SELECT '--- 3. Aggregation & GROUP BY: Average Salary per Department ---' AS Query_Demo;
SELECT dept_id, AVG(salary) AS avg_salary 
FROM Employee 
GROUP BY dept_id;

-- 4. Filtering Group Aggregations using HAVING (Departments with > 5 employees)
SELECT '--- 4. HAVING: Departments with more than 5 employees ---' AS Query_Demo;
SELECT dept_id, COUNT(*) AS num_employees 
FROM Employee 
GROUP BY dept_id 
HAVING COUNT(*) > 5;

-- 5. Conditional Categorization with CASE (Salary brackets)
SELECT '--- 5. CASE Expressions: Categorizing Salaries ---' AS Query_Demo;
SELECT 
    emp_name, 
    salary, 
    CASE  
        WHEN salary < 50000 THEN 'Low' 
        WHEN salary BETWEEN 50000 AND 60000 THEN 'Medium' 
        ELSE 'High' 
    END AS salary_category 
FROM Employee;

-- 6. Sorting Results using ORDER BY (Highest to lowest salary)
SELECT '--- 6. ORDER BY: Employees sorted by Salary DESC ---' AS Query_Demo;
SELECT emp_name, dept_id, salary 
FROM Employee 
ORDER BY salary DESC;
