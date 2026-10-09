-- ============================================================================
-- EXPERIMENT 06: Stored Procedures, Validation Triggers, and Audit Logging
-- ============================================================================
-- Aim: To create a stored procedure transfer_employee(emp_id, new_dept_id) 
--      with validation and error handling, and to implement triggers for salary 
--      validation and audit logging, including testing of edge cases.
-- ============================================================================
-- Note on MySQL DELIMITER:
-- The DELIMITER command is a client-side instruction in MySQL (used in MySQL 
-- Command Line Client and MySQL Workbench) to temporarily change the default 
-- statement separator (from ';' to '$$'). This enables MySQL to parse stored 
-- procedure and trigger definition blocks containing multiple internal 
-- statements terminated with semicolons as a single composite statement.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STEP 1: Database Initialization & Safe Reset
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CompanyDB_Exp06;
USE CompanyDB_Exp06;

-- Drop triggers and procedures if they exist
DROP PROCEDURE IF EXISTS transfer_employee;
DROP TRIGGER IF EXISTS before_employee_salary_update;
DROP TRIGGER IF EXISTS after_employee_salary_update;

-- Drop tables in dependency order
DROP TABLE IF EXISTS Salary_Audit;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

-- ----------------------------------------------------------------------------
-- STEP 2: Schema Creation
-- ----------------------------------------------------------------------------

CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    Dept_ID INT,
    CONSTRAINT fk_exp6_emp_dept
        FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Salary_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID INT NOT NULL,
    Old_Salary DECIMAL(10,2) NOT NULL,
    New_Salary DECIMAL(10,2) NOT NULL,
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- STEP 3: Insert Initial Data
-- ----------------------------------------------------------------------------

INSERT INTO Department (Dept_ID, Dept_Name) VALUES 
(1, 'Sales'), 
(2, 'Engineering');

INSERT INTO Employee (Emp_ID, Emp_Name, Salary, Dept_ID) VALUES 
(1, 'Alex', 60000.00, 1);

-- ----------------------------------------------------------------------------
-- STEP 4: Stored Procedure - Employee Department Transfer with Validations
-- ----------------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE emp_count INT DEFAULT 0;
    DECLARE dept_count INT DEFAULT 0;

    -- Validate employee existence
    SELECT COUNT(*) 
    INTO emp_count 
    FROM Employee 
    WHERE Emp_ID = p_emp_id;

    -- Validate target department existence
    SELECT COUNT(*) 
    INTO dept_count 
    FROM Department 
    WHERE Dept_ID = p_new_dept_id;

    -- Conditional error handling using custom SQLSTATE 45000
    IF emp_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    ELSEIF dept_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';
    ELSE
        UPDATE Employee
        SET Dept_ID = p_new_dept_id
        WHERE Emp_ID = p_emp_id;
    END IF;
END $$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- STEP 5: Validation Trigger - Enforce Non-Negative Salaries
-- ----------------------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER before_employee_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END $$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- STEP 6: Audit Trigger - Record Salary Alteration History
-- ----------------------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER after_employee_salary_update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    -- Log only when the salary value actually changes
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO Salary_Audit (Emp_ID, Old_Salary, New_Salary)
        VALUES (OLD.Emp_ID, OLD.Salary, NEW.Salary);
    END IF;
END $$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- STEP 7: Demonstrations of Successful Operations
-- ----------------------------------------------------------------------------

-- Operation A: Transfer Employee 1 (Alex) from Dept 1 (Sales) to Dept 2 (Engineering)
SELECT '--- 1. Initial State of Alex ---' AS Demo_Step;
SELECT * FROM Employee WHERE Emp_ID = 1;

CALL transfer_employee(1, 2);

SELECT '--- 2. State of Alex After Successful Transfer ---' AS Demo_Step;
SELECT * FROM Employee WHERE Emp_ID = 1;

-- Operation B: Update Salary to 65000 and verify Audit Log
SELECT '--- 3. Salary Audit Table Before Salary Change ---' AS Demo_Step;
SELECT * FROM Salary_Audit;

UPDATE Employee
SET Salary = 65000.00
WHERE Emp_ID = 1;

SELECT '--- 4. Salary Audit Table After Salary Change ---' AS Demo_Step;
SELECT * FROM Salary_Audit;

SELECT '--- 5. Final Employee Record ---' AS Demo_Step;
SELECT Emp_ID, Emp_Name, Salary, Dept_ID FROM Employee WHERE Emp_ID = 1;

-- ----------------------------------------------------------------------------
-- STEP 8: Demonstrations of Expected Error Cases (Edge Case Testing)
-- Note: Uncomment each block individually to observe custom SQLSTATE 45000 errors.
-- ----------------------------------------------------------------------------

/*
-- ERROR TEST 1: Transfer non-existent employee (Emp_ID = 999)
-- Expected Output: ERROR 1644 (45000): Employee does not exist
CALL transfer_employee(999, 2);

-- ERROR TEST 2: Transfer to non-existent department (Dept_ID = 999)
-- Expected Output: ERROR 1644 (45000): Department does not exist
CALL transfer_employee(1, 999);

-- ERROR TEST 3: Attempting to update salary with a negative value
-- Expected Output: ERROR 1644 (45000): Salary cannot be negative
UPDATE Employee SET Salary = -5000.00 WHERE Emp_ID = 1;
*/
