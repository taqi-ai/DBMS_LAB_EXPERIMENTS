# Experiment 5: Views, Updatability, and Recursive CTEs

## Aim
To create SQL views for department salary summaries and employee hierarchy, evaluate the updatability of views under MySQL constraints, and implement a recursive Common Table Expression (CTE) to traverse and display organizational reporting chains.

---

## Concepts Demonstrated

### 1. SQL Views
- **Virtual Tables**: Encapsulating complex multi-table queries and aggregations into persistent named query definitions without duplicating physical storage.
- **Data Abstraction & Security**: Exposing high-level metrics (e.g., department salary stats) while shielding raw individual records.

### 2. View Updatability Constraints in MySQL
In MySQL 8.0+, a view is updatable only if there is a 1-to-1 relationship between rows in the view and rows in the underlying base table. 
- **Non-Updatable Views**: Any view defined with `GROUP BY`, aggregate functions (`COUNT`, `AVG`, `MIN`, `MAX`), `DISTINCT`, `HAVING`, or `UNION` is strictly **read-only**. Attempting an `UPDATE` on `Department_Salary_Summary` results in:
  `ERROR 1288 (HY000): The target table Department_Salary_Summary of the UPDATE is not updatable.`
- **Updatable Views**: Views selecting direct columns without grouping can receive `UPDATE` statements that pass through directly to the underlying base table.

### 3. Self-Referential Relationships
The `Employee` table includes a `Manager_ID` column referencing `Employee(Emp_ID)` with `ON DELETE SET NULL`. Department heads have `Manager_ID IS NULL` representing the apex of each division.

### 4. Recursive Common Table Expressions (Recursive CTE)
Traverses hierarchical data using a two-part recursive query:
1. **Anchor Member**: Selects top-level managers where `Manager_ID IS NULL` with starting hierarchy `Level = 1`.
2. **Recursive Member**: Recursively joins `Employee E` to the preceding CTE generation `Employee_Chain EC` on `E.Manager_ID = EC.Emp_ID`, incrementing `Level + 1` until all subordinates are traversed.

---

## Schema & Tables

### 1. `Department`
- `Dept_ID INT PRIMARY KEY`
- `Dept_Name VARCHAR(100) NOT NULL`

### 2. `Employee`
- `Emp_ID INT PRIMARY KEY`
- `Emp_Name VARCHAR(100) NOT NULL`
- `Job_Title VARCHAR(100)`
- `Salary DECIMAL(10, 2)`
- `Dept_ID INT` (Foreign Key referencing `Department(Dept_ID)`)
- `Manager_ID INT NULL` (Self-referencing Foreign Key referencing `Employee(Emp_ID)`)

---

## Views Implemented

### 1. `Department_Salary_Summary`
Computes per-department headcounts, average salary, minimum salary, and maximum salary via `LEFT JOIN` and `GROUP BY`.

### 2. `Employee_Hierarchy`
Pairs each employee with their respective supervisor's name via a `LEFT JOIN` between `Employee E` and `Employee M`.

---

## How to Execute the Script

### Using MySQL Command-Line Client
```bash
mysql -u your_username -p < experiment_05.sql
```

### Using MySQL Workbench
1. Open MySQL Workbench.
2. Open `experiment_05.sql`.
3. Execute the script (`Ctrl+Shift+Enter`).
4. Inspect the output grids for the view results and the recursive CTE hierarchy.

---

## Recursive CTE Logic & Output

```sql
WITH RECURSIVE Employee_Chain AS 
( 
    SELECT Emp_ID, Emp_Name, Job_Title, Manager_ID, 1 AS Level 
    FROM Employee 
    WHERE Manager_ID IS NULL 

    UNION ALL 

    SELECT E.Emp_ID, E.Emp_Name, E.Job_Title, E.Manager_ID, EC.Level + 1 
    FROM Employee E 
    INNER JOIN Employee_Chain EC 
        ON E.Manager_ID = EC.Emp_ID 
) 
SELECT Emp_ID, Emp_Name, Job_Title, Manager_ID, Level 
FROM Employee_Chain 
ORDER BY Level, Emp_ID;
```

### Expected Output Summary
- **Level 1 (Managers)**: Noah Smith (Engineering), Amelia Miller (Sales), Daniel White (HR), Emily Hall (Finance), Chloe Green (Operations).
- **Level 2 (Direct Reports)**: All individual team contributors (Developers, Analysts, Sales Reps, Recruiters, Accountants, Specialists).

---

## Transcription & Implementation Notes
- **Source Material**: Reconstructed faithfully from `EXPERIMENT DBMS 5 TAQI.docx`.
- **Idempotency**: Views are dropped safely before tables (`DROP VIEW IF EXISTS ...`) and tables are created with `Manager_ID` included to enable zero-error repeatable executions.
