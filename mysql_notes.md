# MySQL Simple Notes

## 1. What is MySQL?

**MySQL** is an open-source **Relational Database Management System
(RDBMS)** that uses **SQL (Structured Query Language)** to store and
manage data.

It follows a **client-server architecture**.

    Application / Client
            ↓
         MySQL Server
            ↓
          Database

MySQL is widely used in:
- Web applications 
- Backend services 
- Data storage systems

------------------------------------------------------------------------

## 2. Key Components of MySQL

### MySQL Server

The **core database engine** that stores and manages data.

Responsibilities: 
- Stores databases 
- Executes SQL queries
- Manages users and permissions 
- Handles transactions

### MySQL Clients

Programs used to interact with the MySQL server.

Examples:

  | Tool            | Purpose                     |
  | :-------------- | :-------------------------- |
  | mysql           | Classic command-line client |
  | mysqlsh         | Advanced MySQL shell        |
  | MySQL Workbench | Graphical user interface    |

------------------------------------------------------------------------

## 3. MySQL Architecture

    Client Applications
          ↓
    MySQL Client Programs
          ↓
    MySQL Server
          ↓
    Databases
          ↓
    Tables
          ↓
    Rows (Records)

------------------------------------------------------------------------

## 4. MySQL Data Hierarchy

  | Level     | Description           |
  | :-------- | :-------------------- |
  | Database  | Collection of tables  |
  | Table     | Collection of rows    |
  | Row       | A record              |
  | Column    | Attribute of a record |

Example:

    Database: company
    Table: employees
    Row: employee record
    Column: name, id, salary

------------------------------------------------------------------------

## 5. Connecting to MySQL

    mysql -u root -p

Options:

  | Option |   Meaning           |
  | :----- | ------------------- |
  | -u     | Username            |
  | -p     | Prompt for password |

Example:

    mysql -u root -p

------------------------------------------------------------------------

## 6. Basic MySQL Commands

### Show Databases

``` sql
SHOW DATABASES;
```

### Create Database

``` sql
CREATE DATABASE company;
```

### Use Database

``` sql
USE company;
```

### Show Tables

``` sql
SHOW TABLES;
```

### Create Table

``` sql
CREATE TABLE employees(
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT
);
```

### Insert Data

``` sql
INSERT INTO employees VALUES (1, 'Alice', 50000);
```

### Retrieve Data

``` sql
SELECT * FROM employees;
```

### Update Data

``` sql
UPDATE employees
SET salary = 60000
WHERE id = 1;
```

### Delete Data

``` sql
DELETE FROM employees
WHERE id = 1;
```

------------------------------------------------------------------------

## 7. Important MySQL Data Types

  | Data Type  | Description          |
  | :--------- | :------------------- |
  | INT        | Integer numbers      |
  | VARCHAR(n) | Variable-length text |
  | CHAR(n)    | Fixed-length text    |
  | DATE       | Date value           |
  | DATETIME   | Date and time        |
  | FLOAT      | Decimal numbers      |

Example:

``` sql
CREATE TABLE products(
    id INT,
    name VARCHAR(100),
    price FLOAT
);
```

------------------------------------------------------------------------

## 8. MySQL Client Tools

### mysql (Classic Client)

Used for running SQL queries.

    mysql -u root -p

### mysqlsh (MySQL Shell)

Advanced client supporting:

-   SQL
-   Python
-   JavaScript

Switch modes:

    \sql
    \py
    \js

### MySQL Workbench

Graphical interface for:

-   Writing queries
-   Designing schemas
-   Managing users
-   Visualizing databases

------------------------------------------------------------------------

## 9. Start and Stop MySQL Server (Windows)

Start MySQL:

    net start mysql80

Stop MySQL:

    net stop mysql80

------------------------------------------------------------------------

## 10. Exit MySQL

    exit;

or

    quit;

------------------------------------------------------------------------

## 11. Summary

MySQL is a **relational database system** used to store and manage
structured data.

Key points:

-   Uses SQL for querying
-   Works on client--server architecture
-   Stores data in tables
-   Supports transactions and user management
-   Widely used in modern applications
