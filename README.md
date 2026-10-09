# DBMS Laboratory Experiments (MySQL 8.0+)

A comprehensive, production-grade repository of university Database Management System (DBMS) practical laboratory experiments implemented in **MySQL 8.0+**.

This repository contains fully tested, idempotent SQL scripts, complete schemas, authentic sample datasets, and academic documentation for all experiments ranging from relational constraints to recursive CTEs, stored procedures, and audit triggers.

---

## 📚 Table of Experiments

| Experiment | Title | Core Concepts | Script Link |
|---|---|---|---|
| **Experiment 02** | College Database & Referential Integrity | Primary Key, Foreign Key, `ON DELETE SET NULL`, `ON DELETE CASCADE`, `UNIQUE`, `NOT NULL` | [experiment_02.sql](EXPERIMENT_02/experiment_02.sql) |
| **Experiment 03** | Employee-Department-Project Queries | Selection (`WHERE`), Projection, Aggregates (`AVG`, `COUNT`), `GROUP BY`, `HAVING`, `CASE`, `ORDER BY` | [experiment_03.sql](EXPERIMENT_03/experiment_03.sql) |
| **Experiment 04** | Joins, Subqueries & EXPLAIN Plans | `INNER JOIN`, `LEFT JOIN`, Self-Join, 3-Way Join, Correlated Subqueries, `EXISTS`, Simulated `INTERSECT`/`EXCEPT`, `EXPLAIN` | [experiment_04.sql](EXPERIMENT_04/experiment_04.sql) |
| **Experiment 05** | Views, Updatability & Recursive CTEs | Aggregate Views, View Updatability Rules, Self-Referential FKs, Common Table Expressions, Recursive CTE | [experiment_05.sql](EXPERIMENT_05/experiment_05.sql) |
| **Experiment 06** | Stored Procedures & Triggers | Stored Procedures, `SIGNAL SQLSTATE`, `BEFORE UPDATE` Validation Trigger, `AFTER UPDATE` Audit Logging | [experiment_06.sql](EXPERIMENT_06/experiment_06.sql) |

---

## 📁 Repository Structure

```
DBMS_LAB_EXPERIMENTS/
├── .gitignore                          # Standard git ignore definitions
├── README.md                           # Master laboratory documentation (this file)
│
├── EXPERIMENT_02/                      # Experiment 2: College Database & Constraints
│   ├── experiment_02.sql               # Executable MySQL script
│   └── README.md                       # Documentation & transcription notes
│
├── EXPERIMENT_03/                      # Experiment 3: Selection, Grouping & Aggregations
│   ├── experiment_03.sql               # Executable MySQL script
│   └── README.md                       # Documentation & query analysis
│
├── EXPERIMENT_04/                      # Experiment 4: Joins, Subqueries & EXPLAIN
│   ├── experiment_04.sql               # Executable MySQL script
│   └── README.md                       # Documentation & query optimization notes
│
├── EXPERIMENT_05/                      # Experiment 5: Views & Recursive CTEs
│   ├── experiment_05.sql               # Executable MySQL script
│   └── README.md                       # Documentation & hierarchy explanation
│
├── EXPERIMENT_06/                      # Experiment 6: Stored Procedures & Triggers
│   ├── experiment_06.sql               # Executable MySQL script
│   └── README.md                       # Documentation & trigger logic
│
└── Taqi docx/                          # Original source files & handwritten scans
    ├── DBMS 3 TAQI.docx
    ├── DBMS EXPERIMENT 4 Taqi.docx
    ├── EXPERIMENT DBMS 5 TAQI.docx
    ├── DBMS EXP 6 Taqi.docx
    └── WhatsApp Image 2026-10-09...    # Handwritten notebook pages for Experiment 2
```

---

## ⚙️ Prerequisites & Environment

- **DBMS Platform**: MySQL Server 8.0 or newer (compatible with 8.0.x and 8.4 LTS).
- **Client Tools**:
  - MySQL Command-Line Client (`mysql`)
  - MySQL Workbench (or compatible clients like DBeaver, DataGrip, VS Code Database Tools)
- **SQL Standards**: ANSI SQL-92 / ANSI SQL-99 with MySQL extensions (`DELIMITER`, `SIGNAL`, `JSON`, CTEs).

---

## 🚀 Execution Instructions

Each experiment is self-contained and encapsulated within its own database schema (`CollegeDB`, `CompanyDB_Exp03`, `CompanyDB_Exp04`, `CompanyDB_Exp05`, `CompanyDB_Exp06`). Scripts are completely **rerunnable** and clean up existing tables/views/routines prior to execution.

### Method 1: Using MySQL Command-Line Client

Open PowerShell, Bash, or Command Prompt and run the target script:

```bash
# Execute Experiment 2
mysql -u root -p < EXPERIMENT_02/experiment_02.sql

# Execute Experiment 3
mysql -u root -p < EXPERIMENT_03/experiment_03.sql

# Execute Experiment 4
mysql -u root -p < EXPERIMENT_04/experiment_04.sql

# Execute Experiment 5
mysql -u root -p < EXPERIMENT_05/experiment_05.sql

# Execute Experiment 6
mysql -u root -p < EXPERIMENT_06/experiment_06.sql
```

### Method 2: Using MySQL Workbench

1. Launch **MySQL Workbench** and establish a connection to your local or remote MySQL Server.
2. Navigate to **File** > **Open SQL Script...** (or press `Ctrl+O`).
3. Select any desired experiment script (e.g., `EXPERIMENT_02/experiment_02.sql`).
4. Click the **Execute** button (the yellow lightning bolt icon) or press `Ctrl+Shift+Enter`.
5. Examine the result tabs in the bottom pane displaying the generated tables, formatted output projections, and query execution plans.

---

## 🧠 Key Technical Highlights

### 1. Referential Integrity Actions (`ON DELETE SET NULL` vs `ON DELETE CASCADE`)
- In **Experiment 2**, `Student` records link to `Department` via `ON DELETE SET NULL`, ensuring that decommissioning an academic department does not inadvertently delete student records.
- In contrast, `Enrollment` linkages enforce `ON DELETE CASCADE`, preserving clean relational state when a student graduates or a course is retired.

### 2. Group Aggregation & Filtering (`GROUP BY` with `HAVING`)
- In **Experiment 3**, the logical query execution order distinguishes row filtering (`WHERE`) from aggregate group filtering (`HAVING`). Only department cohorts containing more than 5 members are retained post-aggregation.

### 3. Joins, Subqueries & `EXPLAIN` Query Optimization
- In **Experiment 4**, nested queries and multiple join strategies are benchmarked.
- Correlated subqueries execute iteratively for each outer row, as documented by `DEPENDENT SUBQUERY` in `EXPLAIN` execution plans.
- Simulated set operations (`INTERSECT` and `EXCEPT`) using `IN` and `NOT IN` subqueries provide universal backward compatibility while demonstrating set containment logic.

### 4. SQL Views & Recursive CTE Reporting Hierarchy
- In **Experiment 5**, aggregate views with `GROUP BY` are shown to be non-updatable per MySQL Error 1288 specification.
- A recursive Common Table Expression (`WITH RECURSIVE`) traverses managerial reporting chains across levels starting from unmanaged division heads (`Manager_ID IS NULL`).

### 5. Stored Procedures, Error Signaling & Triggers
- In **Experiment 6**, transactional integrity and domain validation are placed at the database layer.
- `DELIMITER $$` allows multi-statement compound blocks to compile cleanly.
- `SIGNAL SQLSTATE '45000'` surfaces clean business rule violation messages.
- `BEFORE UPDATE` prevents negative salary writes, while `AFTER UPDATE` writes historical audit records with timestamp logs into `Salary_Audit`.

---

## 📌 Source Code Integrity Statement

The primary source code for all lab practicals consists of the executable `.sql` scripts located in the respective experiment folders. All aims, schemas, column names, constraints, and sample data have been strictly reproduced from the original laboratory materials and validated for correctness and idempotency.
