# MySQL Shell (`mysqlsh`) Notes

## 1. What is MySQL Shell?

**MySQL Shell (`mysqlsh`)** is an advanced command-line client for MySQL
that supports multiple languages for interacting with a MySQL server.

It supports three modes:

-   **SQL Mode** -- Run SQL queries
-   **Python Mode** -- Run Python scripts that interact with MySQL
-   **JavaScript Mode** -- Run JavaScript scripts for database
    operations

Unlike the classic `mysql` client, `mysqlsh` is designed for
**automation, scripting, and administration**.

------------------------------------------------------------------------

# 2. Starting MySQL Shell

Open terminal and run:

``` bash
mysqlsh
```

To connect to a MySQL server:

``` bash
\connect root@localhost
```

You will be prompted to enter the password.

------------------------------------------------------------------------

# 3. SQL Mode

Switch to SQL mode:

    \sql

Example SQL queries:

``` sql
SHOW DATABASES;
USE test;
SELECT * FROM users;
```

SQL mode behaves similarly to the traditional `mysql` client.

------------------------------------------------------------------------

# 4. Python Mode

Switch to Python mode:

    \py

Prompt changes to:

    MySQL Py >

### Example: List Databases

``` python
session = shell.get_session()
result = session.run_sql("SHOW DATABASES")

for row in result.fetch_all():
    print(row)
```

### Example: Create Database and Table

``` python
session.run_sql("CREATE DATABASE demo")
session.run_sql("USE demo")

session.run_sql("""
CREATE TABLE users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
)
""")
```

### Example: Insert Data

``` python
session.run_sql("INSERT INTO users(name) VALUES ('Alice')")
session.run_sql("INSERT INTO users(name) VALUES ('Bob')")
```

### Example: Query Data

``` python
result = session.run_sql("SELECT * FROM users")

for row in result.fetch_all():
    print(row)
```

------------------------------------------------------------------------

# 5. JavaScript Mode

Switch to JavaScript mode:

    \js

Prompt changes to:

    MySQL JS >

### Example: List Databases

``` javascript
var session = shell.getSession()
var result = session.runSql("SHOW DATABASES")

var rows = result.fetchAll()

rows.forEach(function(row){
    print(row)
})
```

### Example: Insert Data

``` javascript
session.runSql("INSERT INTO users(name) VALUES ('Charlie')")
```

### Example: Query Data

``` javascript
var result = session.runSql("SELECT * FROM users")

result.fetchAll().forEach(function(row){
    print(row)
})
```

------------------------------------------------------------------------

# 6. Switching Between Modes

You can switch modes anytime inside MySQL Shell.

    \sql   → SQL mode
    \py    → Python mode
    \js    → JavaScript mode

Example workflow:

    \sql
    SHOW DATABASES;

    \py
    print("Python interacting with MySQL")

    \js
    print("JavaScript interacting with MySQL")

------------------------------------------------------------------------

# 7. Exiting MySQL Shell

Exit MySQL Shell using:

    \exit

or press:

    Ctrl + D

------------------------------------------------------------------------

# 8. mysql vs mysqlsh (Quick Comparison)

  |     Feature     |     mysql       |            mysqlsh          |
  | :-------------- |:--------------- | :-------------------------- |
  | Type            | Classic client  |  Advanced shell             |
  | Languages       | SQL only        |  SQL + Python + JavaScript  |
  | Scripting       | Limited         |  Powerful                   |
  | Admin features  | No              |  Yes                        |
  | Best for        | Simple queries  |  Automation & scripting     |

------------------------------------------------------------------------

# 9. Typical Use Cases

  | Mode         | Use Case                    |
  | :----------- | :-------------------------- |
  | SQL          | Running database queries    |
  | Python       | Automation scripts          |
  | JavaScript   | Database management scripts |
  | Python/JS    | DevOps and administration   |

------------------------------------------------------------------------

# 10. Summary

`mysqlsh` is a modern MySQL client that supports multiple scripting
languages and advanced administrative features.

Main advantages:

-   Multi-language support (SQL, Python, JavaScript)
-   Automation capabilities
-   Advanced administration tools
-   Better scripting compared to the classic `mysql` client
