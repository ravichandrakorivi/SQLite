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

SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- Run Time: real 0.017261 user 0.000000 sys 0.000000

DROP INDEX "person_index";

CREATE INDEX "person_index" ON "stars" ("person_id", "movie_id");
-- Run Time: real 0.982113 user 0.812500 sys 0.140625

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
-------------------------------------- Concurrency ------------------------------------------
---------------------------------------------------------------------------------------------


