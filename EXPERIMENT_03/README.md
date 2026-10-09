# Experiment 3: Employee-Department-Project Queries & Aggregations

## Aim
To create an Employee–Department–Project database schema, populate it with at least 30 employees distributed across 5 departments and 8 projects, and write comprehensive SQL queries demonstrating selection, projection, aggregates, `GROUP BY`, `HAVING`, `CASE` expressions, and `ORDER BY`.

---

## Concepts Demonstrated
1. **Relational Constraints & Foreign Keys**: Establishing referential relationships between `Employee`, `Department`, and `Project`.
2. **Selection (`WHERE`)**: Filtering tuples based on predicate conditions (e.g., filtering employees residing in `'Delhi'`).
3. **Projection**: Selecting a specific subset of attributes (`emp_name`, `salary`) rather than all table attributes.
4. **Aggregate Functions (`AVG`, `COUNT`) & `GROUP BY`**: Grouping rows by a common key (`dept_id`) and computing summary statistics.
5. **`HAVING` Clause**: Filtering aggregated groups after evaluation (e.g., groups where `COUNT(*) > 5`), contrasting with `WHERE` which filters individual records before grouping.
6. **Conditional Logic (`CASE` Expression)**: Dynamically categorizing salaries into brackets (`'Low'`, `'Medium'`, `'High'`).
7. **Sorting (`ORDER BY`)**: Arranging result sets in descending order (`DESC`) of compensation.

---

## Database Schema & Tables

### 1. `Department`
- `dept_id INT PRIMARY KEY`
- `dept_name VARCHAR(50) NOT NULL`

### 2. `Project`
- `project_id INT PRIMARY KEY`
- `project_name VARCHAR(50) NOT NULL`
- `dept_id INT` (Foreign Key referencing `Department(dept_id)`)

### 3. `Employee`
- `emp_id INT PRIMARY KEY`
- `emp_name VARCHAR(50) NOT NULL`
- `dept_id INT` (Foreign Key referencing `Department(dept_id)`)
- `project_id INT` (Foreign Key referencing `Project(project_id)`)
- `salary DECIMAL(10,2) NOT NULL`
- `city VARCHAR(50) NOT NULL`

---

## Summary of Sample Data
- **5 Departments**: HR (1), Finance (2), IT (3), Marketing (4), Operations (5).
- **8 Projects**: Recruitment System (101), Payroll Automation (102), Cybersecurity Upgrade (103), Website Revamp (104), Ad Campaign (105), Market Research (106), Logistics Optimization (107), Inventory System (108).
- **30 Employees**: Distributed with varied salaries from 42,000.00 to 72,000.00 across Delhi, Mumbai, Pune, Lucknow, Bangalore, Hyderabad, and Chennai.

---

## How to Execute the Script

### Using MySQL Command-Line Client
```bash
mysql -u your_username -p < experiment_03.sql
```

### Using MySQL Workbench
1. Open MySQL Workbench and connect to your MySQL Server instance.
2. Open `experiment_03.sql`.
3. Execute the script using the toolbar button or `Ctrl+Shift+Enter`.
4. Review the returned Result Grids for each query section.

---

## Key Queries & Expected Outcomes

### 1. Selection (Employees in Delhi)
Filters records where `city = 'Delhi'`. Returns employees: Alice, David, Ian, Leo, Oscar, Rita, Victor, Zane, Devika.

### 2. Aggregations with GROUP BY & HAVING
```sql
SELECT dept_id, AVG(salary) AS avg_salary 
FROM Employee 
GROUP BY dept_id;

SELECT dept_id, COUNT(*) AS num_employees 
FROM Employee 
GROUP BY dept_id 
HAVING COUNT(*) > 5;
```
- Groups with more than 5 members: IT (Dept 3 with 7 employees) and Operations (Dept 5 with 7 employees).

### 3. Salary Categorization via CASE Expression
- Salary < 50,000: `'Low'`
- Salary 50,000 to 60,000: `'Medium'`
- Salary > 60,000: `'High'`

---

## Transcription & Implementation Notes
- **Source Material**: Faithfully transcribed from `DBMS 3 TAQI.docx`.
- **Database Encapsulation**: Uses dedicated schema `CompanyDB_Exp03` with safe clean teardown (`DROP TABLE IF EXISTS`) in proper referential order (`Employee` -> `Project` -> `Department`).
