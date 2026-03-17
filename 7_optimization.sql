--------------------------------------------------------------------------------
----------------------------- Optimization -------------------------------------
--------------------------------------------------------------------------------

-- sqlite3
.open movies.db
.schema

SELECT * FROM "movies" LIMIT 5;
SELECT * FROM "people" LIMIT 5;
SELECT * FROM "stars" LIMIT 5;
SELECT * FROM "ratings" LIMIT 5;

SELECT COUNT(*) FROM "movies";
SELECT COUNT(*) FROM "people";
SELECT COUNT(*) FROM "stars";
SELECT COUNT(*) FROM "ratings";

.timer on

SELECT * FROM "movies" WHERE "title" = 'Cars';
-- Run Time: real 0.093126 user 0.046875 sys 0.000000


--------------------------------------------------------------------------------
------------------------------------ Index -------------------------------------
------ A structure used to speed up the retrieval of rows from a table ---------
--------------------------------------------------------------------------------
CREATE INDEX "title_index" ON "movies" ("title");
-- Run Time: real 0.419912 user 0.328125 sys 0.062500

.schema

SELECT * FROM "movies" WHERE "title" = 'Cars';
-- Run Time: real 0.023709 user 0.000000 sys 0.015625

EXPLAIN QUERY PLAN SELECT * FROM "movies" WHERE "title" = 'Cars';
--SEARCH movies USING INDEX title_index (title=?)

DROP INDEX "title_index";
.schema

EXPLAIN QUERY PLAN SELECT * FROM "movies" WHERE "title" = 'Cars';
-- SCAN movies


SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- Run Time: real 0.390776 user 0.062500 sys 0.078125

EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- QUERY PLAN
-- |--SEARCH movies USING INTEGER PRIMARY KEY (rowid=?)
-- `--LIST SUBQUERY 2
--    |--SCAN stars
--    |--SCALAR SUBQUERY 1
--    |  `--SCAN people
--    `--CREATE BLOOM FILTER
-- Run Time: real 0.022990 user 0.031250 sys 0.000000


-- What is meant by SEARCH movies USING INTEGER PRIMARY KEY (rowid?)
  -- SQLite is not scanning the "movies " table.
  -- It is directly using the rowid index (very fast lookup).

-- What os rowid?
  -- When you declare a column like `id INTEGER PRIMARY KEY`,
  -- SQLite treats this column as an alias for the internal rowid.
  
  -- Every SQLite table (unless created with WITHOUT ROWID) 
  -- has a hidden column called: rowid.
    -- It is a unique 64-bit integer.
    -- Automatically assigned to each row
    -- Used internally for very fast lookups

-- Note that the "person_id" in "stars" & "name" in "people" are not PRIMARY KEYS.
-- Hence, SQLite is resorting to SCANNING in both these tables;


EXPLAIN QUERY PLAN SELECT "title" FROM "movies" WHERE "id" = 20;
-- QUERY PLAN
-- `--SEARCH movies USING INTEGER PRIMARY KEY (rowid=?)

EXPLAIN QUERY PLAN SELECT * FROM "people" WHERE "name" = 'John Belushi';
-- QUERY PLAN
-- `--SCAN people

EXPLAIN QUERY PLAN SELECT * FROM "people" WHERE "id" = 4;
-- QUERY PLAN
-- `--SEARCH people USING INTEGER PRIMARY KEY (rowid=?)


CREATE INDEX "person_index" ON "stars" ("person_id");
-- Run Time: real 0.576080 user 0.453125 sys 0.093750

CREATE INDEX "name_index" ON "people" ("name");
-- Run Time: real 0.895604 user 0.625000 sys 0.140625 

EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- QUERY PLAN
-- |--SEARCH movies USING INTEGER PRIMARY KEY (rowid=?)
-- `--LIST SUBQUERY 2
--    |--SEARCH stars USING INDEX person_index (person_id=?)
--    |--SCALAR SUBQUERY 1
--    |  `--SEARCH people USING COVERING INDEX name_index (name=?)
--    `--CREATE BLOOM FILTER
-- Run Time: real 0.040577 user 0.000000 sys 0.000000


---- Covering Index : An index in which queried data can be retrieved from the index itself (without any table lookup)

-- A covering index means, SQLite can answer the query using 
-- only the index, without touching the actual table.

-- Why Covering index on name_index only?
  -- In SQLite, every index automatically stores:
    -- The indexed column(s) (name)
    -- The rowid of the row
    -- And since `id INTEGER PRIMARY KEY`, id is the rowid
    -- So the index actually contains: (name, rowid),
    -- which is effectively: (name, id)

   -- Therefore, SQLite can:
     -- Find 'Tom Hanks' using name_index
     -- Directly get the id (via rowid)
     -- Never access the people table

  -- For stars, index contains (person_id, rowid)
  -- But we need "movie_id", which is not in the index
  -- So, SQLite must go to the table to fetch it
  

EXPLAIN QUERY PLAN SELECT "id", "title" FROM "movies" WHERE "title" = 'Cars';
-- QUERY PLAN
-- `--SEARCH movies USING COVERING INDEX title_index (title=?)

SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- Run Time: real 0.017261 user 0.000000 sys 0.000000

DROP INDEX "person_index";


-- How to make stars also use a covering index?
-- Create a composite index like below:

CREATE INDEX "person_movie_index" ON "stars" ("person_id", "movie_id");
-- Run Time: real 0.982113 user 0.812500 sys 0.140625

-- Now index contains: (person_id, movie_id, rowid)
-- Query can be fully satisfied from index
-- SQLite will say USING COVERING INDEX

EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- QUERY PLAN
-- |--SEARCH movies USING INTEGER PRIMARY KEY (rowid=?)
-- `--LIST SUBQUERY 2
--    |--SEARCH stars USING COVERING INDEX person_index (person_id=?)
--    |--SCALAR SUBQUERY 1
--    |  `--SEARCH people USING COVERING INDEX name_index (name=?)
--    `--CREATE BLOOM FILTER
-- Run Time: real 0.041880 user 0.000000 sys 0.000000

SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- Run Time: real 0.017132 user 0.000000 sys 0.00000

-- SELECT m.title
-- FROM movies m
-- JOIN stars s ON m.id = s.movie_id
-- JOIN people p ON p.id = s.person_id
-- WHERE p.name = 'Tom Hanks';




----------------------------------------------------------------------------------------------
--------------------------------- B-Tree (Balanced Trees) ------------------------------------
------ A balanced tree stucture (data structure) is commonly used to create and index --------
----------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------
------------------------------------- Partial Index ------------------------------------------
---------------- An index that includes only a subset of rows from a table -------------------
----------------------------------------------------------------------------------------------

CREATE INDEX "recents" ON "movies" ("title") WHERE "year" = 2023;
-- Run Time: real 0.184233 user 0.031250 sys 0.000000

SELECT "title" FROM "movies" WHERE "year" =  2023;
-- Run Time: real 8.048767 user 0.593750 sys 2.062500

EXPLAIN QUERY PLAN SELECT "title" FROM "movies" WHERE "year" =  2023;
-- QUERY PLAN
-- `--SCAN movies USING COVERING INDEX recents

EXPLAIN QUERY PLAN SELECT "title" FROM "movies" WHERE "year" =  1998;
-- QUERY PLAN
-- `--SCAN movies


---------------------------------------------------------------------------------------------
--------------------------------------- Vacuum ----------------------------------------------
---------------------------------------------------------------------------------------------

-- du -b movies.db
-- dir movies.db
-- 158,949,376 bytes

DROP INDEX "person_index";
.schema

-- dir movies.db
-- 158,949,376 bytes

DROP INDEX "name_index";
DROP INDEX "recents";

-- dir movies.db
-- 158,949,376 bytes

VACUUM;
-- dir movies.db
-- 100,388,864 bytes



---------------------------------------------------------------------------------------------
----------------------- Transaction : A unit of work in a database --------------------------
---------------------------------------------------------------------------------------------

-- Properties of transactions : ACID
  -- A : Atomicity
  -- C : Consistency
  -- I : Isolation
  -- D : Durability

.open bank.db
.schema

SELECT * FROM "accounts";

-- Transfer 10 dollars from Alice to Bob
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;

-- SELECT * FROM "accounts"; # Request from other terminal
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;

SELECT * FROM "accounts";

UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 2;
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 1;
SELECT * FROM "accounts";

BEGIN TRANSACTION;
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
-- SELECT * FROM "accounts"; # This request from other sys will not show wrong results
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;
-- SELECT * FROM "accounts";
COMMIT;

SELECT * FROM "accounts";


UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
-- SELECT * FROM "accounts"; # Request from other computer
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;
-- Runtime error: CHECK constraint failed: balance (19)

UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 2;
SELECT * FROM "accounts";

BEGIN TRANSACTION;
    UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
    UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;
ROLLBACK;

SELECT * FROM "accounts";

-------------------------- Race Conditions --------------------------------
------ Transactions have inbuilt property to ensure that transactions are 
------ executed sequentially withoutrace conditions


------------------------------ Locks --------------------------------------
------ UNLOCKED, SHARED, EXCLUSIVE etc. locks
BEGIN EXCLUSIVE TRANSACTION;
-- SELECT * FROM "accounts"; # from other computer
-- RUntime error: database is locked (5)



