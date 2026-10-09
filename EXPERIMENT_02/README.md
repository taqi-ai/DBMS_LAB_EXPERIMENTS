# Experiment 2: College Database Schema & Referential Integrity Constraints

## Aim
To convert the E-R diagram into a relational schema for a College Database, create MySQL tables with `PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `ON DELETE CASCADE`, and `ON DELETE SET NULL` constraints, insert sample records, and demonstrate referential integrity enforcement.

---

## Concepts Demonstrated
1. **Primary Key Constraints (`PRIMARY KEY`)**: Uniquely identifying records in parent and child tables.
2. **Domain & Column Constraints (`NOT NULL`, `UNIQUE`)**: Ensuring student names and course credits cannot be null, and email addresses/department names remain distinct.
3. **Foreign Key Constraints (`FOREIGN KEY ... REFERENCES`)**: Defining relationships between tables.
4. **Referential Action `ON DELETE SET NULL`**: Configured on `Student(Dept_Id) -> Department(Dept_Id)` so that removing a department disassociates students without deleting their records.
5. **Referential Action `ON DELETE CASCADE`**: Configured on `Enrollment(Student_Id, Course_Id)` so that deleting a student or course automatically purges associated enrollments.

---

## Relational Schema & Tables

### 1. `Department`
| Column Name | Data Type | Constraints | Description |
|---|---|---|---|
| `Dept_Id` | `INT` | `PRIMARY KEY` | Unique department code |
| `Dept_Name` | `VARCHAR(50)` | `NOT NULL`, `UNIQUE` | Department title |

### 2. `Course`
| Column Name | Data Type | Constraints | Description |
|---|---|---|---|
| `Course_Id` | `INT` | `PRIMARY KEY` | Unique course code |
| `Course_Name` | `VARCHAR(50)` | `NOT NULL` | Course title |
| `Credits` | `INT` | `NOT NULL` | Credit points for course |

### 3. `Student`
| Column Name | Data Type | Constraints | Description |
|---|---|---|---|
| `Student_Id` | `INT` | `PRIMARY KEY` | Unique student roll number |
| `Student_Name` | `VARCHAR(50)` | `NOT NULL` | Student full name |
| `Email` | `VARCHAR(100)` | `UNIQUE` | Unique email ID |
| `Dept_Id` | `INT` | `FOREIGN KEY` (Nullable) | References `Department(Dept_Id)` `ON DELETE SET NULL` |

### 4. `Enrollment`
| Column Name | Data Type | Constraints | Description |
|---|---|---|---|
| `Enroll_Id` | `INT` | `PRIMARY KEY` | Unique enrollment ID |
| `Student_Id` | `INT` | `NOT NULL`, `FOREIGN KEY` | References `Student(Student_Id)` `ON DELETE CASCADE` |
| `Course_Id` | `INT` | `NOT NULL`, `FOREIGN KEY` | References `Course(Course_Id)` `ON DELETE CASCADE` |

---

## Sample Data (from Lab Notebook)

- **Department**:
  - `(1, 'CSE')`
  - `(2, 'AIML')`
- **Student**:
  - `(101, 'Rahul', 'rahul@gmail.com', 1)`
  - `(102, 'Vansh', 'vansh@gmail.com', 2)`
- **Course**:
  - `(201, 'DBMS', 4)`
  - `(202, 'OPERATING SYSTEM', 4)`
- **Enrollment**:
  - `(1, 101, 201)`
  - `(2, 102, 202)`

---

## How to Execute the Script

### Using MySQL Command-Line Client
```bash
mysql -u your_username -p < experiment_02.sql
```

### Using MySQL Workbench
1. Open MySQL Workbench and connect to your MySQL Server instance.
2. Go to **File -> Open SQL Script...** and select `experiment_02.sql`.
3. Click the **Execute (Lightning Bolt)** icon to run the script.
4. Inspect the Result Grids for the verification SELECT queries.

---

## Expected Outputs

### Department Table
```
+---------+-----------+
| Dept_Id | Dept_Name |
+---------+-----------+
|       1 | CSE       |
|       2 | AIML      |
+---------+-----------+
```

### Student Table
```
+------------+--------------+-----------------+---------+
| Student_Id | Student_Name | Email           | Dept_Id |
+------------+--------------+-----------------+---------+
|        101 | Rahul        | rahul@gmail.com |       1 |
|        102 | Vansh        | vansh@gmail.com |       2 |
+------------+--------------+-----------------+---------+
```

### Course Table
```
+-----------+------------------+---------+
| Course_Id | Course_Name      | Credits |
+-----------+------------------+---------+
|       201 | DBMS             |       4 |
|       202 | OPERATING SYSTEM |       4 |
+-----------+------------------+---------+
```

### Enrollment Table
```
+-----------+------------+-----------+
| Enroll_Id | Student_Id | Course_Id |
+-----------+------------+-----------+
|         1 |        101 |       201 |
|         2 |        102 |       202 |
+-----------+------------+-----------+
```

---

## Transcription & Reconstruction Notes
- **Handwritten Notes Source**: Reconstructed directly from handwritten laboratory journal entries.
- **Title Note**: The handwritten notebook entry header reads *"To convert the E-R diagram of an Indian E-Commerce platform into relational schema..."*, while the actual schema transcribed immediately below it is the standardized 4-table College Database (`Department`, `Student`, `Course`, `Enrollment`). Both aspects have been faithfully documented.
- **Safe Reset & Isolation**: The script creates and selects `CollegeDB` safely, orders table teardowns child-first (`Enrollment` -> `Student` -> `Course` -> `Department`) to avoid foreign key deadlocks, and keeps destructive tests commented out.
