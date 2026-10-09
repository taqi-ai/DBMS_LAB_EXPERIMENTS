# Experiment 6: Stored Procedures, Validation Triggers, and Audit Logging

## Aim
To create a stored procedure `transfer_employee(emp_id, new_dept_id)` with input validation and custom error handling, and to implement triggers for salary business rule validation and automated audit logging, including testing edge cases.

---

## Concepts Demonstrated

### 1. Stored Procedures with Control Flow & Signaling
- Encapsulates multi-statement transactional logic directly on the database engine.
- Uses `IN` parameters (`p_emp_id`, `p_new_dept_id`).
- Implements existence validation queries using `SELECT COUNT(*) INTO ...`.
- Raises custom, user-friendly exceptions using standard ANSI `SIGNAL SQLSTATE '45000'` with descriptive `MESSAGE_TEXT`.

### 2. Triggers in MySQL
- **`BEFORE UPDATE` Trigger (`before_employee_salary_update`)**:
  Interprets incoming modifications before they are written to disk. Checks `NEW.Salary < 0` and aborts the transaction via `SIGNAL` if invalid, preserving data integrity.
- **`AFTER UPDATE` Trigger (`after_employee_salary_update`)**:
  Fires post-commit on row updates. Checks if `OLD.Salary <> NEW.Salary` and automatically writes an immutable audit entry to `Salary_Audit` with timestamp `CURRENT_TIMESTAMP`.

### 3. Client Command: MySQL `DELIMITER`
- In standard SQL, `;` indicates the end of a query statement.
- Because stored routine and trigger bodies contain internal statements also ended with `;`, client interfaces (CLI and Workbench) need a temporary delimiter (such as `$$`) so the entire block from `CREATE PROCEDURE/TRIGGER` to `END $$` is dispatched to the server as one single unit.

---

## Schema & Tables

### 1. `Department`
- `Dept_ID INT PRIMARY KEY`
- `Dept_Name VARCHAR(100) NOT NULL`

### 2. `Employee`
- `Emp_ID INT PRIMARY KEY`
- `Emp_Name VARCHAR(100) NOT NULL`
- `Salary DECIMAL(10,2) NOT NULL`
- `Dept_ID INT` (Foreign Key referencing `Department(Dept_ID)`)

### 3. `Salary_Audit`
- `Audit_ID INT AUTO_INCREMENT PRIMARY KEY`
- `Emp_ID INT NOT NULL`
- `Old_Salary DECIMAL(10,2) NOT NULL`
- `New_Salary DECIMAL(10,2) NOT NULL`
- `Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP`

---

## How to Execute the Script

### Using MySQL Command-Line Client
```bash
mysql -u your_username -p < experiment_06.sql
```

### Using MySQL Workbench
1. Open MySQL Workbench.
2. Open `experiment_06.sql`.
3. Execute the entire script (`Ctrl+Shift+Enter`).
4. Inspect the Result Grids showing Alex's transfer, the before/after states, and the `Salary_Audit` log.

---

## Key Scenarios & Expected Outcomes

### Scenario 1: Successful Department Transfer
```sql
CALL transfer_employee(1, 2);
```
- Alex's `Dept_ID` transitions from `1` (Sales) to `2` (Engineering).

### Scenario 2: Successful Salary Update & Audit Logging
```sql
UPDATE Employee SET Salary = 65000.00 WHERE Emp_ID = 1;
```
- `Salary_Audit` records `Old_Salary = 60000.00`, `New_Salary = 65000.00`, with the system timestamp.

### Scenario 3: Edge Case & Error Handling (Commented Tests)
1. **Invalid Employee**:
   `CALL transfer_employee(999, 2);`
   -> `ERROR 1644 (45000): Employee does not exist`
2. **Invalid Department**:
   `CALL transfer_employee(1, 999);`
   -> `ERROR 1644 (45000): Department does not exist`
3. **Negative Salary Attempt**:
   `UPDATE Employee SET Salary = -5000.00 WHERE Emp_ID = 1;`
   -> `ERROR 1644 (45000): Salary cannot be negative`

---

## Transcription & Implementation Notes
- **Source Material**: Reconstructed from `DBMS EXP 6 Taqi.docx`.
- **Safe Reset**: Safely drops existing stored procedures and triggers (`DROP PROCEDURE IF EXISTS ...`, `DROP TRIGGER IF EXISTS ...`) before recreating schema components to guarantee repeatable execution.
