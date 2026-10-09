-- ============================================================================
-- EXPERIMENT 04: Joins, Subqueries, Set Operations, and EXPLAIN Execution Plans
-- ============================================================================
-- Aim: Using the Employee schema, write queries with INNER JOIN, LEFT JOIN,
--      self-join, 3-way join, correlated subqueries, EXISTS, and simulated
--      INTERSECT and EXCEPT. Compare execution plans using EXPLAIN.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STEP 1: Database Initialization & Safe Reset
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CompanyDB_Exp04;
USE CompanyDB_Exp04;

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
    CONSTRAINT fk_exp4_proj_dept
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
    CONSTRAINT fk_exp4_emp_dept
        FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_exp4_emp_proj
        FOREIGN KEY (project_id) REFERENCES Project(project_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ----------------------------------------------------------------------------
-- STEP 3: Insert Sample Data (Preserving original dataset)
-- ----------------------------------------------------------------------------

INSERT INTO Department (dept_id, dept_name) VALUES 
(1, 'HR'), 
(2, 'Finance'), 
(3, 'IT'), 
(4, 'Marketing'), 
(5, 'Operations');

INSERT INTO Project (project_id, project_name, dept_id) VALUES 
(101, 'Recruitment System', 1), 
(102, 'Payroll Automation', 2), 
(103, 'Cybersecurity Upgrade', 3), 
(104, 'Website Revamp', 3), 
(105, 'Ad Campaign', 4), 
(106, 'Market Research', 4), 
(107, 'Logistics Optimization', 5), 
(108, 'Inventory System', 5);

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
-- STEP 4: Join Query Demonstrations
-- ----------------------------------------------------------------------------

-- 1. INNER JOIN (Matching Employees with their Departments)
SELECT '--- 1. INNER JOIN: Employees & Departments ---' AS Query_Section;
SELECT E.emp_id, E.emp_name, D.dept_name  
FROM Employee E  
INNER JOIN Department D  
    ON E.dept_id = D.dept_id;   

-- 2. LEFT JOIN (All Departments, with matching Employees if any)
SELECT '--- 2. LEFT JOIN: All Departments & Matching Employees ---' AS Query_Section;
SELECT D.dept_id, D.dept_name, E.emp_name  
FROM Department D  
LEFT JOIN Employee E  
    ON D.dept_id = E.dept_id;  

-- 3. Self-Join (Pairing distinct employees within the same department)
SELECT '--- 3. Self-Join: Employee Pairs in the Same Department ---' AS Query_Section;
SELECT E1.emp_name AS Employee1, E2.emp_name AS Employee2, E1.dept_id  
FROM Employee E1  
INNER JOIN Employee E2  
    ON E1.dept_id = E2.dept_id  
    AND E1.emp_id < E2.emp_id;  

-- 4. Three-Table Join (Employee, Project, and Department)
SELECT '--- 4. 3-Way Join: Employee, Project & Department Details ---' AS Query_Section;
SELECT E.emp_name, P.project_name, D.dept_name  
FROM Employee E  
INNER JOIN Project P  
    ON E.project_id = P.project_id  
INNER JOIN Department D  
    ON E.dept_id = D.dept_id;  

-- ----------------------------------------------------------------------------
-- STEP 5: Subqueries & Set Operations
-- ----------------------------------------------------------------------------

-- 5. Correlated Subquery (Employees earning above their department's average)
SELECT '--- 5. Correlated Subquery: Salary > Department Average ---' AS Query_Section;
SELECT E.emp_name, E.dept_id, E.salary  
FROM Employee E  
WHERE E.salary > (  
    SELECT AVG(E2.salary)  
    FROM Employee E2  
    WHERE E2.dept_id = E.dept_id 
);  

-- 6. EXISTS Clause (Employees whose department has at least one project assigned)
SELECT '--- 6. EXISTS: Employees in Departments with Assigned Projects ---' AS Query_Section;
SELECT E.emp_id, E.emp_name, E.dept_id  
FROM Employee E  
WHERE EXISTS (  
    SELECT 1  
    FROM Project P  
    WHERE P.dept_id = E.dept_id 
);  

-- 7. Simulated INTERSECT (Employees located in Delhi AND earning > 60000)
-- Simulation using nested IN clauses:
SELECT '--- 7. Simulated INTERSECT: City = Delhi AND Salary > 60000 ---' AS Query_Section;
SELECT emp_name  
FROM Employee  
WHERE emp_id IN (  
    SELECT emp_id  
    FROM Employee  
    WHERE city = 'Delhi' 
)  
AND emp_id IN (  
    SELECT emp_id  
    FROM Employee  
    WHERE salary > 60000 
);  

-- Modern MySQL 8.0.31+ Native INTERSECT syntax (for reference):
/*
SELECT emp_name FROM Employee WHERE city = 'Delhi'
INTERSECT
SELECT emp_name FROM Employee WHERE salary > 60000;
*/

-- 8. Simulated EXCEPT (Employees who are NOT located in Delhi)
-- Simulation using NOT IN subquery:
SELECT '--- 8. Simulated EXCEPT: Employees outside Delhi ---' AS Query_Section;
SELECT emp_name 
FROM Employee  
WHERE emp_id NOT IN (  
    SELECT emp_id  
    FROM Employee  
    WHERE city = 'Delhi' 
);   

-- Modern MySQL 8.0.31+ Native EXCEPT syntax (for reference):
/*
SELECT emp_name FROM Employee
EXCEPT
SELECT emp_name FROM Employee WHERE city = 'Delhi';
*/

-- ----------------------------------------------------------------------------
-- STEP 6: Execution Plan Analysis with EXPLAIN
-- ----------------------------------------------------------------------------

-- EXPLAIN 1: INNER JOIN
SELECT '--- EXPLAIN: INNER JOIN Execution Plan ---' AS Query_Section;
EXPLAIN  
SELECT E.emp_name, D.dept_name  
FROM Employee E  
INNER JOIN Department D  
    ON E.dept_id = D.dept_id;  

-- EXPLAIN 2: LEFT JOIN
SELECT '--- EXPLAIN: LEFT JOIN Execution Plan ---' AS Query_Section;
EXPLAIN  
SELECT D.dept_name, E.emp_name  
FROM Department D  
LEFT JOIN Employee E  
    ON D.dept_id = E.dept_id;  

-- EXPLAIN 3: Correlated Subquery
SELECT '--- EXPLAIN: Correlated Subquery Execution Plan ---' AS Query_Section;
EXPLAIN  
SELECT E.emp_name, E.salary  
FROM Employee E  
WHERE E.salary > (  
    SELECT AVG(E2.salary)  
    FROM Employee E2  
    WHERE E2.dept_id = E.dept_id 
);  

-- EXPLAIN 4: EXISTS Predicate
SELECT '--- EXPLAIN: EXISTS Execution Plan ---' AS Query_Section;
EXPLAIN  
SELECT E.emp_name 
FROM Employee E  
WHERE EXISTS (  
    SELECT 1  
    FROM Project P  
    WHERE P.dept_id = E.dept_id 
);
